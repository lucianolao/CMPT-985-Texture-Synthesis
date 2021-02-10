function [I] = method_1(img, size_block, size_overlap, out_height, out_width)
    
    n_ch = ndims(img);
    size_non_overlap = size_block - size_overlap;
    
    %I = zeros(out_height+size_non_overlap, out_width+size_non_overlap, n_ch);
    I = zeros(out_height+size_block, out_width+size_block, n_ch);
    
    for i = 1 : size_non_overlap : out_height
        for j = 1 : size_non_overlap : out_width
            I(i:i+size_block-1, j:j+size_block-1, :) = getRandomBlock(img, size_block);
        end
    end
    
    % cropping
    I = I(1:out_height, 1:out_width, :);
end