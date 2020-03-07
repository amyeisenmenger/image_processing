function [A, lineI] = HoughTransform(I)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    orig = I;
    I = mat2gray(I(:,:,1));
    % subroutine parameters
    [N,M] = size(I);
    sigma = 2;
    t_mult = 0.5;
    D_bin_size = 3;
    theta_bin_size = 1;
    D = sqrt(M^2 + N^2); %length of diagonal
    
    %Discretize rho and theta ranges
    rhos = -D:D_bin_size:D; %Aij rows
    thetas = -90:theta_bin_size:90; %Aij columns
    % extract candidate edge pixels and image dimensions
    edges = Gradient(I, sigma);
    
    threshold = max(edges)*t_mult; % threshold gradient image
    edges = edges > threshold;
    [ey, ex] = find(edges);
    
    n_thetas = length(thetas);
    n_rhos = length(rhos);
    n_e = length(ex);
    % calculate rhos for each edge pixel in degrees
    % (account for non-zero indexing);
    cosines = (ex - 1)*cosd(thetas); 
    sines = (ey - 1)*sind(thetas);
    epx_rhos = cosines + sines;
    % initialize accumulator matrix A
    A = zeros(n_rhos,n_thetas);
    Z = zeros(n_rhos,n_thetas);
 
    % loop over column (constant theta value)
    for t = (1:n_thetas)
        %bin each column using histogram w/ rhos as bin edges
%         rs = epx_rhos(:,t);
%         for r = 1:n_e
%             rho = rs(r);
%             bin = find(rhos > rho, 1, 'first');
%             if bin < 1 
%                 bin = 1;
%             end
%             if  bin > n_rhos
%                 bin = n_rhos;
%             end
%             
%             A(bin,t) = A(bin,t) + 1;
%         end
%       This is much faster
        A(:,t) = hist(epx_rhos(:,t),rhos);
    end

    % code to nicely vizualize matrix from https://rosettacode.org/wiki/Example:Hough_transform/MATLAB
%     figure('visible','off');
%     pcolor(thetas,rhos,A);
%     shading flat;
%     title('Hough Transform');
%     xlabel('Theta (degrees)');
%     ylabel('Rho (pixels)');
%     colormap('gray');
%     saveas(gcf,'hough_transform_curves.png')
%     close(figure);
    
    % threshold
    line_thresh = min(maxk(A(:),20));
    [rho_i, theta_i]  = find(A >= line_thresh);
    
    % for each thresholded rho/theta, calculate line and draw on orig image
    figure('visible','off');
    imshow(orig);
    hold on;
    x = 1:M;
    for j = 1:length(rho_i)
        rho = rhos(rho_i(j));
        theta = thetas(theta_i(j));
        y = (rho -( x* cosd(theta)) )/ sind(theta);
        plot(x,y, 'red', 'LineWidth', 1);
    end
    hold off; 
    F = getframe;
    lineI = frame2im(F);
    close(figure);


end

