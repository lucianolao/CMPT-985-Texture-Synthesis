function [I] = getRandomBlock(img, size_block, n_best, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared)

    [height, width, ch] = size(img);
    
    if ~bool_transfer
        row = randi(height - size_block + 1);
        col = randi(width - size_block + 1);

        if (ch == 3)
            I = img(row : row+size_block-1, col : col+size_block-1, :);
        elseif (ch == 1)
            I = img(row : row+size_block-1, col : col+size_block-1);
        else
            error("MyError: unexpected number of channels");
        end
    else
        % Compare brightness of the target image
        current_transfer_brightness_squared = current_transfer_brightness .^ 2;
        current_transfer_brightness_squared_sum = sum(current_transfer_brightness_squared(:));
        
        two_A_B = 2 * conv2(padarray(texture_brightness,size(current_transfer_brightness)-1,'post'), rot90(current_transfer_brightness,2), 'valid');
        
        two_terms = texture_brightness_squared - two_A_B;
        correspondence_error = sum(two_terms,3) + current_transfer_brightness_squared_sum;
        
        % Get rid of right and bottom pixels that cannot fit a whole block
        correspondence_error(end-size_block+2:end, :) = inf;
        correspondence_error(:, end-size_block+2:end) = inf;
        
        % Get minimum error
        [~,ind] = mink(correspondence_error(:), n_best);
        chosen_ind = ind(randi(numel(ind)));
        [i,j] = ind2sub(size(correspondence_error), chosen_ind);
        
        % Get chosen block
        I = img(i:i+size_block-1, j:j+size_block-1, :);
    end
    
end
