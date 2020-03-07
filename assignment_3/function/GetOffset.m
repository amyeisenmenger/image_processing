function [offset, match] = GetOffset(o, s, p)
%UNTITLED4 Checks which corner we should shift to by checking which matches
%   the best with the shifted image
%   Detailed explanation goes here
%   o = original image
%   s = shifted image
%   p = phase correlation peak in form [peak_x, peak_y]
%   Output
%   offset = translation offset of images
%   match = MSE of original and translated image
    [M, N] = size (o);
    shifts = [ 1 1; -1 -1; 1 -1; -1 1;];
    match = Inf;
    offset = p;
    l = length(p);
    if isvector(p)
        l = 1;
    end
    for j = 1:l
        peak_x = p(j,1);
        peak_y = p(j,2);
        possible = [
            peak_x - 1, peak_y - 1;
            peak_x - 1, -peak_y + 1;
            -peak_x + 1, -peak_y + 1; 
            -peak_x + 1, peak_y - 1;
            M - peak_x + 1, N - peak_y + 1;
            M - peak_x + 1, peak_y - 1;
            peak_x - 1, N - peak_y + 1;
            -(M - peak_x) - 1, -( N - peak_y) - 1;
            -(M - peak_x) - 1, ( N - peak_y) + 1;
            (M - peak_x) + 1, -( N - peak_y) - 1;
        ];
%         multx = 1;
%         multy = 1;
%         if peak_x > M/2
%             multx = -1;
%             peak_x = M - peak_x;
%         end
%         if peak_y > N/2
%             multy = -1;
%             peak_y = N - peak_y;
%         end
%         pp = [peak_x - multx, peak_y - multy];

        for i = 1:length(possible)
%             shift = pp.*shifts(i,:);
            shift = possible(i,:);
            shift_im = imtranslate(o, shift);
            shift_match = MSE(s, shift_im);

            if shift_match < match
                match = shift_match;
                offset = shift;
            end  
        end
    end
end

