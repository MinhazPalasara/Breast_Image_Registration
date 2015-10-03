
function [processed_image] = processImage(rawImage)
 %
 % Removing  the labels in the top corner of the image
 %

 CORNER_PERC = 0.4;

 % get the image size
 input_dims = size(rawImage);
 image_dims = input_dims(1:2);
 
 % top corner of the sample is considered for removal of the label
 top_mask_dims = round(image_dims * CORNER_PERC);      
 top_mask = zeros(top_mask_dims);
 pre_process_image_mask = ones(image_dims);

 pre_process_image_mask(1:top_mask_dims(1), 1:top_mask_dims(2)) = top_mask; 
            
 
 if size(input_dims, 2) == 3 % RGB image
    processed_image = uint8(cat(3, pre_process_image_mask, pre_process_image_mask, pre_process_image_mask))...
                      .* rawImage;   
 else % gray scale image
    processed_image = uint8(pre_process_image_mask).* rawImage;  
 end





