clear;
clc;
close all;

%Convert to black level (naively, mean of R,G,B
function res = imToGrayNaive(input)
 res = 1/3 * ( input(:,:,1) + input(:,:,2) + input(:,:,3) );
endfunction

%Convert to gray scale with visual coefficients
function resImage = imToGrayScale(inputImage)
  resImage = 0.2126 * inputImage(:,:,1) + 0.7152 * inputImage(:,:,2) + 0.0722 * inputImage(:,:,3);
endfunction

%Convertir une image en binaire dépendant du seuil
function resImage = imToBinary(inputImage, seuil)
  resImage = inputImage >= seuil;  
endfunction

%Réduction de la taille d'une image en prenant un pixel sur factor pixels
%Revient à sous échantillonner notre image...
function im_red = notSmartReduce(im, factor)
  im_red = im(1:factor:end, 1:factor:end, :);
endfunction

%Reduction de la taille d'une image en utilisant une fft
%Revient à faire un filtre passe bas
function im_red = fftReduce(im, newSizeX, newSizeY)
  imFfft = fft2(im);
  shifted = fftshift(imFfft); %freq nulle au centre
  
  oldSizeX = length(im(:,1,:));
  oldSizeY = length(im(1,:,:));
  
  
  beginX = (oldSizeX / 2) + 1 - newSizeX / 2;
  endX = (oldSizeX / 2) + newSizeX / 2;
  
  beginY = (oldSizeY / 2) + 1 - newSizeY / 2;
  endY = (oldSizeY / 2) + newSizeY / 2;
  
  reduced = shifted(beginX:endX, beginY:endY,:);
  
  im_red = ifft2(reduced);
    
endfunction


im = imread('fraise-foveon.jpg');

imNaiveGray = imToGrayNaive(im);
imCoef = imToGrayScale(im);
imB = imToBinary(imCoef, 128);

figure(1);

subplot(2,2,1);
imshow(im);
title("Original image");

subplot(2,2,2);
imshow(imNaiveGray);
title("Image to gray scale naively");

subplot(2,2,3);
imshow(imCoef);
title("Image to gray scale with visual coefficients");

subplot(2,2,4);
imshow(imB);
title("Image to binary with value=127");

%Extraire une ligne
ligne = im(1,:,:);
%plot(ligne)

im = imread('tigre.png');
imRedNotSmart = notSmartReduce(im, 4);

%Faire une fftReduce revient à appliquer un filtre passe bas..
%On ne laisse plus passer les hautes fréquences qui contiennent
%Les informations sur les contours, ce qui lisse l'image
imRed = fftReduce(im, 1024, 1024);



%val = 5
%log(1 + val * abs(im))

%imshow(.., []) recadre entre min et max

%fftshift => fréquence nulle au centre (+1,+1)
%fft2, ifft2
