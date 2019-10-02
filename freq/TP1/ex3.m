clc;
clear;

%Faire 3 points:
n=100;
m=100;
d=10;
teta=pi/4;

dx = floor(d * cos(teta));
dy = floor(d * sin(teta));
im = zeros(n,m);
xcentre = floor((n/2) + 1);
ycentre = floor((m/2) + 1);
im(xcentre, ycentre) = 255;
im(xcentre+dx, ycentre+dy) = 255;
im(xcentre-dx, ycentre-dy) = 255;
%imshow(im);

imInv = ifft2(im);
val = 2;
%imshow( log(1 + val * abs(imInv))  );
%imshow(abs(imInv),[]);

lena = imread('lena.pgm');
lena = lena(:,:,1);

[N M C] = size(lena);

lenaFFT = fft2(lena);
lenaShift = fftshift(lenaFFT);

%Phase between -pi and pi
%manualLena = abs(lenaFFT) .* exp(i * angle(lenaFFT));

phi = angle(lenaFFT);
m = abs(lenaFFT);

randomPhi = rand(N,M) .* 2*pi;
randomModule = rand(N,M) .* 1000000 + 20; 

lenaRandomPhase = m .* exp(i * randomPhi);
lenaRandomMod = randomModule .* exp(i * phi);

iRP = ifft2(lenaRandomPhase);
iRM = ifft2(lenaRandomMod);

figure(1);

subplot(2,2,1);
imshow(abs(iRP), []);
title("Lena random phase");

subplot(2,2,2);
imshow(abs(iRM), []);
title("Lena random module");

constantPhi = ones(N,M);
constantModule = ones(N,M) .* 1000;
lenaConstantPhase = m .* exp(i * constantPhi);

lenaConstantModule = constantModule .* exp(i * phi);

subplot(2,2,3);
imshow(abs(ifft2(lenaConstantPhase)), []);
title("Lena constant phase");

subplot(2,2,4);
imshow(abs(ifft2(lenaConstantModule)), []);
title("Lena constant module");

%Intervertir phase et module de deux images
fraise = imread('fraise-foveon.jpg');
fraise = fraise(:,:,1);
fraiseFFT = fft2(fraise);

phiFraise = angle(fraiseFFT);
modFraise = abs(fraiseFFT);

montagne = imread('montagne-foveon.jpg');
montagne=montagne(:,:,1);
montagneFFT = fft2(montagne);

phiMontagne = angle(montagneFFT);
modMontagne = abs(montagneFFT);

phaseFraiseModMontagne = modMontagne .* exp(i * phiFraise);
phaseMontagneModFraise = modFraise .* exp(i * phiMontagne);

figure(2);
subplot(2,2,1);
imshow(montagne);
title("Original montagne")

subplot(2,2,2);
imshow(fraise);
title("Original fraise");

subplot(2,2,3);
imshow(abs(ifft2(phaseFraiseModMontagne)), []);
title("Phase fraise module montagne");

subplot(2,2,4);
imshow(abs(ifft2(phaseMontagneModFraise)), []);
title("Phase montagne module fraise");