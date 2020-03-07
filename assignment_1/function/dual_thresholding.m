function [low_image, threshold_image,high_image] = dual_thresholding(I, min, max)
%dual_thresholding creates 3 binary images, one of the values below min, 
%   one between min and max, and one above max
%   I = input image to threshold
%   min = lower threshold to separate black from gray/white
%   max = up threshold to separate white from gray/black
    low_image = I <= min;
    threshold_image = (I > min) & (I < max);
    high_image = I >= max;
end

