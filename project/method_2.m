function [I] = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, use_seam_cut)
    
    if nargin < 8
        use_seam_cut = false;
    end
    
    n_ch = ndims(img);
    size_non_overlap = size_block - size_overlap;
    
    I = zeros(out_height+size_block, out_width+size_block, n_ch);
    
    for i = 1 : size_non_overlap : out_height
        for j = 1 : size_non_overlap : out_width
            current_block = I(i:i+size_block-1, j:j+size_block-1, :);
            if i==1 && j==1
                % first block
                I(i:i+size_block-1, j:j+size_block-1, :) = getRandomBlock(img, size_block);
            elseif i==1 && j > 1
                % left overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "left", use_seam_cut);
            elseif i > 1 && j==1
                % top overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "top", use_seam_cut);
            else
                % double overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "double", use_seam_cut);
            end
        end
    end
    
    % cropping
    I = I(1:out_height, 1:out_width, :);
    
end
