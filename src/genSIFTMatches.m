function [xs, xd] = genSIFTMatches(imgs, imgd)

% Add the sift library to path if the sift mex file cannot be found
% Here I assume the sift_lib is placed at a predefined location 
% (relative path)
if ~isequal(exist('vl_sift'), 3)
    sift_lib_dir = fullfile('sift_lib', ['mex' lower(computer)]);
    orig_path = addpath(sift_lib_dir);
    % Restore the original path upon function completion 
    temp = onCleanup(@()path(orig_path));
end

imgs = im2single(imgs); 

if size(size(imgs),2) == 3 % RGB image
    gray_s = rgb2gray(imgs);
else 
    gray_s = imgs;
end

imgd = im2single(imgd ); 

if size(size(imgs),2) == 3 % RGB image
    gray_d = rgb2gray(imgd);
else 
    gray_d = imgd;
end

[Fs, Ds] = vl_sift(gray_s, 'WindowSize', 200);


% Each column of Fs is a feature frame and has the format [X; Y; S; TH],
% where X, Y is the (fractional) center of the frame, S is the scale and TH
% is the orientation (in radians)
% Ds is the descriptor of the corresponding frame in F.
[Fd, Dd] = vl_sift(gray_d, 'WindowSize', 200);


[matches, scores] = vl_ubcmatch(Ds, Dd);
% matches: 2xn matrix, scores: 1xn matrix
% The two rows of matches store the indices of Ds and Dd that match with
% each other

xs = Fs(1:2, matches(1, :))';
xd = Fd(1:2, matches(2, :))';
% xs and xd are the centers of matched frames
% xs and xd are nx2 matrices
