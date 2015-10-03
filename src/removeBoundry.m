function [processed_image] = removeBoundry(image)
%
% removing the boundry of an image
%
%

binaryImage = imfill(im2bw(image, 0),'holes');

%It would grow both the sides, hence effective reduction would be only half
s=strel('disk', 40, 0);

complement=~binaryImage;%binary Image

eroded=imerode(complement, strel('disk', 4, 0));%Erode the image by structuring element

processed_image = imdilate(complement-eroded, s);






