
function H = compute_homography(p1,p2)		
    % use SVD to solve for H as was done in the lecture
    v = p1; u = p2;
    u1 = u(1, :)'; u2 = u(2, :)'; u3 = u(3, :)'; u4 = u(4, :)';
    v1 = v(1, :)'; v2 = v(2, :)'; v3 = v(3, :)'; v4 = v(4, :)';
    
    A1 = [ [[u1; 1]' zeros(1, 3);  zeros(1, 3) [u1; 1]'], -v1*[u1; 1]' ];
    A2 = [ [[u2; 1]' zeros(1, 3);  zeros(1, 3) [u2; 1]'], -v2*[u2; 1]' ];
    A3 = [ [[u3; 1]' zeros(1, 3);  zeros(1, 3) [u3; 1]'], -v3*[u3; 1]' ];
    A4 = [ [[u4; 1]' zeros(1, 3);  zeros(1, 3) [u4; 1]'], -v4*[u4; 1]' ];
    
    A = [A1; A2; A3; A4];
    
    [~, ~, vs] = svd(A);
    X = vs(:, end)./vs(end, end);
    H = reshape(X, 3, 3)';
end


