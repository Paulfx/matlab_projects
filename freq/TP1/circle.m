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


%convoluer avec un disque en spatial => multiplier par un filtre passe bas en fréquence
% 

im = imread("tigre.png");

imFFT = fft2(im);

phi = angle(imFFT);
modul = real(imFFT);

