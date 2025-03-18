%% Calculate Displacement Vectors from PC data
function [dispVxi,dispVyi,dispVzi,t]=std_displacement_PC(dt,nPhases,nPoints,flow_x,flow_y,flow_z,info_fx,info_fy,info_fz,mask,bOption)
interp_factor=1;
t = cputime;

dt= info_fx(1,2).RepetitionTime/interp_factor;% ms

TE=[1:size(flow_x,3)].*dt;% ms

nPhases = (info_fx(1).CardiacNumberOfImages)*interp_factor;

x=zeros(nPoints,nPhases);y=zeros(nPoints,nPhases);
u=zeros(nPoints,nPhases);v=zeros(nPoints,nPhases); w=zeros(nPoints,nPhases);
dx=zeros(nPoints,nPhases);dy=zeros(nPoints,nPhases);dz=zeros(nPoints,nPhases);

dispVx =zeros(size(flow_x));dispVy =zeros(size(flow_y));dispVz =zeros(size(flow_z));
if bOption==1
    diffDispX = 10*flow_x*dt/info_fx(1).PixelSpacing(1)/1000; % conversion cm->mm and ms->s
    diffDispY = 10*flow_y*dt/info_fy(1).PixelSpacing(1)/1000;
    diffDispZ = 10*flow_z*dt/info_fz(1,1).SliceThickness/1000;
else
    diffDispX = 10*flow_x*0.5.*dt/info_fx(1).PixelSpacing(1)/1000; % conversion cm->mm and ms->s
    diffDispY = 10*flow_y*0.5.*dt/info_fy(1).PixelSpacing(1)/1000;
    diffDispZ = 10*flow_z*0.5.*dt/info_fz(1,1).SliceThickness/1000;
end

% Precalculate interpolated maps
[X,Y] = ndgrid(1:size(diffDispX,1),1:size(diffDispX,2));
[Xq,Yq] = ndgrid(1:0.1:size(diffDispX,1),1:0.1:size(diffDispX,2));
interpDispX =zeros(size(Xq,1),size(Xq,2),size(diffDispX,3));
interpDispY =zeros(size(Xq,1),size(Xq,2),size(diffDispX,3));
interpDispZ =zeros(size(Xq,1),size(Xq,2),size(diffDispX,3));

for iph=1:nPhases

    ivx = griddedInterpolant(X,Y,squeeze(diffDispX(:,:,iph)),'spline');
    ivy = griddedInterpolant(X,Y,squeeze(diffDispY(:,:,iph)),'spline');
    ivz = griddedInterpolant(X,Y,squeeze(diffDispZ(:,:,iph)),'spline');
   
    nx=  ivx(Xq,Yq);
    ny = ivy(Xq,Yq);
    nz = ivz(Xq,Yq);
    
    interpDispX(:,:,iph) = nx;
    interpDispY(:,:,iph) = ny;
    interpDispZ(:,:,iph) = nz;
end

ActInterpFacX = (size(interpDispX,1)/size(diffDispX,1));
ActInterpFacY = (size(interpDispY,2)/size(diffDispY,2));

if bOption==1 % Constrained Forward
    for ix = 1:  size(flow_x,1)
            for iy = 1: size(flow_y,2)
                for iph=2:nPhases
                    if  mask(ix,iy)==1 
                       newX = ix + dispVx(ix,iy,iph-1);
                       newY = iy + dispVy(ix,iy,iph-1);

                       deltaDispX =    interp2(diffDispX(:,:,iph-1), newY, newX); %       deltaDispX = diffDispX(round(newX), round(newY), iph-1);    
                       deltaDispY =    interp2(diffDispY(:,:,iph-1), newY, newX);          %deltaDispY = diffDispY(round(newX), round(newY), iph-1);
                       deltaDispZ =    interp2(diffDispZ(:,:,iph-1), newY, newX);%diffDispZ(round(newX), round(newY), iph-1); 

                       dispVx(ix, iy, iph) = dispVx(ix,iy,iph-1) + deltaDispX;
                       dispVy(ix, iy, iph) = dispVy(ix,iy,iph-1) + deltaDispY;
                       dispVz(ix, iy, iph) = dispVz(ix,iy,iph-1) + deltaDispZ;
                     end
                end
            end
    end
else % Forward/ Backward with Forward integration
 for iph=2:nPhases
    for ix = 1:  size(flow_x,1)
            for iy = 1: size(flow_y,2)
               
                    if  mask(ix,iy)==1 
                       newXn = ix + dispVx(ix,iy,iph);
                       newYn = iy + dispVy(ix,iy,iph);

                       newXnm1 = ix - dispVx(ix,iy,iph-1);
                       newYnm1 = iy - dispVy(ix,iy,iph-1);
                       
                       [inewXnm1, inewYnm1] = calcInterpolatedIndex(newXnm1, newYnm1);
                       [inewXn, inewYn] = calcInterpolatedIndex(newXn, newYn);
                                        
                       deltaDispX = + interpDispX(inewXnm1,inewYnm1,iph-1)+ interpDispX(inewXn,inewYn,iph);
                       deltaDispY = + interpDispY(inewXnm1,inewYnm1,iph-1)+ interpDispY(inewXn,inewYn,iph);
                       deltaDispZ = + interpDispZ(inewXnm1,inewYnm1,iph-1)+ interpDispZ(inewXn,inewYn,iph);

                       dispVx(ix,iy,iph) = dispVx(ix,iy,iph-1) + deltaDispX;
                       dispVy(ix,iy,iph) = dispVy(ix,iy,iph-1) + deltaDispY;
                       dispVz(ix,iy,iph) = dispVz(ix,iy,iph-1) + deltaDispZ;
               
                     end
            end
        end
    end
end

% output displacement is in mm
dispVxi = info_fx(1).PixelSpacing(1) .* dispVx;
dispVyi = info_fy(1).PixelSpacing(2) .* dispVy;
dispVzi = info_fz(1,1).SliceThickness .* dispVz;
    % Interpolate coordinates
    function [interpX, interpY] = calcInterpolatedIndex(x,y)
        
        interpX = round( (x-1)*ActInterpFacX  + 1);
        interpY = round( (y-1)*ActInterpFacY  + 1);

        if (interpX<1)
            interpX=1;
        elseif  (interpX>size(interpDispX,1))
                interpX=size(interpDispX,1);
        end
        if (interpY<1)
           interpY=1;
        elseif  (interpY>size(interpDispY,2))
                interpY=size(interpDispY,2);
        end
    end

end