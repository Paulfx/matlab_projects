clear;
clc;


function img = getImgCircle(n,m,radius)
    [col row] = meshgrid(1:n, 1:m);
    centerX = n / 2 + 1;
    centerY = m / 2 + 1;
    circlePixels = (row - centerY).^2 + (col - centerX).^2 <= radius.^2;
    img = circlePixels * 255; %%Affiche en blanc
end;

imgCircle = getImgCircle(512,512,3);

im = fftshift(ifft2(imgCircle));
 
phi = angle(im);
modul = real(im);


%imshow(abs(im), []);

function resImage = imToGrayScale(inputImage)
  resImage = 0.2126 * inputImage(:,:,1) + 0.7152 * inputImage(:,:,2) + 0.0722 * inputImage(:,:,3);
endfunction


%convoluer avec un disque en spatial => multiplier par un filtre passe bas en fréquence
% 

im = imread("fraise-foveon.jpg");
im = imToGrayScale(im);

imFFT = fft2(im);

%Show fftshift
figure(); imshow(abs(fftshift(imFFT)));

phi = angle(imFFT);
modul = abs(imFFT);

imFFT = fftshift(imFFT);

imFFT = imag(imFFT) + real(imFFT);

IFF = ifft2(imFFT);

%Convert to uint8
final = uint8(real(IFF));

figure();
imshow(final);
