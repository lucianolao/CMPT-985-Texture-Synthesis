function [I] = pickBlock(img, current_block, size_overlap, tolerance, n_best, overlap_type, bool_seam_cut, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left)

    [height, width, ~] = size(img);
    size_block = size(current_block, 1);
    
    max_initial_height = height - size_block + 1;
    max_initial_width = width - size_block + 1;
    
    % Previous slow SSD computation
%     for i = 1:1:max_initial_height
%         for j = 1:1:max_initial_width
%             new_block = img(i:i+size_block-1, j:j+size_block-1, :);
%             if bool_transfer
%                 block_transfer = img_transfer(i:i+size_block-1, j:j+size_block-1, :);
%             end
%             [ssd] = computeSSD(current_block, new_block, size_overlap, overlap_type, bool_transfer, block_transfer, alpha);
%             errors_of_all_patches(i,j) = ssd;
%         end
%     end
    
    % Optimized SSD computation (without loops)
    ret = computeSSD(img, current_block, size_overlap, overlap_type, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left);
    errors_of_all_patches = ret(1:max_initial_height, 1:max_initial_width);
    
    % Sample a few blocks with low error
    minimum_error = min(errors_of_all_patches(:));
    minimum_error = max(0, minimum_error);
    [y, x] = find(errors_of_all_patches <= minimum_error * (tolerance));
    
    n_blocks = size(y,1);
    if n_blocks <= n_best
        % Randomly select one of the blocks from the sample
        block_index = randi(n_blocks);
        i = y(block_index);
        j = x(block_index);
    else
        % Randomly select one of the 'n_best' blocks from the sample
        [~,ind] = mink(errors_of_all_patches(:), n_best);
        chosen_ind = ind(randi(numel(ind)));
        [i,j] = ind2sub(size(errors_of_all_patches), chosen_ind);
    end
    
    % Method 2 part is done
    I = img(i:i+size_block-1, j:j+size_block-1, :);
    
    % Minimum Error Boundary Cut for Method 3
    if bool_seam_cut
        I = seamCut(current_block, I, size_overlap, overlap_type);
    end
    
end
