clear;
clc;
close all;

%
% ------- FUNCTIONS
%

%Return wp the patch of size 'size' centered around a pixel p of coordinate [rowP, colP]
%And wfilled the pixel filled in this patch (0 if not filled OR outside the input image 'im'
function [wp, wfilled] = getPatchAndFilledAroundP(patchSize, rowP, colP, im, pixelFilled)
  wp = getPatchAroundP(patchSize, rowP, colP, im);
  wfilled = getPatchAroundP(patchSize, rowP, colP, pixelFilled);
  
endfunction

function wp = getPatchAroundP(patchSize, rowP, colP, im)  
  p2 = floor(patchSize / 2);
  c = p2 + 1;
  [M N Ch] = size(im);
  wp = zeros(patchSize, patchSize, Ch);

  startRowP = max(rowP - p2, 1);
  endRowP   = min(rowP + p2, M);
  startColP = max(colP - p2, 1);
  endColP   = min(colP + p2, N);

  wp(  c + startRowP - rowP : c + endRowP - rowP, c + startColP - colP : c + endColP - colP, Ch) = im(startRowP:endRowP, startColP:endColP, Ch);

endfunction

function [rowMax colMax] = getRowMaxColMax(im)
 [M In] = max(im);
 [M2 colMax] = max(max(im));
 rowMax = In(colMax);
endfunction

function [rowMin colMin] = getRowMinColMin(im)
 [M In] = min(im);
 [M2 colMin] = min(min(im));
 rowMin = In(colMin);
endfunction

function dist = euclidianDistanceBetweenTwoPatches(w1,w2)
  [M N] = size(w1);
endfunction

function mse = meanSquareErrorBetweenTwoPatches(w1, w2)
  [M N] = size(w1);
  error = w1 - w2;
  mse = sum(sum(error .* error)) / (M * N);
endfunction

%
% ------- BEGIN CODE 
%

%TODO DEMANDER CANAUX....
%CAR CONV IMPOSSIBLE AVEC 3 CANAUX

%
% ------- INIT / VARIABLES
%

%The sample
filename = "text4.png";
Ismp = imread(filename);
[Nsmp Msmp Csmp] = size(Ismp);%Sample size

%output texture
outputSize = 128;
I = zeros(outputSize,outputSize,3);
% pixelFilled contain 0 if the pixel is not filled yet, else 1
PixelFilled = zeros(outputSize,outputSize);

%patch size
patchSize = 64; 
neighboringSize = 7;                                                                                                                                        ; % (need to be odd to have a centered pixel?)
neighboringOnes = ones(neighboringSize, neighboringSize);

%initialize I
%Get a random patch of size L*L
patch = Ismp(randi(Nsmp-patchSize+1)+(0:patchSize-1),randi(Msmp-patchSize+1)+(0:patchSize-1),:);

%get a patch at the center of Ismp
%beginP=floor(Nsmp/2-patchSize/2+1);
%endP=floor(Msmp/2+patchSize/2);
%patch = Ismp(beginP:endP, beginP:endP, :);

%Put the patch at the center of I
beginP=floor(outputSize/2-patchSize/2+1);
endP=floor(outputSize/2+patchSize/2);
I(beginP:endP, beginP:endP, :) = patch;
%update filled (filled = true)
PixelFilled(beginP:endP, beginP:endP) = 1;

%
% ------------ END INIT
%

% While all pixel are not filled

distanceToWP = zeros(Nsmp, Msmp);

nbRest = size(find(1-PixelFilled))(1);

%while size(find(1-PixelFilled))(1) ~= 0
while nbRest ~= 0

 nbRest
  
  
  %
  % ------- First, pick a pixel not filled yet with maximum filled neighboring pixels
  %

  % c contains the number of neighboring pixels for each pixel
  c = conv2(PixelFilled, neighboringOnes, 'same'); %same=keep the input size
  % We multiply c pixel per pixel with PixelNotFilled
  % in order to filter only pixel not filled yet
  sumPixelNotFilled = c .* ( 1 - PixelFilled );

  %rowMax, colMax is the pixel p with maximal number of filled neighboring pixels
  [rowP colP] = getRowMaxColMax(sumPixelNotFilled);

  %
  % ------- We have the pixel p, then we need to compute the distance of w(p) to all
  % ------- patches of Ismp
  %

  %need to get the patch around p, and the pixel filled in this patch of size neighboringSize
  [wp wpFilled] = getPatchAndFilledAroundP(neighboringSize, rowP, colP, I, PixelFilled);


  %On a le patch, on veut faire la différence entre chaque pixel de wp 
  %et chaque pixels des patch de Ismp, sommée au carré
  tic
  for i = 1:Nsmp
   
    for j = 1:Msmp
      
      
      w = getPatchAroundP(neighboringSize, i, j, Ismp);
      
      X = (wp - w) .* wpFilled;
      ssd = sum(X(:).^2);
      distanceToWP(i,j) = ssd; 
    endfor
   
   endfor
  toc

  %ismp2 = 



%   %Sum of all pixels of the patch p
%   %For each channel, todo make all at once
%   sumWp1 = sum(wp(:,:,1)(:));
%   sumWp2 = sum(wp(:,:,2)(:));
%   sumWp3 = sum(wp(:,:,3)(:));
% %No problem for filled/not filled because euclidian distance...
%   %Distance of all the patch of sample, 0 if not filled yet..
  
%   %TODO check canaux, faire distance pour chaque couleur ? 
%   %Surement mieux
%   sumFilledOfSMP1 = conv2(Ismp(:,:,1), wpFilled, 'same');
%   sumFilledOfSMP2 = conv2(Ismp(:,:,2), wpFilled, 'same');
%   sumFilledOfSMP3 = conv2(Ismp(:,:,3), wpFilled, 'same');

%   %the distances are stored in a matrix which each value is the distance between
%   %The patch wp and the patch around the value
%   distanceToWP1 = abs(sumFilledOfSMP1 - sumWp1);
%   distanceToWP2 = abs(sumFilledOfSMP2 - sumWp2);
%   distanceToWP3 = abs(sumFilledOfSMP3 - sumWp3);
 
%   distanceToWP = distanceToWP1 + distanceToWP2 + distanceToWP3;

  %sumDistancePatch = conv2(Ismp, wpFilled, 'same');
  
  
  [rowMin colMin] = getRowMinColMin(distanceToWP);
  %the distance with the best patch:
  dWpWbest = distanceToWP(rowMin,colMin);

  %the best patch in Ismp
  %wbest = getPatchAroundP(neighboringSize, rowMin, colMin, Ismp(:,:,1));

  %
  % ------ Compute omega all the patches of Ismp that have a distance with wp <= 
  % ------ (1+e) * dWpWbest
  %
  eps = 0.1;
  
  omegaPrime = distanceToWP <= (1+eps) * dWpWbest;

  %Pick one randomly, and affect I(rowP,colP) to this value
  [M N] = find(omegaPrime);
  nbSame = size(M,1);
  randomIndex = randi([1 nbSame]);

  %Chosen one:
  val = Ismp(M(randomIndex), N(randomIndex), :);

  %Put this value in I(p)
  I(rowP, colP, :) = val;
  %Update pixelFilled
  PixelFilled(rowP,colP) = 1;



  %imshow(uint8(I));

  nbRest = size(find(1-PixelFilled))(1);

  %fprintf("Reste %i pixels\n", nbRest);

endwhile

%imshow(uint8(I));






