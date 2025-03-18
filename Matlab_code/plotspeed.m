figure, plot(time_ser/1000,flow_3D,'LineWidth',2);
ylabel('\fontsize{14}median of mag. of velocity [cm/s]')
xlabel('\fontsize{14}t [s]')
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylim([0 0.3]);
xlim([0 3.5]);
title('\fontsize{14}contraction velocity in ROI');