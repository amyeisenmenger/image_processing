function label_image = flood_fill(I, seed, label_value, label_image)
%flood_fill: Labels a connected region of the image that contains, and is
    % the same intensity as, the seed pixel. Uses 4-way connectedness.
    % INPUTS
    % I = binary image
    % seed = i, j coordinates of target pixel to start region
    % label_value = integer value greater than 1 to label filled region
    % label_image = copy of I to edit with filled region
    % OUTPUTS
    % label_image = NxM matrix of final edited image with filled region
    
    i = seed(1);
    j = seed(2);
    
    N = size(I,1); 
    M = size(I,2);
    label_image = double(label_image);
    % test is the binary value at the seed
    test = I(i,j);
    % initialized used to be zeros
    used = zeros(N,M);
    % initialize neighbor queue so don't have to resize 
    n = zeros(N*M,2);
    n(1,:) = seed;
    
    %  track neighbor queue index
    ni = 1;
    % iterate neighbors while exist
    while any(n(:))
        % pop first neighbor 
        pt = n(1,:);
        n(1,: ) = [];
        ni = ni - 1;
        if ni == 0
            ni = 1;
        end
        i = pt(1);
        j = pt(2);
        % check if in of bounds
        if i < 1 || j < 1 || i > N || j > M
            continue;
        end
        % set all consecutive pixels in row that match value to label
        % add row above and below in same range to neighbor queue 
        if I(i,j) == test
            left = j;
            right = j;
            while left > 0 && I(i,left) == test
                left = left - 1;
            end
            while right <= M && I(i,right) == test
                right = right + 1;
            end
            left = left + 1;
            right = right - 1;
            % add to component
            label_image(i,left:right) = label_value;
            ys = (left:right);
            % add unchecked pixels in row above to queue
            if i - 1 > 0
                next_i = i - 1;
                neighbor_mask = (used(next_i,left:right) == 0);
                used(next_i,ys) = 1;
                mask_js = (ys.*neighbor_mask);
                mask_js(mask_js == 0) = [];
                mask_length = length(mask_js);
                if mask_length > 0
                    ns = ones(1,mask_length)*(next_i);
                    neighbors = [ns' mask_js'];
                    n(ni:(ni + (mask_length -1)),:) = neighbors; 
                    ni = ni + mask_length;
                end
                
            end
            % add unchecked pixels in row below to queue
            if i + 1 <= N
                next_i = i + 1;
                neighbor_mask = (used(next_i,left:right) == 0);
                used(next_i,ys) = 1;
                mask_js = (ys.*neighbor_mask);
                mask_js(mask_js == 0) = [];
                mask_length = length(mask_js);
                if mask_length > 0
                    ns = ones(1,mask_length)*(next_i);
                    neighbors = [ns' mask_js'];
                    n(ni:(ni + (mask_length -1)),:) = neighbors; 
                    ni = ni + mask_length;
                end
            end
        end

    end
end

