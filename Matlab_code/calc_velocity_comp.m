function [p1_3D_A1,p2_3D_A1,f]=calc_velocity_comp(flow_x,flow_y,flow_z)
for iP=1:size(flow_x,3)

           for ix=1:size(flow_x,1)
              for iy=1:size(flow_y,2)
            
                    flow_3D_A1(ix,iy,iP) = sqrt(power(flow_x(ix,iy,iP),2)+power(flow_y(ix,iy,iP),2)+power(flow_z(ix,iy,iP),2));
               
              end
           end
              
end
limG=0.25;
for iP=1:size(flow_3D_A1,3)
    flow_3D_A1(:,:,iP)=flow_3D_A1(:,:,iP).*(flow_3D_A1(:,:,iP)>limG);    
    f(iP)=median(nonzeros(flow_3D_A1(:,:,iP)));

end

p1_3D_A1=max(f(1:45));
p2_3D_A1=max(f(45:90));

