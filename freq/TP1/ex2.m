clc;
clear;
close all;

%Image fond noir
%taille N = 1024
N = 1024;
im = zeros(N,N);

%Carré blanc au milieu
%de taille T
T = 5

beginX = (N/2) - T/2;
endX = (N/2) + T/2;
  
beginY = (N / 2) + 1 - T / 2;
endY = (N / 2) + T / 2;

im( beginX:endX, beginY:endY ) = 255;

%figure(1);
%subplot(2,2,1);
%imshow(im);
%title("Original image");

imFFT = fftshift(fft2(im));
%subplot(2,2,2);
val = 1;
imFFT = log(1 + val * abs(imFFT));
%figure(1);
%imshow(imFFT, []);

%
%surf(imFFT)


%e
%r= desired radius
%x = x coordinates of the centroid
%y = y coordinates of the centroid
%r = 30;
%x = 0;
%y = 0;
%th = 0:pi/50:2*pi;
%xunit = r * cos(th) + x;
%yunit = r * sin(th) + y;
%h = plot(xunit, yunit);


% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
%imageSizeX = 640;
%imageSizeY = 480;
%[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
%centerX = 320;
%centerY = 240;
%radius = 100;
%circlePixels = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
%image(circlePixels) ;
%colormap([0 0 0; 1 1 1]);
%title('Binary image of a circle');
