clc;
clear all;
close all;

%%%%%%%%%% PARAMETERS %%%%%%%%%%

size_block = 20;
size_overlap = 5;
out_height = 180;
out_width = 160;
n_blocks = 100;
n_best = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_rice = imread("textures/rice.bmp");
img_rice = im2double(img_rice);

I = method_1(img_rice, size_block, size_overlap, out_height, out_width);
imshow(I);