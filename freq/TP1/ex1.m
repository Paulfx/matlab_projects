clear;
im = imread('fraise-foveon.jpg');
%figure(1);
%imshow(im);

class(im(1,1,1));

%Convert to black level
imMean = 1/3 * ( im(:,:,1) + im(:,:,2) + im(:,:,3) );
%imshow(imMean);

function resImage = imToGrayScale(inputImage)
  resImage = 0.2126 * inputImage(:,:,1) + 0.7152 * inputImage(:,:,2) + 0.0722 * inputImage(:,:,3);
endfunction

function resImage = imToBinary(inputImage, seuil)
  resImage = inputImage >= seuil;  
endfunction

imCoef = imToGrayScale(im);

imB = imToBinary(imCoef, 128);
%figure(1);
%imshow(imCoef);

%Extraire une ligne
ligne = im(1,:,:);
%plot(ligne)

tigre = imread('tigre.png');

function im_red = notSmartReduce(im, factor)
  im_red = im(1:factor:end, 1:factor:end, :);
endfunction

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

%val = 5
%log(1 + val * abs(im))

%imshow(.., []) recadre entre min et max

%fftshift => fréquence nulle au centre (+1,+1)
%fft2, ifft2
