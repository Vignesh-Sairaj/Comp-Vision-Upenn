% load the image we will experiment with
I = imresize(double(rgb2gray(imread('lena.png'))),[256 256]);

% build the Laplacian pyramid of this image with 6 levels
depth = 6;
L = laplacianpyr(I,depth);

% compute the quantization of the Laplacian pyramid
bins = [16,32,64,128,128,256]; % number of bins for each pyramid level
LC = encoding(L,bins);

% compute the entropy for the given quantization of the pyramid
ent = pyramident(LC);

% Use the collapse command of the Lab 3 to recover the image
Ic = collapse(LC);

% compute the snr for the recovered image
snr_c = compute_snr(I,Ic);

% use the code from Lab 2 to compute an approximation image with 
% the same level of compression approximately
[rows,cols] = size(I);
n_0 = rows*cols;
M = n_0/8;
Id = decompress(compress(I,sqrt(M)));
snr_d = compute_snr(I,Id);

% plot the resulting images
subplot(1,3,1); 
imshow(I,[]); title('Original image');
subplot(1,3,2); imshow(Ic,[]); 
title('Laplacian Encoding'); xlabel(['SNR = ' num2str(snr_c)]);
subplot(1,3,3); imshow(Id,[]); 
title('Fourier Approximation'); xlabel(['SNR = ' num2str(snr_d)]);



%% Code from Week 2


function [Fcomp] = compress(I,M_root)

    % Copy your code from Lab 2   
    
    % Input:
    % I: the input image
    % M_root: square root of the number of coefficients we will keep
    % Output:
    % Fcomp: the compressed version of the image

    % Please follow the instructions in the comments to fill in the missing commands.    
    
    % 1) Perform the FFT transform on the image (MATLAB command fft2).
    F = fft2(I);
    % 2) Shift zero-frequency component to center of spectrum (MATLAB command fftshift).
    Fs = fftshift(F);
    
    % We create a mask that is the same size as the image. The mask is zero everywhere, 
    % except for a square with sides of length M_root centered at the center of the image.
    [rows,cols] = size(I);
    idx_rows = abs((1:rows) - ceil(rows/2)) < M_root/2 ; 
    idx_cols = abs((1:cols)- ceil(cols/2)) < M_root/2 ; 
    M = (double(idx_rows')) * (double(idx_cols));
    
    % 3) Multiply in a pointwise manner the image with the mask.
    
    Fcomp = Fs.*M;

end

function [Id] = decompress(Fcomp)

    % Copy your code from Lab 2

    % Input:
    % F: the compressed version of the image
    % Output:
    % Id: the approximated image

    % Please follow the instructions in the comments to fill in the missing commands.    
    
    % 1) Apply the inverse FFT shift (MATLAB command ifftshift)

    Fun = ifftshift(Fcomp);
        
    % 2) Compute the inverse FFT (MATLAB command ifft2)
    
    Icplx = ifft2(Fun);

    % 3) Keep the real part of the previous output
    
    Id = real(Icplx);
end

function snr = compute_snr(I, Id)

    % Input:
    % I: the original image
    % Id: the approximated (noisy) image
    % Output:
    % snr: signal-to-noise ratio
    
    % Please follow the instructions in the comments to fill in the missing commands.    

    % 1) Compute the noise image (original image minus the approximation)
    noise = I-Id;
    
    % 2) Compute the Frobenius norm of the noise image
    nrm_noise = norm(noise, 'fro');
    
    % 3) Compute the Frobenius norm of the original image
    nrm_img = norm(I, 'fro');
    
    % 4) Compute SNR
    
    snr = -20*log10(nrm_noise./nrm_img);
end