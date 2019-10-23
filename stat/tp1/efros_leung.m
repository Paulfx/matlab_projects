clear;
clc;
close all;

%
% ------- BEGIN CODE 
%

%
% ------- INIT / VARIABLES
%

%The sample
filename = "text2.png";
Ismp = imread(filename);
%Sample size
[Nsmp,Msmp,Csmp] = size(Ismp);

%output texture
outputSize = 128;
I = zeros(outputSize,outputSize,3);
% pixelFilled contain 0 if the pixel is not filled yet, else 1
PixelFilled = zeros(outputSize,outputSize);

%EPSILON
eps = 0.01;

%patch size
patchSize = 32; 
neighboringSize = 15;                                                                                                                                        ; % (need to be odd to have a centered pixel?)
neighboringOnes = ones(neighboringSize, neighboringSize);

%initialize I
%Get a random patch of size patchSize
% patch = Ismp(randi(Nsmp-patchSize+1)+(0:patchSize-1),randi(Msmp-patchSize+1)+(0:patchSize-1),:);

%get a patch at the center of Ismp
beginRow=floor(Nsmp/2-patchSize/2+1);
endRow=floor(Nsmp/2+patchSize/2);
beginCol=floor(Msmp/2-patchSize/2+1);
endCol=floor(Msmp/2+patchSize/2);
patch = Ismp(beginRow:endRow, beginCol:endCol, :);

%Put the patch at the center of I
beginP=floor(outputSize/2-patchSize/2+1);
endP=floor(outputSize/2+patchSize/2);
I(beginP:endP, beginP:endP, :) = patch;
%update filled (filled = true)
PixelFilled(beginP:endP, beginP:endP) = 1;

%
% ------------ END INIT
%

Ismp2 = double(Ismp) .* double(Ismp);
distanceToWP = zeros(Nsmp, Msmp);
nbRest = size(find(1-PixelFilled));
nbRest = nbRest(1);

% While all pixel are not filled
while nbRest ~= 0
    %tic
    
%
% ------- First, pick a pixel not filled yet with maximum filled neighboring pixels
%

  % c contains the number of neighboring pixels for each pixel
  c = conv2(PixelFilled, neighboringOnes, 'same'); %same=keep the input size
  
  % We multiply c pixel per pixel with PixelNotFilled
  % in order to filter only pixel not filled yet
  sumPixelNotFilled = c .* ( 1 - PixelFilled );
  
  %rowMax, colMax is the pixel p with maximal number of filled neighboring pixels
  [rowP,colP] = getRowMaxColMax(sumPixelNotFilled);

%
% ------- We have the pixel p, then we need to compute the distance of w(p) to all
% ------- patches of Ismp
%

  %need to get the patch wp around p
  %and the pixel filled wpFilled in this patch of size neighboringSize
  [wp,wpFilled] = getPatchAndFilledAroundP(neighboringSize, rowP, colP, I, PixelFilled);
  
  %compute the distances between wp and all the patch of size
  %neighboringSize of Ismp
  %This takes a long time (around 50% of the total time) 
  %but I found a way to vectorize the ssd
  
%   tic
%   %The parfor speeds up a little bit the for loop
%   parfor i = 1:Nsmp
%     for j = 1:Msmp
%       w = getPatchAroundP(neighboringSize, i, j, Ismp);
%       %Multpiply with wpFilled to not condisider pixel not filled yet
%       X = (w - wp) .* wpFilled;
%       distanceToWP(i,j) = sum(sum(sum(X.^2)));
%     end
%   end
%   toc

  %Vectorized version, speeds up the nested for loops
  %tic
  distanceToWP = computeAllDistances(wp,wpFilled,Ismp,Ismp2);
  %toc
  
%
% ------ Find wbest
%
      
  [rowMin,colMin] = getRowMinColMin(distanceToWP);
  %the distance with the best patch:
  dWpWbest = distanceToWP(rowMin,colMin);

%
% ------ Compute omega all the patches of Ismp that have a distance with wp <= 
% ------ (1+e) * dWpWbest
%

  omegaPrime = distanceToWP <= (1+eps) * dWpWbest;

%
% ------ Pick one randomly, and affect I(rowP,colP) to this value
%

  [M,N] = find(omegaPrime);
  bestSize= size(M,1);
  randomIndex = randi([1 bestSize]);

  %Chosen one:
  val = Ismp(M(randomIndex), N(randomIndex), :);

%
% ------ Put this value in I(p)
%

  I(rowP, colP, :) = val;
  %Update pixelFilled
  PixelFilled(rowP,colP) = 1;

  %imshow(uint8(I));

  %nbRest is the number of pixels not filled yet
  nbRest = nbRest - 1;

  %fprintf("Reste %i pixels\n", nbRest);
  %toc
end
%toc

%Display the result :
imshow(uint8(I));


%
% ------- FUNCTIONS
%

%Return wp the patch of size 'size' centered around a pixel p of coordinate [rowP, colP]
%And wfilled the pixel filled in this patch (0 if not filled OR outside the input image 'im'
function [wp, wfilled] = getPatchAndFilledAroundP(patchSize, rowP, colP, im, pixelFilled)
  p2 = floor(patchSize / 2);
  c = p2 + 1;
  [M,N,Ch] = size(im);
  wp = zeros(patchSize, patchSize, Ch);
  wfilled = zeros(patchSize, patchSize);

  startRowP = max(rowP - p2, 1);
  endRowP   = min(rowP + p2, M);
  startColP = max(colP - p2, 1);
  endColP   = min(colP + p2, N);

  wp(  c + startRowP - rowP : c + endRowP - rowP, c + startColP - colP : c + endColP - colP, :) = im(startRowP:endRowP, startColP:endColP, :);
  wfilled( c + startRowP - rowP : c + endRowP - rowP, c + startColP - colP : c + endColP - colP, :) = pixelFilled(startRowP:endRowP, startColP:endColP, :);
  
end

%%Function used in the nested for loop
% function wp = getPatchAroundP(patchSize, rowP, colP, im)  
%   p2 = floor(patchSize / 2);
%   c = p2 + 1;
%   [M,N,Ch] = size(im);
%   wp = zeros(patchSize, patchSize, Ch);

%   startRowP = max(rowP - p2, 1);
%   endRowP   = min(rowP + p2, M);
%   startColP = max(colP - p2, 1);
%   endColP   = min(colP + p2, N);

%   wp(  c + startRowP - rowP : c + endRowP - rowP, c + startColP - colP : c + endColP - colP, :) = im(startRowP:endRowP, startColP:endColP, :);
% end

function [rowMax,colMax] = getRowMaxColMax(im)
 [~,In] = max(im);
 [~,colMax] = max(max(im));
 rowMax = In(colMax);
end

function [rowMin,colMin] = getRowMinColMin(im)
 [~,In] = min(im);
 [~,colMin] = min(min(im));
 rowMin = In(colMin);
end

%Compute the ssd distance between wp and all the patches of Ismp
%of size patchSize, centered in (i,j)
%use of sum (x1 - x2)² = sum(x1²) + sum(x2²) - 2*sum(x1*x2)
function allDistance = computeAllDistances(wp, wpFilled, Ismp, Ismp2)
  
  wp2 = wp.^2;
  sum_wp = sum(wp2(:));
  
  x2_squared = convn(Ismp2, rot90(rot90(wpFilled)), 'same');
  
  %Sum the 3 channels
  x2_squared = sum(x2_squared,3);
  
  
  %conv 3 channels with 3 channels in one time?
  rot180_wp = rot90(rot90(wp));
  x1x2_channel1 = conv2(Ismp(:,:,1), rot180_wp(:,:,1), 'same');
  x1x2_channel2 = conv2(Ismp(:,:,2), rot180_wp(:,:,2), 'same');
  x1x2_channel3 = conv2(Ismp(:,:,3), rot180_wp(:,:,3), 'same');
  
  x1x2 = x1x2_channel1 + x1x2_channel2 + x1x2_channel3;
  
  allDistance = x2_squared - 2*x1x2 + sum_wp; 
  
end



