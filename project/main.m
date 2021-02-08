clc;
clear all;
close all;

%% PARAMETERS %%%%%%%%%%%%%%%%%%

size_block = 20;
size_overlap = 5;
out_height = 180;
out_width = 160;
tolerance = 1.5;
n_best = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Check input
if size_block == size_overlap || size_block < size_overlap
    error("MyError: wrong input for size_block and/or size_overlap");
end
if size_block<=0 || size_overlap<=0 || out_height<=0 || out_width<=0 || n_best<=0
    error("MyError: non-positive input value");
end
if tolerance <= 1
    error("MyError: tolerance must be greater than 1");
end


%% Read images
img_rice = imread("textures/rice.bmp");
img_rice = im2double(img_rice);

% for out_width = 120:160
    I = method_1(img_rice, size_block, size_overlap, out_height, out_width);
% end
% imshow(I);

I2 = method_2(img_rice, size_block, size_overlap, out_height, out_width, tolerance, n_best);

imshow([I I2]);
