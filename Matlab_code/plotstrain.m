figure, plot(time_ser/1000,e1_Line,'LineWidth',2);
ylabel('\fontsize{14}median of strain]')
xlabel('\fontsize{14}t [s]')
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylim([0 0.2]);
xlim([0 3.5]);
title('\fontsize{14}median of strain stretch component in ROI');
filename=['strain_stretch'];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')

figure, plot(time_ser/1000,e2_Line,'LineWidth',2);
ylabel('\fontsize{14}median of strain]')
xlabel('\fontsize{14}t [s]')
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylim([0 0.2]);
xlim([0 3.5]);
title('\fontsize{14}median of magnitude of strain compression component in ROI');
filename=['strain_compr'];
saveas(gcf,filename,'emf')
saveas(gcf,filename,'fig')