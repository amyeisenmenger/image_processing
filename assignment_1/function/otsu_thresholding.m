function threshold_image = otsu_thresholding(I)
%otsu_thresholding calcualtes the optimal threshold of pixel intensities 
%   in a grayscale image that maximized the mean difference of
%   the two classes above and below the threshold and returns a binarized
%   version of the original where every original pixel above the threshold
%   is white and every pixel below are black
%   INPUT
%   I = grayscale image
%   OUTPUT
%   threshold_image = binarized image

    N = size(I,1); 
    M = size(I,2);
    
    total_pixels = N*M;
    threshold = Inf;
    score = -Inf;
    max_num = max(max(I));
    
%     min_num = min(min(I));
    L = max_num + 1;
    if max_num == L
        L = 256;
    end
    intensity = (0:(max_num));
    
    % set intensitites to doubles for vector mult.
    intensity = double(intensity);
    
    %	build	histogram
    p = zeros(1, L);
    for	k=1:L	
    %	MATLAB	indices	start	from	1	not	0	
        p(k)=length(find(I(:)==(k-1)))/total_pixels;	
    end
    ip = p.*intensity;

    for k = 1:L
        % sum probabilities on each side of threshold k
        P1 = sum(p(1:k));
        P2 = sum(p(k+1:L));
        % calculate mean of each side
        M1 = sum(ip(1:k))/P1;
        M2 = sum(ip(k+1:L))/P2;
        % calculate class difference
        difference = P1*P2*((M1 - M2)^2);
        % if current k is better threshold, set as new threshold
        if difference > score
            threshold = k - 1;
            score = difference;
        end
    end
    % apply mask to image
%     disp(['threshold = ' num2str(threshold)]);
    threshold_image = I > threshold;
end

