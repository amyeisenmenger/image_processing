function revised_image = topological_denoising(I,min_size)
%topological_denoising takes in an image of labeled connected components
%   and merges componenets with fewer than min_size pixels with the
%   neighbor with which it shares the longest border
    % INPUTS
    % I = labeled image
    % min_size = target smallest size of a connected component 
    % OUTPUTS
    % revised_image = NxM matrix of labeled connected components larger
    % than the min_size
    
    revised_image = I;
    N = size(I,1); 
    M = size(I,2);
    % find  unique labels
    labels = unique(I);
    num_labels = length(labels);
    for i = 1 : num_labels 
        curr_label = labels(i);
        % get pixels in connected component
        [px, y] = find(revised_image == curr_label);
        
        pts = [px, y];
        % get size of component
        count = length(pts);
        if isvector(pts)
            count = 1;
        end
        % if size of componenet less than threshold,
        % convert it to adjacent label by voting
        if count < min_size
            %  allow each edge pixel to vote by the majority label of its
            %  neighbors
            votes = zeros(1,num_labels);

            for row = 1:count
                neighbor = find_neighbors(pts(row, :)); 
                neighbor(neighbor(:,1) == 0,:) = [];
                neighbor(neighbor(:,2) == 0,:) = [];            
                neighbor(neighbor(:,1) > N,:) = [];           
                neighbor(neighbor(:,2) > M,:) = [];
                neighbor_length = length(neighbor);
                if neighbor_length > 0
                    
                    if isvector(neighbor)
                        neighbor_length = 1;
                    end
                    for px_row = 1:neighbor_length
                        px = neighbor(px_row,:);
                        value = revised_image(px(1),px(2));
                        % if not in this component, cast one vote for it's label
                        if value ~= curr_label
                            vote_index = (labels == value)';
                            votes =  votes + vote_index;
                        end
                    end
                end

            end
            % tally votes and change label to majority neighbor label
            [~, index] = max(votes);
            new_label = labels(index);
            revised_image(revised_image == curr_label) = new_label;

        end
    end


end

