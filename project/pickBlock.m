function [I] = pickBlock(img, current_block, size_overlap, tolerance, n_best, overlap_type)

    [height, width, ~] = size(img);
    size_block = size(current_block, 1);
    
    max_initial_height = height - size_block + 1;
    max_initial_width = width - size_block + 1;
    
    errors_of_all_patches = zeros(max_initial_height, max_initial_width);
    
    % Compute all errors
    for i = 1:1:max_initial_height
        for j = 1:1:max_initial_width
            new_block = img(i:i+size_block-1, j:j+size_block-1, :);
            ssd = getSSD(current_block, new_block, size_overlap, overlap_type);
            if ssd == 0
                ssd = Inf;
            end
            errors_of_all_patches(i,j) = ssd;
        end
    end
    
    % Sample a few blocks with low error
    minimum_error = min(errors_of_all_patches(:));
    [y, x] = find(errors_of_all_patches <= minimum_error * (tolerance));
    
    % If we sampled more than n_best, decrease tolerance and sample again
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
    
    I = img(i:i+size_block-1, j:j+size_block-1, :);
    
end