function cr = compute_cr(I,M)

    % Input:
    % I: the original image
    % M: the number of coefficients stored for the compressed image
    % Output:
    % cr: the compression ratio
    
    % Please follow the instructions in the comments to fill in the missing commands.
    
    % 1) Compute the number of coefficients stored for the original image
    [nr, nc] = size(I);
    % 2) Compute the compression ratio
    cr = nr*nc/M;
end