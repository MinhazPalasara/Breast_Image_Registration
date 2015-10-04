# Breast Image Registration

A program helps in locating possible tumor by locating abnormalities in mammograms. Image registration is used to find abnormal areas. See the resultant images for each case in the sample_result folder.

## Algorithm Steps:

- __Pre-process Image.__ Remove label from an image present in the top left corner.

- __Transform Image.__ Finding matching areas by using SIFT descriptor. Usw these mappings to develop a transform ( Assumption: only translation + rotation is present, no shear). Use this transform to align two images.

- __Aligned Image Difference processing.__ Get the difference of aligned images to get abnormal areas. Process this image to remove smaller masses(usually noise). Also remove the edge pixels from the image as the edge pixels are brighter due to a Sharpe change in shape at edges. 

- __Locate Abnormal Areas.__ Locate masses with reasonable size, find bounding box around the regions and locate the breast that has this mass.

## Explanation

There are two options that could be used for image registration and then locating cancer. Registration using pixels intensities and the feature matching. I have used the features matching technique for registration. I am using SIFT features to find key points in images for registration. I have used VLSIFT in matlab for this purpose. 
These features are used to find the Similarity Transform between the images. I use this transform to align the images. The absolute difference of these images highlights the areas having unusual objects. This image is processed to find the connected regions and at same time remove the noise(smaller areas caused mainly due to the difference in the breast sizes). The processed image is used further to find the bounding box around the cells and hence locate the cancer in breast.

Problems:
1)
Features matching has high number of outliers(breast in majority of its area has blank mass without any detailing). High numbers of outliers than inliers is not good to find robust inliers and hence transform. In my implementation I have increased the number of RANSAC iterations to get robust transform and the SIFT Gaussian window size to consider more area to find the considerable and robust key points(not noise). But still 2/10 times I get unlikely registration. I am proposing to implement the combination of pixel registration with feature registration for find a robust results. In this we could consider the feature key points to find transform, but the goodness of fit is based on the SSD(sum square difference).

2) Modifying the absolute difference to non linear difference to find abnormal objects in registered image. I face this problem in case5(please see the image Case5-2.jpg and Case5-3.jpg images in the result folder). The Case5-rcc.jpg has some high intensity cells(towards the bottom of the central white mass) but scattered and overlapped with the majority of white cells. Also, the central mass is more dense in Case5-lcc.jpg then case5-rcc.jpg, possibly cancer. Hence, I would say my result is right, but the scattered shape in Case5-rcc.jpg should also be highlighted. But, that scattered difference gets removed in noise removals due to a very small difference and more scattered points. If before taking the difference of registered image, we non linearly adjust the intensity. This would make sure that the difference between the two white pixels is more than the difference between two near black pixels. This would I think solve the problem faced in case 5.


## Processed Results
First image: Registration of images
Second Image: Binary processing to remove small areas and noises(holes)
Third Image: Locating the area with cancer cells

