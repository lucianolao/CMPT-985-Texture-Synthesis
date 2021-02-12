function [I] = getRandomBlock(img, size_block, bool_transfer, img_transfer)

    [height, width, ch] = size(img);
    
    row = randi(height - size_block + 1);
    col = randi(width - size_block + 1);
    
    if (ch == 3)
        I = img(row : row+size_block-1, col : col+size_block-1, :);
    elseif (ch == 1)
        I = img(row : row+size_block-1, col : col+size_block-1);
    else
        error("MyError: unexpected number of channels");
    end
    
end
