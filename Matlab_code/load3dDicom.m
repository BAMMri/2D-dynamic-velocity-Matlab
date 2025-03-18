function [volume, info]=load3dDicom(dicom_folder)
% function [volume, info]=load3dDicom(dicom_folder)
%
% Loads a series of .dcm files (slices) into a volume (3d matrix)
% dicom_folder: base folder containing the .dcm files
%               OR cell array containing the paths to the single slices
%
% volume: 3d matrix x*y*slice
% info: array of dicominfo structures. Can be passed to save3dDicom

if (iscell(dicom_folder))
   nSlices = length(dicom_folder);
   
   i=dicominfo(dicom_folder{1});
   nRows=i.Rows;
   nCols=i.Columns;
   
   trueColor = strcmp(i.ColorType, 'truecolor');
   
   if trueColor
       volume=zeros(nRows, nCols, nSlices, 3); % creates a new 3d matrix RGB
   else
       volume=zeros(nRows, nCols, nSlices); % creates a 3d matrix
   end
   progressBar('init', 'Loading Dicom: ', 0, nSlices);
   for curslice=1:nSlices % cycles through the files and reads each slice
        progressBar('update', 'Loading Dicom: ', curslice, nSlices);
        info(curslice)=dicominfo(dicom_folder{curslice}); % reads the header
        if trueColor
            volume(:,:,curslice,:)=double(dicomread(info(curslice))) / 255; % reads the image data and normalizes it (truecolor values range from 0 to 255
        else
            volume(:,:,curslice)=dicomread(info(curslice)); % reads the image data
        end
   end
else
    dirlisting=dir(dicom_folder);
    % gets the listing of the directory

    files=[];

    for i=1:length(dirlisting)
        if strfind(dirlisting(i).name, '.dcm') % selects the .dcm files in the directory list
            files=strvcat(files, dirlisting(i).name); % appends each dicom file name to the files array
        end
    end

    files=cellstr(files); % converts the character matrix (string array) into a cell array for convenience

    i=dicominfo([dicom_folder filesep files{1}]); % reads the dicom header of the first slice to get the right size of the out volume
    nRows=i.Rows;
    nCols=i.Columns;
    nSlices=length(files); % the third dimension is the number of slices in the folder

    trueColor = strcmp(i.ColorType, 'truecolor');
   
    if trueColor
        volume=zeros(nRows, nCols, nSlices, 3); % creates a new 3d matrix RGB
    else
        volume=zeros(nRows, nCols, nSlices); % creates a 3d matrix
    end
    
    progressBar('init', 'Loading Dicom: ', 0, nSlices);
    for curslice=1:nSlices % cycles through the files and reads each slice
        progressBar('update', 'Loading Dicom: ', curslice, nSlices);
       info(curslice)=dicominfo([dicom_folder filesep files{curslice}]); % reads the header
        if trueColor
            volume(:,:,curslice,:)=double(dicomread(info(curslice))) / 255; % reads the image data
        else
            volume(:,:,curslice)=dicomread(info(curslice)); % reads the image data
        end
    end
    
end