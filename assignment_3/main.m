addpath('./function/');
addpath('./input/');
addpath('./output/');

lena = imread('lena.png');
lena_2 = imread('lena_2.png');
lena_3 = imread('lena_3.png');
check = imread('checkerbox.png');
check_2 = imread('checkerbox_2.png');
house = imread('house.pgm');
house_1 = imread('houseNoisy1.pgm');
house_2 = imread('houseNoisy2.pgm');
fingerprint =  imread('fingerprint.png');
boat =  imread('boat.png');

lena = lena(:,:,1);
lena_2 = lena_2(:,:,1);
lena_3 = lena_3(:,:,1);

check = check(:,:,1);
check_2 = check_2(:,:,1);

house = house(:,:,1);
house_1 = house_1(:,:,1);
house_2 = house_2(:,:,1);

fingerprint = fingerprint(:,:,1);
boat = boat(:,:,1);

% create ideal low pass filter in Fourier domain
[M,N] = size(lena);
w = 30;
% Square Filter
% H(M/2 - w:M/2 + w,N/2 - w:N/2 + w) = 1;
% H = zeros(M,N);
% Circle Filter
rangeM = (-M/2 + 1: M/2);
rangeN = (-N/2 + 1: N/2);
distU = repelem(rangeM, length(rangeM), 1);
distV = repelem(rangeN.', 1, length(rangeN));
D = sqrt(distU.^2 + distV.^2);
H = (D < w);
imwrite(H, './output/ILPF_fourier.jpg');


%     %%%%%%%%%% PHASE CORRELATION %%%%%%%%%%
%     LENA - LENA_2
phase_corr_2 = PhaseCorrelation(lena,lena_2,H);
imwrite(mat2gray(phase_corr_2), './output/Phase_Lena_2.jpg');
[peak_x, peak_y] = GetPeak(phase_corr_2); 
[offset, match] = GetOffset(lena, lena_2, [peak_x, peak_y]);


disp("Peak for Lena 2:");
disp(peak_x + ", " + peak_y)
disp("Offset:")
disp(offset)
disp("MSE of lena shifted by offset:")
disp(match)
disp("")

%     LENA - LENA_3
phase_corr_3 = PhaseCorrelation(lena,lena_3,H);
imwrite(mat2gray(phase_corr_3), './output/Phase_Lena_3.jpg');
[peak_x, peak_y] = GetPeak(phase_corr_3); 
[offset, match] = GetOffset(lena, lena_3, [peak_x, peak_y]);


disp("Peak for Lena 3:");
disp(peak_x + ", " + peak_y)
disp("Offset:")
disp(offset)
disp("MSE of lena shifted by offset:")
disp(match)
disp("")


%     CHECKERBOX - CHECKERBOX_2
[M,N] = size(check);
w = 1;
% Circle Filter
rangeM = (-M/2 + 1: M/2);
rangeN = (-N/2 + 1: N/2);
distU = repelem(rangeM, length(rangeM), 1);
distV = repelem(rangeN.', 1, length(rangeN));
D = sqrt(distU.^2 + distV.^2);
H = (D < w);

phase_corr_c = PhaseCorrelation(check,check_2,H);
% imshow(mat2gray(phase_corr_c));
imwrite(mat2gray(phase_corr_c), './output/Phase_Check_2.jpg');
[peak_x, peak_y] = GetPeak(phase_corr_c);
[offset, match] = GetOffset(check, check_2, [peak_x, peak_y]);
shifted = imtranslate(check,offset);


disp("Peak for Checkerbox:");
disp(peak_x + ", " + peak_y);
disp("Offset:")
disp(offset)
disp("MSE of Checkerbox  shifted by offset:")
disp(match)
disp("")


%%%%%%%%% WIENER RESTORE FILTER %%%%%%%%%%
% Fingerprint
blurry_f = BlurDegradation(fingerprint);
imwrite(mat2gray(blurry_f), './output/blurry_finger.jpg');
% Get Hblur 
f = fingerprint;
f = double(f);
M = size(f,1);
N = size(f,2);
sigma_n = max(f(:))*0.05; 
sigmaspatial = 4;
sigmafreq = sqrt(1/(4*pi^2*(sigmaspatial/512)^2));
for u=1:size(f,1)
    for v=1:size(f,2)
        Hblur(u,v) = exp(-((u-M/2).^2+(v-N/2).^2)/(2*sigmafreq^2));
    end
end
% 
maxk = 1000;
ks = linspace(1, maxk, maxk);
mses = zeros(1,length(ks));
ks = ks./1000;
min_mse = inf;
res_finger = boat;
for i = 1:length(ks)   
    io = real(WienerRestore(blurry_f, Hblur, ks(i)));
    mse = MSE(fingerprint, uint8(io));
    mses(i) = mse;
    if mse < min_mse
        min_mse = mse;
        res_finger = io;
    end
end

imwrite(mat2gray(res_finger), './output/res_finger.jpg');

mse = MSE(fingerprint, uint8(res_finger));
f1 = figure;
plot(ks, mses);
xlabel('K');
ylabel('MSE');
title('Wiener Restoration MSE on Blurry Fingerprint');
saveas(f1, './output/MSE_fingerprint.png');
f1(close);


ks1 = 50:600;
ks1 = 1./ks1;
mses1 = zeros(1,length(ks1));
for i = 1:length(ks1)   
    io = real(WienerRestore(blurry_f, Hblur, ks1(i)));
    mse = MSE(fingerprint, uint8(io));
    mses1(i) = mse;
end
f1 = figure;
plot(ks1, mses1);
xlabel('K');
ylabel('MSE');
title('Wiener Restoration MSE on Blurry Fingerprint w Fractional K');
saveas(f1, './output/MSE_fingerprint2.png');
f1(close);

 % BOAT
blurry_b = BlurDegradation(boat);
% get Hblur
f = boat;
f = double(f);
M = size(f,1);
N = size(f,2);
sigma_n = max(f(:))*0.05; 
sigmaspatial = 4;
sigmafreq = sqrt(1/(4*pi^2*(sigmaspatial/512)^2));
for u=1:size(f,1)
    for v=1:size(f,2)
        Hblur(u,v) = exp(-((u-M/2).^2+(v-N/2).^2)/(2*sigmafreq^2));
    end
end
maxk = 1000;
ks2 = linspace(1, maxk, 200);
mses2 = zeros(1,length(ks2));
ks2 = ks2./1000;
res_boat = fingerprint;
min_mse = inf;
for i = 1:length(ks2)   
    io = real(WienerRestore(blurry_b, Hblur, ks2(i)));
    mse = MSE(boat, io);
    mses2(i) = mse;
    if mse < min_mse
        min_mse = mse;
        res_boat = io;
    end
end
imwrite(mat2gray(res_boat), './output/res_boat.jpg');

f1 = figure;
plot(ks2, mses2);
xlabel('K');
ylabel('MSE');
title('Wiener Restoration MSE on Blurry Boat');
saveas(f1, './output/MSE_boat.png');
f1(close);

ks3 = 20:400;
ks3 = 1./ks3;
mses3 = zeros(1,length(ks3));
for i = 1:length(ks3)   
    io = real(WienerRestore(blurry_b, Hblur, ks3(i)));
    mse = MSE(boat, uint8(io));
    mses3(i) = mse;
end
f1 = figure;
plot(ks3, mses3);
xlabel('K');
ylabel('MSE');
title('Wiener Restoration MSE on Blurry Boat w Fractional K');
saveas(f1, './output/MSE_boat2.png');
f1(close);


%%%%%%%%% BUTTERWORTH BAND REJECT FILTER %%%%%%%%%%
% Get log Fourier spectrums
x = fftshift(fft2(house_1));
x = mat2gray(abs(log2(x)));
imwrite(x, './output/house1_fft.jpg');
y = fftshift(fft2(house));
y = mat2gray(abs(log2(y)));
imwrite(y, './output/house_fft.jpg');
z = fftshift(fft2(house_2));
z = mat2gray(abs(log2(z)));
imwrite(z, './output/house2_fft.jpg');

% % HOUSE - HOUSE 1
d0 = 1;
w0 = 10;
mse = Inf;
hp = house;
for d = 1:30
    for w = 190:210
%         fhat = ButterworthBandReject(house_1, w, d, 2);
        fhat = ButterworthBandReject2(house_1,w,d,2);
        new_mse = MSE(house,uint8(fhat));
        if new_mse < mse
            mse = new_mse;
            w0 = d; %oops!
            d0 = w; %oops!
            hp = fhat;
        end
    end
end


imwrite(mat2gray(hp), './output/house1_bbr.jpg');
% hp = ButterworthBandReject2(house_1, 197, 22, 2);
% new_mse = MSE(house,uint8(hp));


% HOUSE - HOUSE 2

% hp1 = ButterworthBandReject2(house_2, 198, 13, 2);
% hp2 = ButterworthBandReject2(hp_prev, 259, 10, 2);
d_final = 1;
w_final = 10;
mse = inf;
hp_final = house_2;
hp_prev = house_2;
for i = 1:2
    for d = 10:30
        for w = 190:260
%             fhat = ButterworthBandReject(hp_prev, d, w, 2);
            fhat = ButterworthBandReject2(hp_prev, w, d, 2);
            new_mse = MSE(house,uint8(fhat));
            if new_mse < mse
                mse = new_mse;
                d_final = w; %oops
                w_final = d; %oops
                hp_final = fhat;
            end
        end
    end
    disp("Iteration " + i);
    disp("Do = " + d_final);
    disp("W = " + w_final);
    disp("MSE = " + mse);
    disp("")
    hp_prev = hp_final;
end
imwrite(mat2gray(hp_prev), './output/house2_bbr.jpg');
