function Io = ButterworthBandReject(I, Do, W, n)
%ButterworthBandReject Applies Butterworth Band Reject Filter with band Do
%   radius from center and band width W
%   Input:
%       I = noisy input image
%       Do = distance defining the middle of the band to be rejected.
%       W = width of the rejection band
%       n = order of the Butterworth filter
%   Output: 
%       Io = filtered image

    [M, N] = size (I);
    G = fftshift(fft2(I));
    % create distance matrix for x and y axes
    rangeM = (-M/2 + 1: M/2);
    rangeN = (-N/2 + 1: N/2);
    distU = repelem(rangeM, length(rangeM), 1);
    distV = repelem(rangeN.', 1, length(rangeN));
    D = sqrt(distU.^2 + distV.^2);
    D_term = ((D.*W)./(D.^2 - Do^2)).^(2*n);
    H = 1./(1 + D_term);
    F = H.*G;
    Io = real(ifft2(ifftshift(F)));
end

