function [peak_x, peak_y] = GetPeak(corr_image)
%GetPeak Finds the location of the max value in the matrix
%   Input:
%   corr_image = phase correlation of two images
%   Output 
%   [peak_x, peak_y] = list of x,y coordinates of peaks with max value
    max_val = max(corr_image(:));
    [peak_x, peak_y] = find(corr_image == real(max_val));
    
end

