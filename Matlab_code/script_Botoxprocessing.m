% script für processing of Botox-data
% prerequisite: calulation of velocity done with std_velocity _visualization
% workspace contains  flow, time_ser, mask, dt
[dispVxi,dispVyi,dispVzi,t]=std_displacement_PC(dt,nPhases,nPoints,flow_x,flow_y,flow_z,info_fx,info_fy,info_fz,mask,0);
[Eig_v,Eig_SR,s_angle]=std_plot_strain_new(dispVxi,dispVyi,dispVzi,1,mask,flow_x,flow_y);
% 4D data of strain Eig_v with max./min.  eigenvalues in  :,:,1:   stretching/:,:,2,:   compression
% 4D data of strain rate Eig_SR
[e1_max,e2_max,magn_e,e1_Line, e2_Line,MagnE_Line]=std_strain_full(Eig_v,mask);
% time course of strain component 1 and 2 e1_line and e2_line in ROI
[peak1s, peak2s,r_Srs]=std_SR1_comp(Eig_SR,0.0);
[peak1s2, peak2s2,r_Srs2]=std_SR2_comp(Eig_SR,0.0);
% time course of strain rate component 1 (and 2) r_Srs(2)  in ROI, returns position of first max

% plotting of time courses (medians in ROI) with scripts:
plotspeed
filename=['speed'];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')
plotstrain
plotstrainrate

% find velocity peaks
mitte=round(size(flow_3D,1)/2)
firstpeak=find(flow_3D(2:mitte)==(max(flow_3D(2:mitte))))
secondpeak=mitte-1+find(flow_3D(mitte:size(flow_3D,1))==(max(flow_3D(mitte:size(flow_3D,1)))))

%display maps
figure, imagesc(Eig_v(:,:,1,mitte));
axis image; axis off
colormap hot;colorbar
title(['\fontsize{14}strain stretching component, frame ', num2str(mitte)]);
c = colorbar;
c.FontSize=14;
filename=['strain_stretch_frame' num2str(mitte)];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')
figure, imagesc(Eig_v(:,:,2,mitte));
axis image; axis off
colormap hot;colorbar
title(['\fontsize{14}strain compression component, frame ', num2str(mitte)]);
c = colorbar;
c.FontSize=14;
filename=['strain_compr_frame' num2str(mitte)];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')

figure, imagesc(Eig_SR(:,:,1,firstpeak));
axis image; axis off
colormap hot;colorbar
title(['\fontsize{14}strain rate stretching component [1/s], frame ', num2str(firstpeak)]);
c = colorbar;
c.FontSize=14;
filename=['sr_stretch_frame' num2str(firstpeak)];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')
figure, imagesc(Eig_SR(:,:,2,firstpeak));
axis image; axis off
colormap hot;colorbar
title(['\fontsize{14}strain rate compression component [1/s], frame ', num2str(firstpeak)]);
c = colorbar;
c.FontSize=14;
filename=['sr_compr_frame' num2str(firstpeak)];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')
