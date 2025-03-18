
function [peak1, peak2,rA1a]=std_SR1_comp(A1,limG)
%Compare strain rate 1
[eig_SR_A1]=filterM(A1,limG);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mitte=round(size(A1,4)/2)


for i=2:size(A1,4)
    rA1a(i)=(median(nonzeros(eig_SR_A1(:,:,1,i))'));
   
end
% choose timepoint between the peaks
A=rA1a(1:mitte);

p1_a1=max(rA1a(1:mitte));  find(A==(max(max(A))))
plot(A)

p2_a1=max(rA1a(mitte:size(A1,4)));




%%Peak 1
peak1=0.01.*round(100.*[p1_a1]);
peak2=0.01.*round(100.*[p2_a1]);



function eign = filterM(eig0,limG)
% filter
for z=2:size(eig0,4)
    
    eign(:,:,1,z)=medfilt2(eig0(:,:,1,z).*(eig0(:,:,1,z)>limG));

end
