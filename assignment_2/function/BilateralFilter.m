function [filtered_I, distance_matrix] = BilateralFilter(I,sigmad, sigmar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    I = mat2gray(I(:,:,1));
    % initialize new image
    [M,N] = size(I);
    filtered_I = zeros(M,N);
    
    % set neighborhood size 
    n = 3*sigmad;
    
    % create distance gaussian w/ sigmad - same for all pixels
    range = (-n:n);
    distX = repelem(range, length(range), 1);
    distY = repelem(range.', 1, length(range));
    distance_matrix = distX.^2 + distY.^2;
    
    % apply gaussian to matrix
    G = exp(-distance_matrix/(2*(sigmad^2)));

    % get intensity gaussian w/ sigmar
    for row = 1:M
        Y_min = max(row - n,1);
        Y_max = min(row + n,M);
        for col = 1:N
            X_min = max(col - n, 1) ;
            X_max = min(col + n, N) ;
            % select neighborhood from original image
            i_neighbor = I(Y_min:Y_max, X_min:X_max); 
            center_val = I(row, col); 
            
            % calculate intensity distances
            intensity_dist = (i_neighbor - center_val).^2;
            
            % create intensity gaussian
            H = exp(-intensity_dist/(2*(sigmar^2)));
            
            %combine distance and intensity gaussians
            G_h = G((Y_min:Y_max)-row+n+1, (X_min:X_max)-col+n+1);
            f_matrix = G_h.*H;
            
            % get total to normalize
            k = sum(f_matrix(:));
            
            % multiply filter by pixel intensity
            filter_window = i_neighbor.*f_matrix;
            
            % sum and normalize to find new pixel intensity
            f = sum(filter_window(:))/k;
            
            % output new pixel intensity to filtered image
            filtered_I(row,col) = f;
        end
    end
end

