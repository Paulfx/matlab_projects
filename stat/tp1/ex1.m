clear;
close all;

filename = "text0.png";
Ismp = imread(filename);
%taille du sample
[Nsmp Msmp Csmp] = size(Ismp);


outputSize = 32;
I = zeros(outputSize,outputSize,3);
PixelFilled = zeros(outputSize,outputSize);

L = 6; %Taille du patch
neighboringSize = 6; %Taille du voisinage
neighboringOnes = ones(neighboringSize, neighboringSize);

%initialize I
%Get a random patch of size L*L
%patch = Ismp(randi(Nsmp-L+1)+(0:L-1),randi(Msmp-L+1)+(0:L-1));

%get a patch at the center of Ismp
beginP=Nsmp/2-L/2+1;
endP=Msmp/2+L/2;
patch = Ismp(beginP:endP, beginP:endP, :);

%Put at the center of I
beginP=outputSize/2-L/2+1;
endP=outputSize/2+L/2;
I(beginP:endP, beginP:endP, :) = patch;
%update filled (filled = true)
PixelFilled(beginP:endP, beginP:endP) = 1;

c = conv2(PixelFilled, neighboringOnes, 'same');
[M In] = max(c);
[M2 I2] = max(max(c));

%I2 => numéro de la colonne
%I1 => numéro de la ligne
I1 = In(I2);
