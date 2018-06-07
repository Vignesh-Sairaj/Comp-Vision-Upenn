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