function Io = ButterworthBandReject2(I, Do, W, n)
%UNTITLED2 Summary of this function goes here
%   Input:
%       I = noisy input image
%       Do = distance defining the middle of the band to be rejected.
%       W = width of the rejection band
%       n = order of the Butterworth filter
%   Output: 
%       Io = filtered image
    [M, N] = size (I);
    Ip = zeros(2*M,2*N);
    Ip(1:M,1:N)= I;
%     imshow(mat2gray(Ip));
    range2M = (1:2*M);
    range2N = (1:2*N);
    x = repelem(range2M, length(range2M), 1);
    y = repelem(range2N.', 1, length(range2N));
    xy = x + y;
    xy = (-1).^xy;
    Ip = xy.*Ip;
    G = fftshift(fft2(Ip));
    % create distance matrix for x and y axes
    rangeM = (-M + 1: M);
    rangeN = (-N + 1: N);
    distU = repelem(rangeM, length(rangeM), 1);
    distV = repelem(rangeN.', 1, length(rangeN));
    D = sqrt(distU.^2 + distV.^2);
    D_term = ((D.*W)./(D.^2 - Do^2)).^(2*n);
    H = 1./(1 + D_term);
    F = H.*G;
    Io = real(ifft2(ifftshift(F)));
    Io = xy.*Io;
    Io = Io(1:M,1:N);
end

