function [I] = method_1(img, size_block, size_overlap, out_height, out_width)
    
    n_ch = ndims(img);
    I = zeros(out_height, out_width, n_ch);
    size_non_overlap = size_block - size_overlap;
    
    for i = 1 : size_non_overlap : out_height-size_block+1
        for j = 1 : size_non_overlap : out_width-size_block+1
            block = getRandomBlock(img, size_block);
            I(i:i+size_block-1, j:j+size_block-1, :) = block;
        end
    end
    
    % cropping
    %I = I(1:out_height, 1:out_width, :);
end