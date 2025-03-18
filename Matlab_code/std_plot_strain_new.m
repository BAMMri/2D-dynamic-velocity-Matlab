function [Eig_v,Eig_SR,s_angle]=std_plot_strain_new(Ux_all,Uy_all,Uz_all,b3D,mask,flow_x,flow_y)%s_angle zugefügt
%function [Eig_v,trace_Str,absE,str,Eig_v3,trace_Str3,absE3,str3,Eig_SR,str_rate1,str_rate2,e_str_rate1,e_str_rate2]=roi_plot_strain(Ux_all,Uy_all,Uz_all,b3D,mask,flow_x,flow_y)

Eig_v= zeros(size(Ux_all,1),size(Ux_all,2),2,size(Ux_all,3));
Eig_SR= zeros(size(Ux_all,1),size(Ux_all,2),2,size(Ux_all,3));

%Create a filter to use through MaxPlot, filter created once
createFilterforGradient

for i= 2:size(Ux_all,3)
    
   s= strain2D(Ux_all(:,:,i),Uy_all(:,:,i),filter_columns);  %written by Dr Kroon Twente
   sr0= std_strain_rate(flow_x(:,:,i),flow_y(:,:,i));
   
%    if (b3D==1)
%      s3= squeeze(std_strain_3D(Ux_all(:,:,i),Uy_all(:,:,i),Uz_all(:,:,i)));  %written by Dr Kroon Twente
%    end
   
   s(isnan(s)) = 0; 
%   s3(isnan(s3)) = 0; 
   sr0(isnan(sr0)) = 0; 
 
   for ix=1:size(Ux_all,1)
       for iy=1:size(Uy_all,2)
           
            if (mask(ix,iy) == 1)
            % 2D 
            Eig_v(ix,iy,:,i)  = sort(eig(squeeze(s(ix,iy,:,:))),'descend');% e1 (stretching), e2 (compression)
            et=eig(squeeze(sr0(ix,iy,:,:)));% e1 (stretching), e2 (compression);
            %Calcuate angle for the strain 
            [V,D] = eig(squeeze(s(ix,iy,:,:)));
             s_angle(ix,iy,i)=0.5*atan(2*V(1,2)/(V(1,1)-V(2,2)))*180/pi      ;   
            for it=1:2
                if et(it)>0
                    Eig_SR(ix,iy,1,i) = et(it);
                elseif et(it)<0
                    Eig_SR(ix,iy,2,i) = et(it);
                end
            end
%             % 3D
%             if (b3D==1)
%                 
%                 Eig_v3(ix,iy,:,i) = sort(eig(squeeze(s3(ix,iy,:,:))),'descend');% e1 (stretching), e2 (compression)
%             end
        end
    end
   end
end

% figure;imagesc((Eig_v(:,:,2,57)));axis image;caxis([-3 2]);
% mask=roipoly;
% 
% m1=1; bm1 =mask(:,:); ind=find(bm1==0); bm1(ind)=[]; clear ind ;
% %Slice selection
% for iz = 1:size(Eig_v,4)
%  
%     for ix = 1:size(Eig_v,1)
%         for iy = 1:size(Eig_v,2)
% 
%         if (mask(ix,iy) == 1)
% 
%                  roi_s(m1, 1:size(Eig_v,4) ) = Eig_v(ix,iy,2,iz);
%                  roi_sr1(m1, 1:size(Eig_v,4) )= Eig_SR(ix,iy,1,iz);
%                  roi_sr2(m1, 1:size(Eig_v,4) )= Eig_SR(ix,iy,2,iz);
% %                     if (b3D==1)
% %                  roi_s3(m1, 1:size(Eig_v3,4) )= Eig_v3(ix,iy,2,iz);   
% %                     end
% 
%                  if m1>=size(bm1,2)
%                      m1=1;
%                  else
%                      m1=m1+1;
%                  end
%                  
%         end
%         end
%  
%         end
%     str(iz)= mean(roi_s(:,iz),1);
%     str_rate1(iz)= mean(roi_sr1(:,iz),1);e_str_rate1(iz)= std(roi_sr1(:,iz),1);
%     str_rate2(iz)= mean(roi_sr2(:,iz),1);e_str_rate2(iz)= std(roi_sr2(:,iz),1);
%        if (b3D==1)
%     str3(iz)= mean(roi_s3(:,iz),1);
%        end
% 
% end
%Strain Invariant- Vomumetric Strain or Dilatation
% %2D
% trace_Str= Eig_v(:,:,1,:)+Eig_v(:,:,2,:);%trace giving information about fractional Volume Change
% absE=Eig_v(:,:,1,:).*Eig_v(:,:,2,:);%Absolute Strain Magnitude
% %3D
% if (b3D==1)
%     trace_Str3= Eig_v3(:,:,1,:)+Eig_v3(:,:,2,:)+Eig_v3(:,:,3,:);%trace giving information about fractional Volume Change
%      inv3= Eig_v3(:,:,1,:).*Eig_v3(:,:,1,:)+Eig_v3(:,:,2,:).*Eig_v3(:,:,2,:)+Eig_v3(:,:,3,:).*Eig_v3(:,:,3,:);
%     absE3=(Eig_v3(:,:,1,:).*Eig_v3(:,:,2,:)).*Eig_v3(:,:,3,:);%Absolute Strain Magnitude
% else
%         Eig_v3=Eig_v;
%         trace_Str3=trace_Str;
%         absE3=absE;
%         str3=str;
% end
%    
