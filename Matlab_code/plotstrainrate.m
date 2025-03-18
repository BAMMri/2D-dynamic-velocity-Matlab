figure, plot(time_ser/1000,r_Srs,'LineWidth',2);
ylabel('\fontsize{14}median of strain rate [1/s]')
xlabel('\fontsize{14}t [s]')
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylim([0 0.1]);
xlim([0 3.5]);
title('\fontsize{14}median of strain rate stretch component in ROI');
filename=['sr_stretch'];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')

figure, plot(time_ser/1000,r_Srs2,'LineWidth',2);
ylabel('\fontsize{14}median of strain rate [1/s]]')
xlabel('\fontsize{14}t [s]')
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylim([-0.1 0]);
xlim([0 3.5]);
title('\fontsize{14}median of strain rate compression component in ROI');
filename=['sr_compr'];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')