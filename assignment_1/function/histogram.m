function frequencies = histogram(I, n, min, max)
%HISTOGRAM returns a histogram of image I with n bins between the min and
%   max intensity values.
%   Input:
%   I = single channel grayscale image (integers or floats)
%   n = number of bins
%   min/max = range of integer values
%   Output:
%   1-D array of floats with length n that gives the relative frequency of
%   the occurence of grayscale values in each of the n bins

    N = size(I,1); 
    M = size(I,2);
    total_pixels = N*M;
    frequencies = zeros(1,n); % initialize histogram frequencies 
    bin_size = round((max - min + 1 )/n); % compute size of bin 
    
    for k=1:n
        edge = (k*bin_size) + min;
        if k == n % last bin may be bigger than others
            edge = max + 1;
        end
        frequencies(k) = length(find(I(:)<edge));
        % remove used values
        I(I < edge) = [];
    end
    frequencies = frequencies/total_pixels;
end

