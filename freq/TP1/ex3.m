clc;
clear;

n=100;
m=100;
d=10;
teta=pi/2;

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
imshow( log(1 + val * abs(imInv))  );




