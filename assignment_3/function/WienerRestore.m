function Io = WienerRestore(I, H, K)
%WienerRestore Restores image I using Wiener Filter formula for blur H, and SNR K
%  Input:
%  I = degraded input image
%  H = the degradation in the Fourier domain
%  K i= the parameter for Wiener filtering
%  Output:
%  Io = the output image
%     [M,N] = size(I)
    G = fftshift(fft2(I));
    H2 = conj(H).*H;
    F = ((1./H).*(H2./(H2 + K))).*G;
%     F = (conj(H)./(H2 + K)).*G;
    Io = uint8(real(ifft2(ifftshift(F))));
end

