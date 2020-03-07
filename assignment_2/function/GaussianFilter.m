function [filtered_I,G] = GaussianFilter(I,sigma)
%UNTITLED2 Summary of this function goes here
    % n = size of window/neighborhood
    n = round(3*sigma);
    I = mat2gray(I(:,:,1));
    [M,N] = size(I);
    % pad so there is not such a pronounced a border effect 
    I2 = padarray(I, [n n], 'replicate');

    % create distance matrix for x and y axes
    range = (-n:n);
    distX = repelem(range, length(range), 1);
    distY = repelem(range.', 1, length(range));
    
    % create gaussian filter and normalize
    distance_matrix = distX.^2 + distY.^2;
    G = exp(-(distance_matrix)/(2*(sigma^2)));
    % apply gaussian to image
    
    G = G/sum(G(:));
    filtered_I = conv2(I2, G, 'same');
    filtered_I = filtered_I(n+1:M+n, n+1:N+n);
    
    
%     filtered_I = zeros(M,N);
%     for row = 1:M
%         Y_min = max(row - n,1);
%         Y_max = min(row + n,M);
%         for col = 1:N
%             X_min = max(col - n, 1) ;
%             X_max = min(col + n, N) ;
%             % select neighborhood from original image
%             neighborhood = I(Y_min:Y_max, X_min:X_max); 
%             % subselect Gaussian for border cases
%             G_h = G((Y_min:Y_max)-row+n+1, (X_min:X_max)-col+n+1);
% 
%             % multiply filter by pixel intensity
%             G_h = G_h/sum(G_h(:));
%             f = neighborhood.*G_h;
%             f = sum(f(:));
%             
%             % output new pixel intensity to filtered image
%             filtered_I(row,col) = f;
%         end
%     end
    
end

