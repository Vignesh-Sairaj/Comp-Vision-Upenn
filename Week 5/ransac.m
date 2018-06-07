buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);

I1 = readimage(buildingScene, 1);
I2 = readimage(buildingScene, 2);

I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);

% get points
points1 = detectHarrisFeatures(I1_gray);
points2 = detectHarrisFeatures(I2_gray);

% get features
[features1, points1] = extractFeatures(I1_gray, points1);
[features2, points2] = extractFeatures(I2_gray, points2);

loc1 = points1.Location;
loc2 = points2.Location;

[match,match_fwd,match_bkwd] = match_features(double(features1.Features),double(features2.Features));

H = ransac_homography(loc1(match(:,1),:),loc2(match(:,2),:));

I = stitch(I1,I2,H);

figure()
imshow(I)

function best_H = ransac_homography(p1,p2)
    thresh = sqrt(2); % threshold for inlier points
    p = 1-1e-4; % probability of RANSAC success
    w = 0.5; % fraction inliers
	
    % n: number of correspondences required to build the model (homography)
    n = 4;
    % number of iterations required
    % from the lecture given the probability of RANSAC success, and fraction of inliers
    k = round( log(1-p)/log(1-w^n) );
       
    num_pts = size(p1,1);
    best_inliers = 4;
    best_H = eye(3);
    for iter = 1:k
        % randomly select n correspondences from p1 and p2
        % use these points to compute the homography
        sample_ind = randsample(num_pts, n);
        p1_sample = p1(sample_ind, :);
        p2_sample = p2(sample_ind, :);
        H = compute_homography(p1_sample, p2_sample);
 
	
        % transform p2 to homogeneous coordinates
        p2_h = [p2 ones(num_pts, 1)];
        % estimate the location of correspondences given the homography
        p1_hat = p2_h*H';
        % convert to image coordinates by dividing x and y by the third coordinate
        p1_hat =  diag(1./p1_hat(:, 3))*p1_hat(:, 1:2);
        % compute the distance between the estimated correspondence location and the 
        % putative correspondence location
        dist = sqrt( sum( (p1_hat-p1).^2 , 2 ) );
        % inlying points have a distance less than the threshold thresh defined previously
        num_inliers = sum(dist < thresh);
		
        if num_inliers > best_inliers
            best_inliers = num_inliers;
            best_H = H;
        end
    end
end

