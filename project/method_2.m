function [I] = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, bool_seam_cut, bool_transfer, texture_brightness, transfer_brightness, alpha)
    
    % Handling methods 2, 3, and transfer texture
    if nargin <= 7
        bool_seam_cut = false;
    end    
    if nargin <= 8
        bool_transfer = false;
        texture_brightness = 0;
        transfer_brightness = 0;
        alpha = 0;
        texture_brightness_squared = 0;
        current_transfer_brightness = 0;
    end
    
    % Initializing variables
    ch = size(img,3);
    size_non_overlap = size_block - size_overlap;
    I = zeros(out_height+size_block, out_width+size_block, ch);
    
    % Getting sum of squares of pixels
    img_squared = img .^ 2;
    kernel = rot90(ones(size_block,size_overlap), 2);
    img_squared_left = convn(padarray(img_squared,size(kernel)-1,'post'), kernel, 'valid');
    kernel = rot90(ones(size_overlap,size_block), 2);
    img_squared_top = convn(padarray(img_squared,size(kernel)-1,'post'), kernel, 'valid');
    kernel = rot90(ones(size_overlap,size_non_overlap), 2);
    img_squared_top_minus_left = convn(padarray(img_squared,size(kernel)-1,'post'), kernel, 'valid');
    if bool_transfer
        kernel = rot90(ones(size_block,size_block), 2);
        texture_brightness_squared = convn(padarray(texture_brightness .^ 2,size(kernel)-1,'post'), kernel, 'valid');
        % Make transfer_brightness same size as I
        transfer_brightness = padarray(transfer_brightness, [size_block size_block], 'post');
    end
    
    % Synthesizing
    for i = 1 : size_non_overlap : out_height
        for j = 1 : size_non_overlap : out_width
            current_block = I(i:i+size_block-1, j:j+size_block-1, :);
            if bool_transfer
                current_transfer_brightness = transfer_brightness(i:i+size_block-1, j:j+size_block-1, :);
            end
            if i==1 && j==1
                % first block
                I(i:i+size_block-1, j:j+size_block-1, :) = getRandomBlock(img, size_block, n_best, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared);
            elseif i==1 && j > 1
                % left overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "left", bool_seam_cut, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left);
            elseif i > 1 && j==1
                % top overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "top", bool_seam_cut, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left);
            else
                % double overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "double", bool_seam_cut, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left);
            end
        end
    end
    
    % Cropping
    I = I(1:out_height, 1:out_width, :);
    
end
