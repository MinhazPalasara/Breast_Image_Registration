function[] = detectCancer(image1, image2, debug)
%
% Locate cancer in the memogram, this is the main
% function for applicaion
%
%
DEBUG = debug;
% highligting the 
MINIMUM_NUM_PIXELS = 10;

% Considering the image with bigger breast as a reference
if sum (sum( im2bw( imread(image1),0))) > sum (sum(im2bw(imread(image2), 0))) 
    sImage = image1;
    dImage = image2;
else
    sImage = image2;
    dImage = image1;
end    

[registeredImage, alignedSImage, alignedDImage] = registerImage(sImage,...
                                                  dImage, DEBUG);

% registeredImage = imread('registered_image.jpg');
% alignedSImage = imread('alinged_source_image.jpg');
% alignedDImage = imread('alinged_destination_image.jpg');
                                               
                                               
%% Finding the masses(connected regions), remove if the masses are small
conImage = getConcentratedArea(registeredImage, DEBUG);

CC = bwconncomp(conImage);
numPixels = cellfun(@numel, CC.PixelIdxList);
BW = zeros(size(conImage));

%making sure that the region is considerably large
for i = 1:size(numPixels, 2)
   if numPixels(i) > MINIMUM_NUM_PIXELS
       BW(CC.PixelIdxList{i}) = 1; 
   end     
end    

%% Finding the boundingBox of the shapes 
boundingBoxStruct = regionprops(BW,'BoundingBox');
boundingBox = boundingBoxStruct.BoundingBox;

figure;
subplot(2,1,1)
imshow(alignedSImage);
title(sImage)

subplot(2,1,2)
imshow(alignedDImage);
imshow(dImage)
title(dImage)


for i = 1:size(boundingBox, 1)

%% Highlight the area in the plot, considering imahe that has higher intensity
%   detect cancer location, either in source or destination. Cancer cells
%   have more intensity(dense region) than the normal cells
  if sum(sum(alignedSImage(boundingBox(i,1):...
                           boundingBox(i, 1)+boundingBox(i, 3),...
                           boundingBox(i,2):boundingBox(i, 2)+boundingBox(i, 4))))> ...
      sum(alignedDImage(boundingBox(i,1):boundingBox(i, 1)+boundingBox(i, 3),...
                           boundingBox(i,2):boundingBox(i, 2)+boundingBox(i, 4))) 
     subplot(2,1,1) 
     rectangle('Position',boundingBox(i,:), 'LineWidth', 2, 'EdgeColor','b');
     
  else
     subplot(2,1,2)
     rectangle('Position',boundingBox(i,:), 'LineWidth', 2, 'EdgeColor','b');
   
 end
 end


