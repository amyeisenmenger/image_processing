function [label_image,final_label] = connected_component(I, start_label, label_image)
%connected_component: Labels all connected components of 
    % INPUTS
    % I = binary image
    % seed = i, j coordinates of target pixel to start region
    % label_value = integer value greater than 1 to label filled region
    % label_image = copy of I to edit with filled region
    % OUTPUTS
    % label_image = NxM matrix of final edited image with filled region
    seed = [1 1];
    label = start_label;
    label_image = double(label_image);
    counts = [];
    
    while any(label_image(:) < start_label)    
        label_image = flood_fill(I, seed, label, label_image);
        label = label + 1;
        [i, j] = find(label_image < start_label, 1);
        seed = [i j];
    end
    final_label = label;
end

