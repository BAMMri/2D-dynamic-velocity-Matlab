function [e1_max,e2_max,magn_e,e1_Line, e2_Line,MagnE_Line]=std_strain_full(Eig_v_A1_0,mask)

Eig_v_A1=Eig_v_A1_0;

for i=2:size(Eig_v_A1_0,4)
    cSl=round(size(Eig_v_A1_0,4)/2);
    Eig_v_A1(:,:,1,i)=mask.*Eig_v_A1_0(:,:,1,i);
    Eig_v_A1(:,:,2,i)=mask.*Eig_v_A1_0(:,:,2,i);  
    MagnitudeE(:,:,i)=squeeze(Eig_v_A1(:,:,1,i)).*squeeze(Eig_v_A1(:,:,2,i));
  end

%%CHOICE OF MEAN Jan 2018, median cw 4/2020
for i=2:size(Eig_v_A1_0,4)
    cSl=i;
    E=Eig_v_A1(:,:,1,i);
%     e1_Line(i)=0.001*round(1000.*mean(nonzeros(squeeze(E))'));
%     e2_Line(i)=0.001*round(1000.*mean(abs(nonzeros(squeeze(Eig_v_A1(:,:,2,i)))')));
%     MagnE_Line(i)=abs(0.001*round(1000.*mean((nonzeros(MagnitudeE(:,:,i))'))));
    e1_Line(i)=0.001*round(1000.*median(nonzeros(squeeze(E))'));
    e2_Line(i)=0.001*round(1000.*median(abs(nonzeros(squeeze(Eig_v_A1(:,:,2,i)))')));
    MagnE_Line(i)=abs(0.001*round(1000.*mean((nonzeros(MagnitudeE(:,:,i))'))));
end

e1_max=0.001.*round(1000.*[max(e1_Line)]);%First strain
e2_max=0.001.*round(1000.*[max(e2_Line)]);%Second strain
magn_e=0.001.*round(1000.*[max(MagnE_Line)]);%"Magnitude Strain"

