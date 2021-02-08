function [I] = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best)
    
    n_ch = ndims(img);
    size_non_overlap = size_block - size_overlap;
    
    I = zeros(out_height+size_non_overlap, out_width+size_non_overlap, n_ch);
    
    for i = 1 : size_non_overlap : out_height
        for j = 1 : size_non_overlap : out_width
            current_block = I(i:i+size_block-1, j:j+size_block-1, :);
            if i==1 && j==1
                % first block
                I(i:i+size_block-1, j:j+size_block-1, :) = getRandomBlock(img, size_block);
            elseif i==1 && j > 1
                % left overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "left");
            elseif i > 1 && j==1
                % top overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "top");
            else
                % double overlap
                I(i:i+size_block-1, j:j+size_block-1, :) = pickBlock(img, current_block, size_overlap, tolerance, n_best, "double");
            end
        end
    end
    
    % cropping
    I = I(1:out_height, 1:out_width, :);
end