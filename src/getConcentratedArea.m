
function [finalBW]  = getConcentratedArea(registeredImage, debug)
%
% processing the result binary image, to remove small areas
% and noise	
%
%

DEBUG = debug;
%% I would propose creating new thresholding function
THRESHOLD = 0.3;

% Find  the boundy and remove it from further processing
boundry= removeBoundry(registeredImage);

processedRegisteredImage = im2bw(registeredImage, THRESHOLD);

% remove the boundry form an image
boundry_mask= processedRegisteredImage & boundry;
processedRegisteredImage = processedRegisteredImage - boundry_mask;


%% for filling holes in an image
dilated1 = imdilate(processedRegisteredImage, strel('disk', 5));
% % remove noise (smaller areas) created in the last operation
thinning2 = bwmorph(dilated1, 'shrink', 10); 
eroded3 = imerode(thinning2, strel('disk', 10));


%% Considering left out shapes, but with some mass. Smaller shapes are removed
filled4 = imfill(eroded3, 'holes');
%resetting the size of actual cancer cells, that were reduced in earlier
%cleaning
dilated5 = imdilate(filled4, strel('disk', 15));



% final cleaning
%%remvoing smaller shapes, I am assuming size 10 as the guide line for
%%considering a mass with some difference
finalBW = imerode(dilated5, strel('disk', 10));
% finalBW = dilated5;
 
if DEBUG == 1
   figure
   subplot(3,3,1) 
   imshow(processedRegisteredImage);
  
   subplot(3,3,2)
   imshow(dilated1);
   
   subplot(3,3,3)
   imshow(thinning2);
   
   subplot(3,3,4)
   imshow(eroded3);
   
   subplot(3,3,5)
   imshow(filled4);
   
   subplot(3,3,6)
   imshow(dilated5);
   
   subplot(3,3,7)
   imshow(finalBW);
end   

