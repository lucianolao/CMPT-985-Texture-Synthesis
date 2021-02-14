function [ssd] = computeSSD(img, current_block, size_overlap, overlap_type, bool_transfer, texture_brightness, current_transfer_brightness, texture_brightness_squared, alpha, img_squared_left, img_squared_top, img_squared_top_minus_left)
    
    [height, width, ch] = size(img);
    size_block = size(current_block, 1);
    
    ssd_left = 0;
    ssd_top = 0;
    
    if overlap_type == "left" || overlap_type == "double"
        % left = (current_block(1:size_block, 1:size_overlap, :) - new_block(1:size_block, 1:size_overlap, :));
        % left = left .^ 2;
        % ssd = sum(left(:));
        
        overlap_left = current_block(1:size_block, 1:size_overlap, :);
        overlap_left_squared = overlap_left .^ 2;
        overlap_left_squared_sum = sum(overlap_left_squared(:));
        
        if ch == 1
            two_A_B = 2 * conv2(padarray(img,size(overlap_left)-1,'post'), rot90(overlap_left,2), 'valid');
        elseif ch == 3
            [h,w,~] = size(overlap_left);
            two_A_B_red = 2 * conv2(padarray(img(:,:,1),[h-1 w-1],'post'), rot90(overlap_left(:,:,1),2), 'valid');
            two_A_B_green = 2 * conv2(padarray(img(:,:,2),[h-1 w-1],'post'), rot90(overlap_left(:,:,2),2), 'valid');
            two_A_B_blue = 2 * conv2(padarray(img(:,:,3),[h-1 w-1],'post'), rot90(overlap_left(:,:,3),2), 'valid');
            two_A_B = zeros(height, width, ch);
            two_A_B(:,:,1) = two_A_B_red;
            two_A_B(:,:,2) = two_A_B_green;
            two_A_B(:,:,3) = two_A_B_blue;
        else
            error("MyError: unexpected number of channels");
        end
        
        two_terms = img_squared_left - two_A_B;
        ssd_left = sum(two_terms,3) + overlap_left_squared_sum;
    
    elseif overlap_type == "top"
        % top = (current_block(1:size_overlap, 1:size_block, :) - new_block(1:size_overlap, 1:size_block, :));
        % top = top .^ 2;
        % ssd = sum(top(:));
        
        overlap_top = current_block(1:size_overlap, 1:size_block, :);
        overlap_top_squared = overlap_top .^ 2;
        overlap_top_squared_sum = sum(overlap_top_squared(:));
        
        if ch == 1
            two_A_B = 2 * conv2(padarray(img,size(overlap_top)-1,'post'), rot90(overlap_top,2), 'valid');
        elseif ch == 3
            [h,w,~] = size(overlap_top);
            two_A_B_red = 2 * conv2(padarray(img(:,:,1),[h-1 w-1],'post'), rot90(overlap_top(:,:,1),2), 'valid');
            two_A_B_green = 2 * conv2(padarray(img(:,:,2),[h-1 w-1],'post'), rot90(overlap_top(:,:,2),2), 'valid');
            two_A_B_blue = 2 * conv2(padarray(img(:,:,3),[h-1 w-1],'post'), rot90(overlap_top(:,:,3),2), 'valid');
            two_A_B = zeros(height, width, ch);
            two_A_B(:,:,1) = two_A_B_red;
            two_A_B(:,:,2) = two_A_B_green;
            two_A_B(:,:,3) = two_A_B_blue;
        else
            error("MyError: unexpected number of channels");
        end
        
        two_terms = img_squared_top - two_A_B;
        ssd_top = sum(two_terms,3) + overlap_top_squared_sum;
        
    else
        error("MyError: unknown overlap type");
    end
    
    if overlap_type == "double" % do second overlap (top - left)
        % left = (current_block(1:size_block, 1:size_overlap, :) - new_block(1:size_block, 1:size_overlap, :));
        % left = left .^ 2;
        % ssd_left = sum(left(:));
        
        % top = (current_block(1:size_overlap, 1+size_overlap:size_block, :) - new_block(1:size_overlap, 1+size_overlap:size_block, :));
        % top = top .^ 2;
        % ssd_top = sum(top(:));
        
        % ssd = ssd_left + ssd_top;
        
        overlap_top_minus_left = current_block(1:size_overlap, 1+size_overlap:size_block, :);
        overlap_top_minus_left_squared = overlap_top_minus_left .^ 2;
        overlap_top_minus_left_squared_sum = sum(overlap_top_minus_left_squared(:));
        
        if ch == 1
            two_A_B = 2 * conv2(padarray(img,size(overlap_top_minus_left)-1,'post'), rot90(overlap_top_minus_left,2), 'valid');
        elseif ch == 3
            [h,w,~] = size(overlap_top_minus_left);
            two_A_B_red = 2 * conv2(padarray(img(:,:,1),[h-1 w-1],'post'), rot90(overlap_top_minus_left(:,:,1),2), 'valid');
            two_A_B_green = 2 * conv2(padarray(img(:,:,2),[h-1 w-1],'post'), rot90(overlap_top_minus_left(:,:,2),2), 'valid');
            two_A_B_blue = 2 * conv2(padarray(img(:,:,3),[h-1 w-1],'post'), rot90(overlap_top_minus_left(:,:,3),2), 'valid');
            two_A_B = zeros(height, width, ch);
            two_A_B(:,:,1) = two_A_B_red;
            two_A_B(:,:,2) = two_A_B_green;
            two_A_B(:,:,3) = two_A_B_blue;
        else
            error("MyError: unexpected number of channels");
        end
        
        % First two terms of the expanded binomial product (A-B).^2
        two_terms = img_squared_top_minus_left - two_A_B;
        
        % shift the results to the left, since we skipped the first columns of the block
        two_terms = two_terms(:, 1+size_overlap:end, :);
        two_terms = padarray(two_terms, [0 size_overlap], inf, 'post');
        
        % Adding the third term of the expanded binomial product
        ssd_top = sum(two_terms,3) + overlap_top_minus_left_squared_sum;
        
    end
    
    % Combined SSD
    ssd = ssd_left + ssd_top;
    
    % Avoid repeating blocks by not using SDD = 0
    ssd(ssd<=0) = inf;
    
    % Extra SSD for Texture Transfer
    if bool_transfer
        % region = (block_transfer - new_block) .^ 2;
        % correspondence_error = sum(region(:));
        % ssd = (alpha) * (ssd) + (1-alpha) * correspondence_error;
        
        % texture_brightness, current_transfer_brightness
        % texture_brightness_squared
        
        current_transfer_brightness_squared = current_transfer_brightness .^ 2;
        current_transfer_brightness_squared_sum = sum(current_transfer_brightness_squared(:));
        
        two_A_B = 2 * conv2(padarray(texture_brightness,size(current_transfer_brightness)-1,'post'), rot90(current_transfer_brightness,2), 'valid');
        
        two_terms = texture_brightness_squared - two_A_B;
        correspondence_error = sum(two_terms,3) + current_transfer_brightness_squared_sum;
        
        ssd = (alpha) * (ssd) + (1-alpha) * correspondence_error;
    end
    
end
