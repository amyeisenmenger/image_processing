function mse = MSE(Image1,Image2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [M,N] = size(Image1);
    dif = (Image1 - Image2).^2;
    mse = sum(dif(:))/(M*N);
end

