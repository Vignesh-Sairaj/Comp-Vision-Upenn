buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);
I1 = readimage(buildingScene, 1);
I2 = readimage(buildingScene, 2);

p1 = [ 366.6972  106.9789
  439.9366   84.4437
  374.5845  331.2042
  428.6690  326.6972 ];

p2 = [ 115.0000  120.0000
  194.0000  107.0000
  109.0000  351.0000
  169.0000  346.0000 ];

figure()
imshow(I1);
hold on;
plot(p1(:,1),p1(:,2),'go')
hold off;

figure()
imshow(I2);
hold on;
plot(p2(:,1),p2(:,2),'go')
hold off;

H = compute_homography(p1,p2);
I = stitch(I1,I2,H);

figure()
imshow(I)


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



