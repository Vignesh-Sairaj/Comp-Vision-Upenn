function M = ImageMorphingTriangulation(warp_frac,dissolve_frac)

if nargin < 1
    warp_frac = .5;
end

if nargin < 2
    dissolve_frac= warp_frac; 
end


% ream images
I = im2double(imread('a.png'));
J = im2double(imread('c.png'));

% load mat file with points, variables Ip,Jp
 load('points.mat');
 
% initialize ouput image (morphed)
M = zeros(size(I));

%  Triangulation (on the mean shape)
MeanShape = (1/2)*Ip+(1/2)*Jp;
TRI = delaunay(MeanShape(:,1),MeanShape(:,2));


% number of triangles
TriangleNum = size(TRI,1); 

% find coordinates in images I and J
CordInI = zeros(3,3,TriangleNum);
CordInJ = zeros(3,3,TriangleNum);

for i =1:TriangleNum
  for j=1:3
    
    CordInI(:,j,i) = [ Ip(TRI(i,j),:)'; 1];
    CordInJ(:,j,i) = [ Jp(TRI(i,j),:)'; 1]; 
    
  end
end

% create new intermediate shape according to warp_frac
Mp = (1-warp_frac)*Ip+warp_frac*Jp; 

 
% create a grid for the morphed image
[x,y] = meshgrid(1:size(M,2),1:size(M,1));

% for each element of the grid of the morphed image, find  which triangle it falls in
TM = tsearchn([Mp(:,1) Mp(:,2)],TRI,[x(:) y(:)]);
TM(isnan(TM)) = 1;


% YOUR CODE STARTS HERE
CordInM = zeros(3,3,TriangleNum);
invCordInM = zeros(3,3,TriangleNum);
for i =1:TriangleNum
  for j=1:3
    CordInM(:,j,i) = [ Mp(TRI(i,j),:)'; 1];
  end
  invCordInM(:,:,i) = pinv(CordInM(:,:,i));
end

x = x(:); y = y(:);
xinI = zeros(size(x)); yinI = zeros(size(y));
xinJ = zeros(size(x)); yinJ = zeros(size(y));

sx = size(M, 2);
sy = size(M, 1);

for p = 1:length(x)
    baryM = invCordInM(:, :, TM(p)) * [x(p); y(p); 1];
    repInI = CordInI(:,:,TM(p)) * baryM; repInI = repInI/repInI(end);
    repInJ = CordInJ(:,:,TM(p)) * baryM; repInJ = repInJ/repInJ(end);
    
    xinI(p) = round(repInI(1)); yinI(p) = round(repInI(2));
    xinJ(p) = round(repInJ(1)); yinJ(p) = round(repInJ(2));
    
    xinI(p) = min(sx, max(1, xinI(p))) ; yinI(p) = min(sy, max(1, yinI(p)));
    xinJ(p) = min(sx, max(1, xinJ(p))); yinJ(p) = min(sy, max(1, yinJ(p)));
end    

IndM = (1:numel(M))';
IndI = sub2ind(size(M), [yinI;yinI;yinI], [xinI;xinI;xinI], [ones(size(x)); 2*ones(size(x)); 3*ones(size(x))]);
IndJ = sub2ind(size(M), [yinJ;yinJ;yinJ], [xinJ;xinJ;xinJ], [ones(size(x)); 2*ones(size(x)); 3*ones(size(x))]);
% YOUR CODE ENDS HERE



% cross-dissolve
M(IndM)=(1-dissolve_frac)* I(IndI)+ dissolve_frac * J(IndJ);


TM(sub2ind(size(M), 200, 150))
figure(100);
subplot(1,3,1);
imshow(I);
hold on;
triplot(TRI,Ip(:,1),Ip(:,2))
hold off;
title('First')

subplot(1,3,2);
imshow(M);
hold on;
triplot(TRI,Jp(:,1),Jp(:,2));
% plot(x(TM==58), y(TM==58), 'rx');
hold off
title('Morphed')

subplot(1,3,3);
imshow(J);
hold on;
triplot(TRI,Jp(:,1),Jp(:,2))
hold off
title('Second')

end