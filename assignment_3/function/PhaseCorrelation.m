function p = PhaseCorrelation(f, g, H)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % Input:
    % f = 1st input image in spatial domain
    % g = 2nd input image in spatial domain
    % H = low pass filter in Fourier domain
    % Output:
    % p = filtered output image in spatial domain
    
    % transform and shift to center
    F = fftshift(fft2(f));
    G = fftshift(fft2(g));
    FG = conj(F).*G;
    FG(FG==0) = 0.00000001;
    R = FG./abs(FG);
    % apply filter
    P = H.*R;
    % shift back and inverse transform
    p = real(ifft2(ifftshift(P)));
     
end

