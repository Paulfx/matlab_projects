%ALIASING
clear;
clc;
close all;

%Fonctions:

function I = imzoneplate(N)
%imzoneplate Zone plate test pattern
%
%   SYNTAX
%
%   I = imzoneplate
%   I = imzoneplate(N)
%
%   DESCRIPTION
%
%   I = imzoneplate creates a 501-by-501 zone plate test image. This is a
%   radially symmetric pattern with low frequencies in the middle and high
%   frequencies near the edge.
%
%   I = imzoneplate(N) creates an N-by-N zone plate test image.
%
%   EXAMPLES
%
%   Create a test image with the default size (501-by-501).
%
%       I = imzoneplate;
%       imshow(I)
%
%   Create a smaller test image and plot its cross-section.
%
%       I = imzoneplate(151);
%       plot(I(76,:))
%
%   REFERENCE
%
%   Practical Handbook on Image Processing for Scientific Applications, by
%   Bernd J�hne, CRC Press, 1997. See equation 10.63:
%
%   g({\bf x}) = g_0 \sin\left(\frac{k_m|{\bf x}|^2}{2r_m}\right) 
%   \left[\frac{1}{2} \tanh\left(\frac{r_m-|{\bf x}|}{w}\right) + 
%   \frac{1}{2}\right]
%
%   In this equation, g takes on values in the range [-1,1]. imzoneplate
%   returns I = (g+1)/2, which takes on values in the range [0,1].
%
%   See also http://blogs.mathworks.com/steve/2011/07/19/jahne-test-pattern-take-3/
%   Copyright 2012 The MathWorks, Inc.
%   Steven L. Eddins
if nargin < 1
    N = 501;
end
if rem(N,2) == 1
    x2 = (N-1)/2;
    x1 = -x2;
else
    x2 = N/2;
    x1 = -x2 + 1;
end
[x,y] = meshgrid(x1:x2);
r = hypot(x,y);
km = 0.7*pi;
rm = x2;
w = rm/10;
term1 = sin( (km * r.^2) / (2 * rm) );
term2 = 0.5*tanh((rm - r)/w) + 0.5;
g = term1 .* term2;
I = (g + 1)/2;

endfunction

function mat = gauss2d(mat, sigma, center)
gsize = size(mat);
[R,C] = ndgrid(1:gsize(1), 1:gsize(2));
mat = gaussC(R,C, sigma, center);
endfunction

function val = gaussC(x, y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
val       = (exp(-exponent));
endfunction

function img = getImgCircle(n,m,radius)
    [col, row] = meshgrid(1:n, 1:m);
    centerX = n / 2 + 1;
    centerY = m / 2 + 1;
    circlePixels = (row - centerY).^2 + (col - centerX).^2 <= radius.^2;
    img = circlePixels * 255; %%Affiche en blanc
endfunction

function echIm = echantillonne(im, decimation)
 [M N Ch] = size(im);
 echIm = im(1:decimation:M, 1:decimation:N, :);
endfunction

function showEchantillonne(im)

	figure();
	subplot(2,2,1);
	imshow(im, []);
	title("Image originale");

	subplot(2,2,2);
	imshow(echantillonne(im,2), []);
	title("Image echantillonée 1 pixel sur 2");

	subplot(2,2,3);
	imshow(echantillonne(im,4), []);
	title("Image echantillonée 1 pixel sur 4");

	subplot(2,2,4);
	imshow(echantillonne(im,8), []);
	title("Image echantillonée 1 pixel sur 8");

endfunction

%image cos horizontal
M = N = 2048;
T = 5;
imgCosH = ones(M,1) * cos(2 * pi * (1:N) / T);
%imshow(imgCosH);
showEchantillonne(imgCosH);


%image cos décalé d'un angle
d=50;
teta=pi/4;
dx = floor(d * cos(teta));
dy = floor(d * sin(teta));
im = zeros(M,N);
xcentre = floor((M/2) + 1);
ycentre = floor((N/2) + 1);
im(xcentre, ycentre) = 255;
im(xcentre+dx, ycentre+dy) = 255;
im(xcentre-dx, ycentre-dy) = 255;

imgCosTeta = ifft2(im);
%imshow(abs(imgCosTeta),[]);


imgCircle = getImgCircle(512,512, 100);
%showEchantillonne(imgCircle);


Z = imzoneplate(501);
%imshow(echantillonne(Z, 8));

%showEchantillonne(Z);
