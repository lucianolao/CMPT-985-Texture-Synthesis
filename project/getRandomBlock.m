function [I] = getRandomBlock(img, size_block, bool_transfer, img_transfer)

    [height, width, ~] = size(img);
    
    row = randi(height - size_block + 1);
    col = randi(width - size_block + 1);
    
    if (ndims(img) == 3)
        I = img(row : row+size_block-1, col : col+size_block-1, :);
    elseif (ndims(img) == 1)
        I = img(row : row+size_block-1, col : col+size_block-1);
    else
        error("MyError: unexpected number of channels");
    end
    
end
