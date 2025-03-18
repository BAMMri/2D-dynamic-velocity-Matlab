function E=std_strain_3D(Ux,Uy,Uz)
%Modified to calculate 3D from 2D data

% Calculate the Eulerian strain from displacement images
%
%  E = STRAIN(Ux,Uy)   or (3D)  E = STRAIN(Ux,Uy, Uz)
%
% inputs,
%   Ux,Uy: The displacement vector images in
%           x and y direction (same as registration variables Tx, Ty)
%   Uz: The displacement vector image in z direction.
%
% outputs,
%   E the 3-D Eulerian strain tensor images defined by Lai et al. 1993
%      with dimensions [SizeX SizeY 2 2] or in 3D [SizeX SizeY SizeZ 3 3]
%
% Source used:
%   Khaled Z et al. "Direct Three-Dimensional Myocardial Strain Tensor 
%   Quantification and Tracking using zHARP"
%
% Function is written by D.Kroon University of Twente (February 2009)

if(~exist('Uz','var')) % Detect if 2D or 3D inputs
    % Initialize output matrix
    E=zeros([size(Ux) 2 2]);
    % displacement images gradients
    [Uxy,Uxx] = gradient(Ux);
    [Uyy,Uyx] = gradient(Uy);
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            % The displacement gradient
            Ugrad=[Uxx(i,j) Uxy(i,j); Uyx(i,j) Uyy(i,j)];
            % The (inverse) deformation gradient
            Finv=[1 0;0 1]-Ugrad;  %F=inv(Finv); 
            % the 3-D Eulerian strain tensor
            e=(1/2)*([1 0;0 1]-Finv*Finv');
            % Store tensor in the output matrix
            E(i,j,:,:)=e;
        end
    end
else
    % Initialize output matrix
    E=zeros([size(Ux,1) size(Ux,2) size(Ux,3) 3 3]);%E=zeros([size(Ux) 3 3]);
    % displacement images gradients
    if ndims(Ux) < 3
        [Uxy,Uxx,Uxz] = gradient(repmat(Ux, [1 1 3]));
        [Uyy,Uyx,Uyz] = gradient(repmat(Uy, [1 1 3]));
        [Uzy,Uzx,Uzz] = gradient(repmat(Uz, [1 1 3]));
        
        % take central slice
        
        Uxx = Uxx(:,:,2);
        Uxy = Uxy(:,:,2);
        Uxz = Uxz(:,:,2);
        
        Uyx = Uyx(:,:,2);
        Uyy = Uyy(:,:,2);
        Uyz = Uyz(:,:,2);
        
        Uzx = Uzx(:,:,2);
        Uzy = Uzy(:,:,2);
        Uzz = Uzz(:,:,2);
    else
        [Uxy,Uxx,Uxz] = gradient(Ux);
        [Uyy,Uyx,Uyz] = gradient(Uy);
        [Uzy,Uzx,Uzz] = gradient(Uz);
    end
    % Loop through all pixel locations
    for i=1:size(Ux,1)
        for j=1:size(Ux,2)
            for k=1:size(Ux,3)
                % The displacement gradient
                Ugrad=[Uxx(i,j,k) Uxy(i,j,k) Uxz(i,j,k); Uyx(i,j,k) Uyy(i,j,k) Uyz(i,j,k);Uzx(i,j,k) Uzy(i,j,k) Uzz(i,j,k)];
                % The (inverse) deformation gradient
                Finv=[1 0 0;0 1 0;0 0 1]-Ugrad; %F=inv(Finv);
                % the 3-D Eulerian strain tensor
                e=(1/2)*([1 0 0;0 1 0;0 0 1]-Finv*Finv');
                % Store tensor in the output matrix
                E(i,j,k,:,:)=e;
            end
        end
    end
end

 
