addpath('./function/');
addpath('./input/');

shapes = imread('shapes.png');
shapes = shapes(:,:,1);
brain = imread('brain.tif');
turkeys = imread('turkeys.tif');
dolphin = imread('nat_geo_dolphin.tif');
dolphin = dolphin(:,:,1);
woman = imread('woman.jpg');
woman = woman(:,:,1);


%%%%%%%%%%%%    HISTOGRAM   %%%%%%%%%%%%

n = 20; % SET NUMBER OF BINS 
% BRAIN %
max_val =	max(max(brain));
min_val = min(min(brain));
frequencies = histogram(brain, n, min_val, max_val); % histogram y axis
% recalculate edges to use in graph
edges = zeros(1,n); % initialize bin cutoffs -- histogram x axis
bin_size = round((max_val - min_val + 1 )/n); % compute size of bin 
for k=1:(n-1)
     edges(k) = (k*bin_size) + min_val;
end
edges(n) = max_val + 1;
b = figure('visible','off');
stem(edges,frequencies, 'filled');
title('Normalized Binned Brain Histogram');
xlabel(['Bin Cutoffs for ' num2str(n) ' Bins, Bin Size = ' num2str(bin_size)]);
ylabel('Relative Frequency');
saveas(b, './output/histogram_brain.png');

% DOLPHIN %
max_val =	max(max(dolphin));
min_val = min(min(dolphin));
frequencies = histogram(dolphin, n, min_val, max_val); % histogram y axis
% recalculate edges to use in graph
edges = zeros(1,n); % initialize bin cutoffs -- histogram x axis
bin_size = round((max_val - min_val + 1 )/n); % compute size of bin 
for k=1:(n-1)
     edges(k) = (k*bin_size) + min_val;
end
edges(n) = max_val + 1;
d = figure('visible','off');
stem(edges,frequencies, 'filled');
title('Normalized Binned Dolphin Histogram');
xlabel(['Bin Cutoffs for ' num2str(n) ' Bins, Bin Size = ' num2str(bin_size)]);
ylabel('Relative Frequency');
saveas(d, './output/histogram_dolphin.png');

% WOMAN %
max_val =	max(max(woman));
min_val = min(min(woman));
frequencies = histogram(woman, n, min_val, max_val); % histogram y axis
% recalculate edges to use in graph
edges = zeros(1,n); % initialize bin cutoffs -- histogram x axis
bin_size = round((max_val - min_val + 1 )/n); % compute size of bin 
for k=1:(n-1)
     edges(k) = (k*bin_size) + min_val;
end
edges(n) = max_val + 1;
w = figure('visible','off');
stem(edges,frequencies, 'filled');
title('Normalized Binned Woman Histogram');
xlabel(['Bin Cutoffs for ' num2str(n) ' Bins, Bin Size = ' num2str(bin_size)]);
ylabel('Relative Frequency');
saveas(w, './output/histogram_woman.png');

%%%%%%%%%%%%    OTSU THRESHOLDING   %%%%%%%%%%%%
% BRAIN %
otsu_brain = otsu_thresholding(brain);
imwrite(otsu_brain, './output/otsu_brain.png');

% TURKEYS %
otsu_turkey = otsu_thresholding(turkeys);
imwrite(otsu_turkey, './output/otsu_turkeys.png');

% DOLPHIN %
otsu_dolphin = otsu_thresholding(dolphin);
imwrite(otsu_dolphin, './output/otsu_dolphin.png');

% WOMAN %
otsu_woman = otsu_thresholding(woman);
imwrite(otsu_woman, './output/otsu_woman.png');


%%%%%%%%%%%%    FLOOD FILL   %%%%%%%%%%%%

% BRAIN %
% otsu_brain = imread('./output/otsu_brain.tif');
flood_fill_brain = flood_fill(otsu_brain, [100,100], 2, otsu_brain);
map = [0 0 0; 1 1 1 ; 0 0 1];
color_ff_label = ind2rgb(flood_fill_brain + 1, map);
imwrite(color_ff_label, './output/ff_brain.png');

% TURKEY %
% otsu_turkey = imread('./output/otsu_turkey.tif');
flood_fill_turkey = flood_fill(otsu_turkey, [100,100], 2, otsu_turkey);
map = [0 0 0; 1 1 1 ; 0 0 1];
color_ff_label = ind2rgb(flood_fill_turkey + 1, map);
imwrite(color_ff_label, './output/ff_turkey.png');


%%%%%%%%%%%%    CONNECTED COMPONENTS   %%%%%%%%%%%%

% BRAIN %
[connected_comp_brain, final_label_brain] = connected_component(otsu_brain, 2, otsu_brain);
cc_brain = label2rgb(connected_comp_brain);
imwrite(cc_brain, './output/cc_brain.png');

% TURKEY %
[connected_comp_turkey, final_label_turkey] = connected_component(otsu_turkey, 2, otsu_turkey);
cc_turkey = label2rgb(connected_comp_turkey);
imwrite(cc_turkey, './output/cc_turkey.png');

% DOLPHIN %
[connected_comp_dolphin, final_label_dolphin] = connected_component(otsu_dolphin, 2, otsu_dolphin);
cc_dolphin = label2rgb(connected_comp_dolphin);
imwrite(cc_dolphin, './output/cc_dolphin.png');

% WOMAN %
[connected_comp_woman, final_label_woman] = connected_component(otsu_woman, 2, otsu_woman);
cc_woman = label2rgb(connected_comp_woman);
imwrite(cc_woman, './output/cc_woman.png');

%%%%%%%%%%%%    DUAL THRESHOLDING   %%%%%%%%%%%%

% min_thresh = round(255/3);
% max_thresh = 2*min_thresh;

% BRAIN %
[black_b, gray_b, white_b] = dual_thresholding(brain, 80, 125);
imwrite(gray_b, './output/dt_brain.png');

% TURKEYS %
[black_t, gray_t, white_t] = dual_thresholding(turkeys, 90, 190);
imwrite(gray_t, './output/dt_turkeys.png');

% DOLPHIN %
[black_d, gray_d, white_d] = dual_thresholding(dolphin, 10, 75);
imwrite(gray_d, './output/dt_dolphin.png');

% WOMAN %
[black_w, gray_w, white_w] = dual_thresholding(woman, 60, 140);
imwrite(gray_w, './output/dt_woman.png');



%%%%%%%%%%%%    DUAL THRESHOLDING + CONNECTED COMPONENT  %%%%%%%%%%%%

% BRAIN %
[cc_brain, final_label_br] = connected_component(gray_b, 2, gray_b);
cc_brain_color = label2rgb(cc_brain);
imwrite(cc_brain_color, './output/dt_cc_brain.png');

% TURKEYS %
[cc_turkey, final_label_tr] = connected_component(gray_t, 2, gray_t);
cc_turkey_color = label2rgb(cc_turkey);
imwrite(cc_turkey_color, './output/dt_cc_turkeys.png');

% DOLPHIN %
[cc_dolphin, final_label_d] = connected_component(gray_d, 2, gray_d);
cc_dolphin_color = label2rgb(cc_dolphin);
imwrite(cc_dolphin_color, './output/dt_cc_dolphin.png');

% WOMAN %
[cc_woman, final_label_w] = connected_component(gray_w, 2, gray_w);
cc_woman_color = label2rgb(cc_woman);
imwrite(cc_woman_color, './output/dt_cc_woman.png');

% %%%%%%%%%%%%    TOPOLOGICAL DENOISING  %%%%%%%%%%%%

% SHAPES- DUAL THRESHOLDING %
[black_shape, gray_shape, white_shape] = dual_thresholding(shapes, 15, 240);
imwrite(gray_shape, './output/dt_shapes.png');

% SHAPES - CONNECTED COMPONENT %
[cc_shapes, final_label_shapes] = connected_component(gray_shape, 2, gray_shape);
cc_shapes_color = label2rgb(cc_shapes);
imwrite(cc_shapes_color, './output/dt_cc_shapes.png');

% SHAPES - DENOISING %
td_shapes = topological_denoising(cc_shapes,300);
td_shapes = scale_labels(td_shapes);
color_shapes = label2rgb(td_shapes);
imwrite(color_shapes, './output/denoise_cc_shapes.png');



% Dolphin - DENOISING %
td_dolphin = topological_denoising(cc_dolphin,100);
td_dolphin = scale_labels(td_dolphin);
color_dolphin = label2rgb(td_dolphin);
imwrite(color_dolphin, './output/denoise_cc_dolphin.png');

% Woman - DENOISING %
td_woman = topological_denoising(cc_woman,90);
td_woman = scale_labels(td_woman);
color_woman = label2rgb(td_woman);
imwrite(color_woman, './output/denoise_cc_woman.png');

