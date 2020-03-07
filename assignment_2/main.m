addpath('./function/');
addpath('./input/');
lena = imread('lena.png');
aerial = imread('aerial.jpg');
% convert to range [0,1]
lena = mat2gray(lena(:,:,1));
aerial = mat2gray(aerial(:,:,1));

%%%%%%%%%% GAUSSIAN FILTERING %%%%%%%%%%

sigma = 3;
[gauss03_lena, filter3] = GaussianFilter(lena, sigma);
imwrite(gauss03_lena, './output/gauss03_lena.jpg');

sigma = 10;
gauss10_lena = GaussianFilter(lena, sigma);
imwrite(gauss10_lena, './output/gauss10_lena.jpg');

%%%%%%%%% BILATERAL FILTERING %%%%%%%%%%
sigmar = 0.1;
sigmad = 3;
[bilateral,filt] = BilateralFilter(lena, sigmad, sigmar);
imwrite(bilateral, './output/bilateral_lena.jpg');

%%%%%%%%% MSE %%%%%%%%%%
glena = mat2gray(lena(:,:,1));
[M,N] = size(glena);
mean = 0;
s = 0.1;
n = randn(M,N); 
noisy_lena = glena + (s*n);
imwrite(noisy_lena, './output/noisy_lena.jpg');

%%%%%%%%% MSE - GAUSSIAN FILTER %%%%%%%%%%
sigmas = [0.33 1 3 10];
mses = double(zeros(1,length(sigmas)));
for i = 1:length(sigmas)
    sigma = sigmas(i);
    g = GaussianFilter(noisy_lena, sigma);
    mses(i) = MSE(glena, g);
end
f1 = figure;
plot(sigmas, mses);
xlabel('Sigma');
ylabel('MSE');
title('Gaussian Filter on Noisy Lena');
saveas(f1, './output/MSE_gaussian.png');
f1(close);
%%%%%%%%% MSE - BILATERAL FILTER %%%%%%%%%%
sigmars_bf =  [0.01 0.03 0.1 0.3 1 3];
sigmad = 3;
mses_bf = double(zeros(1,length(sigmars_bf)));
for i = 1:length(sigmars_bf)
    sigmar = sigmars_bf(i);
    b = BilateralFilter(noisy_lena, sigmad, sigmar);
    mses_bf(i) = MSE(glena, b);
end

f2 = figure;

plot(sigmars_bf, mses_bf);
xlabel('Sigma');
ylabel('MSE');
title('Bilateral Filter on Noisy Lena');
saveas(f2, './output/MSE_bilateral.png');
f2(close);

%%%%%%%%% GRADIENT %%%%%%%%%%
g_1 = Gradient(lena, 1);
imwrite(g_1, './output/gradient01.jpg');
g_3 = Gradient(lena, 3);
imwrite(g_3, './output/gradient03.jpg');
g_10 = Gradient(lena,10);
imwrite(g_10, './output/gradient10.jpg');
sigmas = 1:2:9;
for i = 1:length(sigmas)
    sigma = sigmas(i);
    g_mag = Gradient(lena, i);
    thresholds = (0.1:.2:0.9);
    for j = 1:length(thresholds)
        t = thresholds(j);
        thresh = max(g_mag)*t;
        mag = g_mag > thresh;
        title = ['./output/gradient_sigma' num2str(sigma) '_thresh' num2str(t) '.jpg'];
        imwrite(mag, title);
    end
end

%%%%%%%%% HOUGH TRANSFORMATION %%%%%%%%%%


[A, line_aerial] = HoughTransform(aerial);
imshow(line_aerial);
imwrite(line_aerial,'./output/hough_line.png');
imwrite(mat2gray(A), './output/transform_matrix.png');
% save accumulator array
sigma = 2;
aerial = mat2gray(aerial(:,:,1));
t_mult = 0.5;
edges = Gradient(aerial, sigma);
threshold = max(edges)*t_mult; % threshold gradient image
edges = edges > threshold;
imwrite(edges,'./output/hough_threshold.png');

