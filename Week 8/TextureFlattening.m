function I = TextureFlattening
    
% read image and mask
target = im2double(imread('bean.jpg')); 
mask = imread('mask_bean.bmp');

% edge detection
Edges = edge(rgb2gray(target),'canny',0.1);



N=sum(mask(:));  % N: Number of unknown pixels == variables



% YOUR CODE STARTS HERE

% image offsets
row_offset=0;
col_offset=0; 



% enumerating pixels in the mask
mask_id = zeros(size(mask));
mask_id(mask) = 1:N;
    
% neighborhood size for each pixel in the mask
[ir,ic] = find(mask);

Np = zeros(N,1); 

for ib=1:N
    
    i = ir(ib);
    j = ic(ib);
    
    Np(ib)=  double((row_offset+i> 1))+ ...
             double((col_offset+j> 1))+ ...
             double((row_offset+i< size(target,1))) + ...
             double((col_offset+j< size(target,2)));
end


% compute matrix A

% your CODE begins here

%sparse matrix indices and values
si = zeros(4*N, 1); sj = zeros(4*N, 1); sv = zeros(4*N, 1); ctr = 0;
for p = 1:N
    i = ir(p);
    j = ic(p);
    
    ctr=ctr+1;
    si(ctr) = p; sj(ctr) = p; sv(ctr) = 4; %diag
    
    if (mask_id(i-1, j) > 0) %in mask
        ctr = ctr+1;
        si(ctr) = p; sj(ctr) = mask_id(i-1, j); sv(ctr)= -1;
    end
    
    if (mask_id(i+1, j) > 0)
        ctr = ctr+1;
        si(ctr) = p; sj(ctr) = mask_id(i+1, j); sv(ctr)= -1;
    end
    
    if (mask_id(i, j-1) > 0)
        ctr = ctr+1;
        si(ctr) = p; sj(ctr) = mask_id(i, j-1); sv(ctr)= -1;
    end
    
    if (mask_id(i, j+1) > 0)
        ctr = ctr+1;
        si(ctr) = p; sj(ctr) = mask_id(i, j+1); sv(ctr)= -1;
    end
end

A = sparse(si(1:ctr), sj(1:ctr), sv(1:ctr), N, N);
% your CODE ends here



% output intialization
seamless = target; 


for color=1:3 % solve for each colorchannel

    % compute b for each color
    b=zeros(N,1);
    
    for ib=1:N
    
    i = ir(ib);
    j = ic(ib);
    
            
      if (i>1)
          tGrad = target(row_offset+i,col_offset+j,color) - ...
              target(row_offset+i-1,col_offset+j,color);
          
          b(ib)=b(ib)+ target(row_offset+i-1,col_offset+j,color)*(1-mask(i-1,j))+...
                          double(Edges(i, j) | Edges(i-1, j)) * tGrad;
      end

      if (i<size(mask,1))
          tGrad = target(row_offset+i,col_offset+j,color) - ...
              target(row_offset+i+1,col_offset+j,color);
          b(ib)=b(ib)+  target(row_offset+i+1,col_offset+j,color)*(1-mask(i+1,j))+ ...
                           double(Edges(i, j) | Edges(i+1, j)) * tGrad;
      end

      if (j>1)
          tGrad = target(row_offset+i,col_offset+j,color) - ...
              target(row_offset+i,col_offset+j-1,color);
          
          b(ib)= b(ib) +  target(row_offset+i,col_offset+j-1,color)*(1-mask(i,j-1))+...
                           double(Edges(i, j) | Edges(i, j-1)) * tGrad;
      end


      if (j<size(mask,2))
          tGrad = target(row_offset+i,col_offset+j,color) - ...
              target(row_offset+i,col_offset+j+1,color);
          
          b(ib)= b(ib)+ target(row_offset+i,col_offset+j+1,color)*(1-mask(i,j+1))+...
                         double(Edges(i, j) | Edges(i, j+1)) * tGrad; 
      end     
    end

    
    % solve linear system A*x = b;
    % your CODE begins here
    x = A\b;
    % your CODE ends here

    % impaint target image
    
     for ib=1:N
           seamless(row_offset+ir(ib),col_offset+ic(ib),color) = x(ib);
     end
    figure(1), imshow(target);
    figure(2), imshow(seamless);
    I = seamless;
end