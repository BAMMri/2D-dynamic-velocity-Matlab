% % % % % % % % % %Calculate motion field

% %Adapt variables
venc = 25;%cm/s sAngio.sFlowArray.asElm[0].nVelocity
thres=20;  %mag_x has to be > thres
scale_factor =16;step=1;   % scale_factor for length of vectors for visualization
tDelay =5;%trigger delay sPhysioImaging.sPhysioExt.lTriggerDelay/1000
%AcqTime=input('Acq Time: ');%5500 for multislice protocol with ramp 2s 1; 1400 for repeatability multislice; 3500 for multislice Botox5 % 
AcqTime=3500;
slice=input('Slice: ');
head_folder_name=input('insert head folder name: '); 
%head_folder=  uigetdir('/media/data/Archive/EXPERIMENTAL_DATA/Experiments_Muscle_FI/');
 head_folder=  uigetdir(head_folder_name);
filename_mx =  uigetdir(head_folder);
limit=28;%001_FL_PC_3DIR number of letters from 0001_ on, usually 13; here 29 for Botox04, 28 for Botox05; 33 for left, 34 for right
namef= filename_mx((size(filename_mx,2)-limit):size(filename_mx,2));
num0= str2double( filename_mx((size(filename_mx,2)-(limit+2))));
num=  str2double( filename_mx((size(filename_mx,2)-(limit+1))));

if num0>0
    num=num+num0*10;
end
if ((num+2)<10)
    filename_fx = [head_folder '\00' num2str(num+2) namef '_P'];
else
    filename_fx = [head_folder '\0' num2str(num+2) namef '_P'];
end
if ((num+4)<10)    
    filename_fy = [head_folder '\00' num2str(num+4) namef '_P'];
else
    filename_fy = [head_folder '\0' num2str(num+4) namef '_P'];
end
if ((num+6)<10)  
    filename_fz = [head_folder '\00' num2str(num+6) namef '_P'];
else
    filename_fz = [head_folder '\0' num2str(num+6) namef '_P'];
end    
drawnow

[mag_x_multi, info_mx] = load3dDicom(filename_mx);
[flow_x0_multi, info_fx] = load3dDicom(filename_fx);
[flow_y0_multi, info_fy] = load3dDicom(filename_fy);
[flow_z0_multi, info_fz] = load3dDicom(filename_fz);
nPhases = info_fx(1).CardiacNumberOfImages;
%%%%%Claudia: split dataset into slices, extract and proceed with one slice
mag_x_multi=reshape(mag_x_multi,size(mag_x_multi,1),size(mag_x_multi,2),size(mag_x_multi,3)/nPhases,nPhases);
mag_x=reshape(mag_x_multi(:,:,slice,:),size(mag_x_multi,1),size(mag_x_multi,2),nPhases);
flow_x0_multi=reshape(flow_x0_multi,size(flow_x0_multi,1),size(flow_x0_multi,2),size(flow_x0_multi,3)/nPhases,nPhases);
flow_x0=reshape(flow_x0_multi(:,:,slice,:),size(flow_x0_multi,1),size(flow_x0_multi,2),nPhases);
flow_y0_multi=reshape(flow_y0_multi,size(flow_y0_multi,1),size(flow_y0_multi,2),size(flow_y0_multi,3)/nPhases,nPhases);
flow_y0=reshape(flow_y0_multi(:,:,slice,:),size(flow_y0_multi,1),size(flow_y0_multi,2),nPhases);
flow_z0_multi=reshape(flow_z0_multi,size(flow_z0_multi,1),size(flow_z0_multi,2),size(flow_z0_multi,3)/nPhases,nPhases);
flow_z0=reshape(flow_z0_multi(:,:,slice,:),size(flow_z0_multi,1),size(flow_z0_multi,2),nPhases);

%%%%%%%%%%%%
mag_x=mag_x(:,1:size(mag_x,2),:);
x_i=9;
flow_x0 = flow_x0(:,x_i:size(mag_x,2),:);
flow_y0 = flow_y0(:,x_i:size(mag_x,2),:);
flow_z0 = flow_z0(:,x_i:size(mag_x,2),:);
mag_x = mag_x(:,x_i:size(mag_x,2),:);
%%%%Add zeros
r_dim=110;
flow_x2=zeros(128,r_dim,size(flow_x0,3));flow_y2=zeros(128,r_dim,size(flow_x0,3));flow_z2=zeros(128,r_dim,size(flow_x0,3));mag2=zeros(128,r_dim,size(flow_x0,3));
flow_x2(:,(r_dim-size(flow_x0,2)+1):r_dim,:)=flow_x0;flow_y2(:,(r_dim-size(flow_x0,2)+1):r_dim,:)=flow_y0;flow_z2(:,(r_dim-size(flow_x0,2)+1):r_dim,:)=flow_z0;mag2(:,(r_dim-size(flow_x0,2)+1):r_dim,:)=mag_x;
flow_x0=flow_x2;flow_y0=flow_y2;flow_z0=flow_z2;mag_x=mag2;
% % % %%%% mask
if (exist('mask')==0)
    figure(3)
    imagesc(mag_x(:,:,5)); colormap gray; axis image
    mask=roipoly; 
end
    nPoints= nnz(mask);
% %%%%% split XYZ
 %close all
myfilter = fspecial('gaussian',[3 3], 0.5);
flow_x = zeros(size(flow_x0)); flow_y = zeros(size(flow_y0)); flow_z = zeros(size(flow_z0));

for iph = 1:nPhases    
     for ix=1:size(flow_x0,1)
         for iy=1:size(flow_x0,2)
                    
                 if (mag_x(ix,iy,iph)>thres)
                     %%%%Flow given in cm/sec
                    flow_x(ix,iy,iph) = mask(ix,iy)*((flow_x0(ix,iy,iph) - 2048)/2048); flow_x(ix,iy,iph) = (flow_x(ix,iy,iph) * venc);
                    flow_y(ix,iy,iph) = mask(ix,iy)*((flow_y0(ix,iy,iph) - 2048)/2048); flow_y(ix,iy,iph) = (flow_y(ix,iy,iph) * venc);
                    flow_z(ix,iy,iph) = mask(ix,iy)*((flow_z0(ix,iy,iph) - 2048)/2048); flow_z(ix,iy,iph) = (flow_z(ix,iy,iph) * venc);     
                else
                    flow_x(ix,iy,iph)=0;
                    flow_y(ix,iy,iph)=0;
                    flow_z(ix,iy,iph)=0;
                end

        end
     end      
     
    flow_x(:,:,iph)=medfilt2(flow_x(:,:,iph),[3 3]);
    flow_y(:,:,iph)=medfilt2(flow_y(:,:,iph),[3 3]);
    flow_z(:,:,iph)=medfilt2(flow_z(:,:,iph),[3 3]);
end
averageIm_x = mean(flow_x,3);averageIm_y = mean(flow_y,3);averageIm_z = mean(flow_z,3);

interp_factor=input('Give interpolation factor: ');       
 %Shading Correction??
flow_x = std_interpDataset( flow_x-repmat(averageIm_x, [1 1 nPhases]), interp_factor);
flow_y = std_interpDataset( flow_y-repmat(averageIm_y, [1 1 nPhases]), interp_factor);
flow_z = std_interpDataset( flow_z-repmat(averageIm_z, [1 1 nPhases]), interp_factor);

mag_x = std_interpDataset(mag_x, interp_factor);

h = figure();

dt= round(10*(info_fx(1,7).RepetitionTime)/interp_factor)*0.1;

maxQ=zeros(size(flow_x, 3),1);
bVis=input('Visualize/ Save Velocity (Y/N=1/0): ');
leg=input('R or L: 1/0: ');

if (bVis==1)

%         for i=1:size(flow_x, 3)
%             hold off
%            % h=figure(i);
%             imagesc(mag_x(1:step:end,1:step:end,i)); colormap gray; axis image;caxis([0 600])
%             title(['Frame ' num2str(i)])
%             hold on
% 
%             [maxQr(i), maxQg(i)]=fs_quiver((flow_x(1:step:end,1:step:end,i))*scale_factor, (flow_y(1:step:end,1:step:end,i))*scale_factor);
%             time_frame= i*dt;
%             time_ser(i)=(tDelay+time_frame);
%             text(65,13,['t=' num2str(tDelay+time_frame) ' ms'],'Color','w','Fontsize',15);
%             plotClock(82,13,10,(tDelay+time_frame)/AcqTime,'w')
%         end
        %% Color axis set to proper Maximum
        for i=1:size(flow_x, 3)
            hold off
           % h=figure(i);
            imagesc(mag_x(1:step:end,1:step:end,i)); colormap gray; axis image;caxis([0 300])
            title(['Frame ' num2str(i)])
            hold on

            fs_quiver_color((flow_x(1:step:end,1:step:end,i))*scale_factor, (flow_y(1:step:end,1:step:end,i))*scale_factor,(flow_z(1:step:end,1:step:end,i))*scale_factor,0,0,size(flow_x,1),size(flow_x,2));
            time_frame= i*dt;
            time_ser(i)=(tDelay+time_frame);
          
            if leg==0
%                text(22,13,['t=' num2str(tDelay+time_frame) ' ms'],'Color','w','Fontsize',15);
                plotClock(12,113,10,(tDelay+time_frame)/AcqTime,'w')
            else
              % text(6,93,[num2str(tDelay+time_frame) ' ms'],'Color','w','Fontsize',15);
                plotClock(96,113,10,(tDelay+time_frame)/AcqTime,'w')
            end
            set(gca,'XTick',[])
            set(gca,'YTick',[])
         saveas(h,sprintf('velMap_%03d.jpg',i)) 
        end

end

f3D= sqrt(power(flow_x,2)+power(flow_y,2)+power(flow_z,2));


for iP=1:size(flow_x,3)
%    f3D(:,:,iP)=f3D(:,:,iP).*(f3D(:,:,iP)>0.25); % commented by Claudia,
%    square is done in line 159, so no need to do it double?!
%    f3D(:,:,iP)=f3D(:,:,iP).*(f3D(:,:,iP));
    im=1;
           for ix=1:size(flow_x,1)
              for iy=1:size(flow_y,2)
                if mask(ix, iy)==1 

                    real_flow_3D(iP,im) = f3D(ix,iy,iP);

                    im=im+1;
                end
              end
           end
                  
end

flow_3D=median((real_flow_3D),2);

std_3D=std(real_flow_3D',1);

for iP=1:size(flow_x,3)
    im=1;
for ix=1:size(flow_x,1)
     for iy=1:size(flow_y,2)
         if mask(ix, iy)==1                
              real_flow_2D(iP,im) = sqrt(power(flow_x(ix,iy,iP),2)+power(flow_y(ix,iy,iP),2));
      
                    im=im+1;
         end
     end
end
                  
end

flow_2D=median(real_flow_2D,2);
