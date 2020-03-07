function [relabeled_image,num_labels] = scale_labels(I)
%scale_labels takes in a labeled image I and converts the labels to be
%   consecutive(e.g. after topological denoising) for an even spread when
%   vizualized with label2rgb()
%   INPUT 
%   I = labeled image
%   OUTPUT 
%   relabeled_image = labeled image with consecutive labels
    N = size(I,1); 
    M = size(I,2);
    relabeled_image = zeros(N,M);
    labels = unique(I);
    num_labels = length(labels);
    for i = 1:num_labels
        component_mask = (I == labels(i))*i;
        relabeled_image = relabeled_image + component_mask;
    end
end

