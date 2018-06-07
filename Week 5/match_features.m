function [match,match_fwd,match_bkwd] = match_features(f1,f2)
    %% INPUT
    %% f1,f2: [ number of points x number of features ]
    %% OUTPUT
    %% match, match_fwd, match_bkwd: [ indices in f1, corresponding indices in f2 ]
    
    % get matches using pdist2 and the ratio test with threshold of 0.7
    % fwd matching
    
    [D,I] = pdist2(f2, f1,'euclidean','Smallest',2);
    D1to2 = D(1, :)./D(2, :);
    indexin1 = 1:size(f1, 1);
    indexin2corrto1 = I(1, :);
    
    match_fwd = [indexin1(D1to2 < 0.7)', indexin2corrto1(D1to2 < 0.7)'];
    
    % bkwd matching
    [D,I] = pdist2(f1, f2,'euclidean','Smallest',2);
    D2to1 = D(1, :)./D(2, :);
    indexin2 = 1:size(f2, 1);
    indexin1corrto2 = I(1, :);
    
    match_bkwd = [indexin1corrto2(D2to1 < 0.7)', indexin2(D2to1 < 0.7)'];
    
    % fwd bkwd consistency check
    match = intersect(match_fwd, match_bkwd, 'rows');
end
