clc
clear all
close all

%% PARAMETERS %%%%%%%%%%%%%%%%%%

size_block = 50;
size_overlap = 10;
tolerance = 1.5;
n_best = 50;
alpha = 0.90;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Check input
if size_block == size_overlap || size_block < size_overlap
    error("MyError: wrong input for size_block and/or size_overlap");
end
if size_block<=0 || size_overlap<=0 || n_best<=0
    error("MyError: non-positive input value");
end
if tolerance <= 1
    error("MyError: tolerance must be greater than 1");
end
if alpha < 0 || alpha > 1
    error("MyError: alpha must be between 0 and 1");
end


%% Read images
img_rice = im2double(imread("textures/rice.bmp"));
img_brick = im2double(imread("textures/brick.jpg"));
img_radishes = im2double(imread("textures/radishes.jpg"));
img_text = im2double(imread("textures/text.jpg"));
img_weave = im2double(imread("textures/weave.jpg"));
img_apples = im2double(imread("textures/apples.png"));
img_grass = im2double(imread("textures/grass.png"));
img_random = im2double(imread("textures/random.png"));
img_random3 = im2double(imread("textures/random3.png"));
img_toast = im2double(imread("textures/toast.png"));

img_al = im2double(imread("images/al.jpg"));
img_ml = im2double(imread("images/ml.jpg"));


%% Synthesize and Transfer

img_transfer = img_al;
% img_transfer = img_ml;

% Run many images syntheses
% run(img_rice, "rice", 30, 5, tolerance, n_best, img_transfer, alpha);
% run(img_brick, "brick", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_radishes, "radishes", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_text, "text", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_weave, "weave", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_apples, "apples", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_grass, "grass", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_random, "random", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_random3, "random3", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% run(img_toast, "toast", size_block, size_overlap, tolerance, n_best, img_transfer, alpha);


%% Function to automatize
function run(img_texture, img2save, size_block, size_overlap, tolerance, n_best, img_transfer, alpha)
    
folder = "results/";
[out_height, out_width, ~] = size(img_texture);
out_height = out_height * 5;
out_width = out_width * 5;
% out_height = 180;
% out_width = 160;

I1 = method_1(img_texture, size_block, size_overlap, out_height, out_width);
imwrite(I1, strcat("../../",folder,img2save,"_1_",num2str(size_block),"_",num2str(size_overlap),".jpg"));
% imshow(I1);

I2 = method_2(img_texture, size_block, size_overlap, out_height, out_width, tolerance, n_best);
imwrite(I2, strcat("../../",folder,img2save,"_2_",num2str(size_block),"_",num2str(size_overlap),".jpg"));
% imshow(I2);

I3 = method_3(img_texture, size_block, size_overlap, out_height, out_width, tolerance, n_best);
imwrite(I3, strcat("../../",folder,img2save,"_3_",num2str(size_block),"_",num2str(size_overlap),".jpg"));
% imshow(I3);

% I4 = transfer(img_texture, size_block, size_overlap, tolerance, n_best, img_transfer, alpha);
% imwrite(I4, strcat("../../",folder,img2save,"_4_",num2str(size_block),"_",num2str(size_overlap),"_",num2str(alpha),".jpg"));
% imshow(I4);

disp(img2save);
end


