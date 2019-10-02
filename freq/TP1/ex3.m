clc;
clear;
close all;

%   Fonctions Internes    %

function resImage = imToGrayScale(inputImage)
  resImage = 0.2126 * inputImage(:,:,1) + 0.7152 * inputImage(:,:,2) + 0.0722 * inputImage(:,:,3);
endfunction

%Fonction renvoyant la fft inverse d'une image de taille (n,m) au fond noir
%avec le pixel blanc central et deux diracs (deux pixels blancs) à une
%distance d du centre, incliné d'un angle teta (en radian)
function img = inv2dirac(n,m,d,teta)
    img = zeros(n,m);
    dx = floor(d * cos(teta));
    dy = floor(d * sin(teta));
    xCentre = floor((n / 2) + 1);
    yCentre = floor((m / 2) + 1);
    img(xCentre, yCentre) = 255;% point central
    img(xCentre + dx ,yCentre + dy) = 255;
    img(xCentre - dx ,yCentre - dy) = 255;%symetrique
    img = ifft2(img);
endfunction

%NEED COMMENT
function img = getImgCircle(n,m,radius)
    [col, row] = meshgrid(1:n, 1:m);
    centerX = n / 2 + 1;
    centerY = m / 2 + 1;
    circlePixels = (row - centerY).^2 + (col - centerX).^2 <= radius.^2;
    img = circlePixels * 255; %%Affiche en blanc
endfunction

n = 512; % size image
m = 512;
d = 10;
teta = pi / 4; %radian

figure(1);

fft_inv = inv2dirac(n,m,d,teta);
subplot(2,2,1);
imshow(abs(fft_inv),[]);
title('d = 10');

%Dans notre image de depart nous avons deux diracs equidistants d'une distance d, On obtient
%donc bien apres l'application d'une fft inverse, un sinus d'une période égale à 1/d.

d = 5;
fft_inv = inv2dirac(n,m,d,teta);
subplot(2,2,2);
imshow(abs(fft_inv),[]);
title('d = 5');

%En diminuant la distance entre les diracs, on obtient un sinus avec une 
%fréquence plus faible (f proportionnel d) 

d = 30;
fft_inv = inv2dirac(n,m,d,teta);
subplot(2,2,3);
imshow(abs(fft_inv),[]);
title('d = 30');
%mesh(fft_inv);

%Meme remarque que précedement, avec une distance plus grande on a une
%distance plus élevée.

d = 10;
teta = pi / 2;
fft_inv = inv2dirac(n,m,d,teta);
subplot(2,2,4);
imshow(abs(fft_inv),[]);
title('teta = pi / 2');
%La variation de l'angle teta se retrouve dans la transformée inverse. Le
%sinus horizontal car on a des barres verticales
%TODO expliquer angle


%Cercle
figure(2);
imgCercle = getImgCircle(n,m,5);
subplot(2,2,1);
imshow(imgCercle);
im = fftshift(ifft2(imgCercle));
title('Cercle rayon = 5');
subplot(2,2,2);
%mesh(im);
imshow(abs(im), []);
title("ifft cercle rayon 5")

imgCercle = getImgCircle(n,m,25);
subplot(2,2,3);
imshow(imgCercle);
title("Cercle rayon 25");

im = fftshift(ifft2(imgCercle));
subplot(2,2,4);
imshow(abs(im), []);
title("ifft cercle rayon 25");

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

figure(3);

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

figure(4);
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