
function [result, alignedSImage, alignedDImage] = registerImage(sImage, dImage, debug)

DEBUG = debug;

imgs  = processImage(imread(sImage));
imgd = processImage(imread(dImage));

% extracting the similar looking features from the images
[xs, xd] = genSIFTMatches(imgs, imgd);

%% finding inliers
[tform,inlierPtD,inlierPtS] = estimateGeometricTransform(xd, xs,'similarity',...
                              'MaxNumTrials', 25000, 'MaxDistance', 20);
                          
%% transform the image to find mass                        
alignedDImage = imwarp(imgd, tform);
alignedSImage = zeros(size(alignedDImage), 'uint8');

if size(size(imgs), 2) == 3
    alignedSImage(1:size(imgs,1), 1: size(imgs,2), :) = imgs;
else
    alignedSImage(1:size(imgs,1), 1:size(imgs,2)) = imgs;
end

%% Over-lapping mask for finding region of interest
resultMask = im2bw(alignedSImage,0) & im2bw(alignedDImage, 0);

diffImage = imabsdiff(alignedDImage, alignedSImage);

% masking the resultant image with the area of interest
if size(size(imgs), 2) == 3 % RGB image
  result = uint8(cat(3, resultMask, resultMask, resultMask)).* diffImage;
else 
  result = uint8(resultMask) .* diffImage;
end  


if DEBUG == 1
    % showing matched features, including outliers
    figure
    subplot(3,3,1)
    showMatchedFeatures(imgs, imgd, xs, xd);
    title('Matched SIFT points, also has outliers');
    
    % showing matched features, only inliers
    subplot(3,3,2)
    showMatchedFeatures(imgs, imgd, inlierPtS, inlierPtD);
    title('Matched inlier points');
    
    % showing aligned destination image
    subplot(3,3,3)
    imshow(alignedDImage);
    title('Aligned Destination image');
    imwrite(alignedDImage,'alinged_destination_image.jpg');
     
    % showing aligned source image
    subplot(3,3,4) 
    imshow(alignedSImage);
    title('Aligned Source image');
    imwrite(alignedSImage,'alinged_source_image.jpg');
       
    % showing aligned image diff
    subplot(3,3,5)
    imshow(diffImage);
    title('Aligned Image diff');   
    imwrite(diffImage, 'alinged_image_diff.jpg');
       
    subplot(3,3,6)
    imshow(resultMask);
    imwrite(resultMask, 'aligned_images_mask.jpg');
    
    subplot(3,3,7)
    imshow(result);
    imwrite(result, 'registered_image.jpg');
end







