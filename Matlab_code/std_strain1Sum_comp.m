function [r,rA1a]=std_strain1_comp(Eig_v_A1_0)


lim=0.25;

for i=2:94 
  cSl=45;
    Eig_v_A1(:,:,1,i)=(Eig_v_A1_0(:,:,1,cSl)>lim).*Eig_v_A1_0(:,:,1,i);  

end

for i=2:94
cSl=i;
    rA1a(i)=0.01*round(100.*median(nonzeros(squeeze(Eig_v_A1(:,:,1,i)))'));
  
  
end



% plot(rA1a,'k','LineWidth',3)
% hold on
% ylim([0 0.3]);
% xlim([0 94])
% plot(rA2a,'k-.','LineWidth',3)



r=0.001.*round(1000.*[max(rA1a)]);