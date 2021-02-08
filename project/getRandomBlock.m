function [I] = getRandonBlock(img, size_block)

    [height, width, ~] = size(img);
    
    row = randi(height - size_block + 1);
    col = randi(width - size_block + 1);
    
    if (ndims(img) == 3)
        I = img(row : row+size_block-1, col : col+size_block-1, :);
    else
        I = img(row : row+size_block-1, col : col+size_block-1);
    end
    
end