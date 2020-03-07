function Gm = Gradient(I,sigma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    s = 2;
    [M,N] = size(I);
    % pad so there is not a border effect throwing off the lines
    I2 = padarray(I, [s s], 'replicate');
    sY = [-1 0 1];
    sX = [1 2 1]';
    sXf = sX.*sY;
    sYf = sX'.*sY';
    % smooth image with Gaussian filter
    smoothI = GaussianFilter(I2, sigma);
    Gx = conv2(smoothI, sXf);
    Gy = conv2(smoothI, sYf);
    Gm = sqrt(Gx.^2 + Gy.^2);
    % remove border
    Gm = Gm(s+1:M+s,s+1:N+s);
end

