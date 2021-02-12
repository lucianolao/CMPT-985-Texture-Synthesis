function [I] = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, bool_seam_cut, bool_transfer, img_transfer, alpha)
    
    % Handling methods 2, 3, and transfer texture
    if nargin <= 7
        bool_seam_cut = false;
        bool_transfer = false;
        img_transfer = 0;
        alpha = 0;
    elseif nargin <= 8
        bool_transfer = false;
        img_transfer = 0;
        alpha = 0;
    end
    
    % Initializing variables
    n_ch = ndims(img);
    size_non_overlap = size_block - size_overlap;
    I = zeros(out_height+size_block, out_width+size_block, n_ch);
    
    % Synthesizing
    for i = 1 : size_non_overlap : out_height
        for j = 1 : size_non_overlap : out_width
            current_block = I(i:i+size_block-1, j:j+size_block-1, :);
            if i==1 && j==1
                % first block
                I(i:i+size_block-1, j:j+size_block-1, :) = getRandomBlock(img, size_block, bool_transfer, img_transfer);
            elseif i==1 && j > 1
                % left overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "left", bool_seam_cut, bool_transfer, img_transfer, alpha);
            elseif i > 1 && j==1
                % top overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "top", bool_seam_cut, bool_transfer, img_transfer, alpha);
            else
                % double overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "double", bool_seam_cut, bool_transfer, img_transfer, alpha);
            end
        end
    end
    
    % Cropping
    I = I(1:out_height, 1:out_width, :);
    
end
