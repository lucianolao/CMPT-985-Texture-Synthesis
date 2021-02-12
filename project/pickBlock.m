function [I] = pickBlock(img, current_block, size_overlap, tolerance, n_best, overlap_type, bool_seam_cut, bool_transfer, img_transfer, alpha)

    [height, width, ~] = size(img);
    size_block = size(current_block, 1);
    
    max_initial_height = height - size_block + 1;
    max_initial_width = width - size_block + 1;
    
    errors_of_all_patches = zeros(max_initial_height, max_initial_width);
    block_transfer = 0;
    
    % Compute all errors
    for i = 1:1:max_initial_height
        for j = 1:1:max_initial_width
            new_block = img(i:i+size_block-1, j:j+size_block-1, :);
            if bool_transfer
                block_transfer = img_transfer(i:i+size_block-1, j:j+size_block-1, :);
            end
            [ssd] = computeSSD(current_block, new_block, size_overlap, overlap_type, bool_transfer, block_transfer, alpha);
            errors_of_all_patches(i,j) = ssd;
        end
    end
    
    % Sample a few blocks with low error
    minimum_error = min(errors_of_all_patches(:));
    [y, x] = find(errors_of_all_patches <= minimum_error * (tolerance));
    
    % If we sampled more than 'n_best', decrease tolerance and sample again
    n_blocks = size(y,1);
    while n_blocks > n_best
        tolerance = (tolerance-1) / 2 + 1;
        [y, x] = find(errors_of_all_patches <= minimum_error * (tolerance));
        n_blocks = size(y,1);
    end
    
    % Randomly select one of the blocks from the sample
    block_index = randi(n_blocks);
    i = y(block_index);
    j = x(block_index);
    
    % Method 2 part is done
    I = img(i:i+size_block-1, j:j+size_block-1, :);
    
    % Minimum Error Boundary Cut for Method 3
    if bool_seam_cut
        I = seamCut(current_block, I, size_overlap, overlap_type);
    end
    
end
