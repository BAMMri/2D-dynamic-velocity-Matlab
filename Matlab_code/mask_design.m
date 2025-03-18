%Choose mask

 head_folder=  uigetdir('/media/data/Archive/EXPERIMENTAL_DATA/Experiments_Muscle_FI/');
filename_mx =  uigetdir(head_folder);
namef= filename_mx((size(filename_mx,2)-13):size(filename_mx,2));
num0= str2double( filename_mx((size(filename_mx,2)-15)));
num=  str2double( filename_mx((size(filename_mx,2)-14)));

if num0>0
    num=num+num0*10;
end
if ((num+2)<10)
    filename_fx = [head_folder '/00' num2str(num+2) namef '_P'];
else
    filename_fx = [head_folder '/0' num2str(num+2) namef '_P'];
end
if ((num+4)<10)    
    filename_fy = [head_folder '/00' num2str(num+4) namef '_P'];
else
    filename_fy = [head_folder '/0' num2str(num+4) namef '_P'];
end
if ((num+6)<10)  
    filename_fz = [head_folder '/00' num2str(num+6) namef '_P'];
else
    filename_fz = [head_folder '/0' num2str(num+6) namef '_P'];
end    
drawnow
[mag_x, info_mx] = load3dDicom(filename_mx);

imagesc(mag_x(:,:,50));axis image
mask=roipoly;