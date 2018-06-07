function g = reduce(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after Gaussian blurring and subsampling

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    
    G = fspecial('gaussian', 5, 1);

    % 2) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    
    Ifilt = imfilter(I, G);
    
    % 3) Subsample the image by a factor of 2
    % i.e., keep only 1st, 3rd, 5th, .. rows and columns
    
    [nr, nc, nd] = size(I);
    Isub = zeros(round(nr/2), round(nc/2), nd);
    
    for  i = 1:round(nr/2)
        for  j = 1:round(nc/2)
            Isub(i, j, :) = Ifilt(2*i-1, 2*j-1, :);
        end
    end

    g = Isub;
    
end
