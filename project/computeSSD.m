function [ssd] = computeSSD(current_block, new_block, size_overlap, overlap_type, bool_transfer, block_transfer, alpha)
    
    size_block = size(current_block, 1);
    
    if overlap_type == "left"
        region = (current_block(1:size_block, 1:size_overlap, :) - new_block(1:size_block, 1:size_overlap, :));
        region = region .^ 2;
        ssd = sum(region(:));
        
    elseif overlap_type == "top"
        region = (current_block(1:size_overlap, 1:size_block, :) - new_block(1:size_overlap, 1:size_block, :));
        region = region .^ 2;
        ssd = sum(region(:));
        
    elseif overlap_type == "double"
        left = (current_block(1:size_block, 1:size_overlap, :) - new_block(1:size_block, 1:size_overlap, :));
        left = left .^ 2;
        ssd_left = sum(left(:));
        
        top = (current_block(1:size_overlap, 1+size_overlap:size_block, :) - new_block(1:size_overlap, 1+size_overlap:size_block, :));
        top = top .^ 2;
        ssd_top = sum(top(:));
        
        ssd = ssd_left + ssd_top;
        
    else
        error("MyError: unknown overlap type");
    end
    
    % Avoid repeating blocks by not using SDD = 0
    if ssd == 0
        ssd = inf;
    end
    
    % Extra SSD for Texture Transfer
    if bool_transfer
        region = (block_transfer - new_block) .^ 2;
        correspondence_error = sum(region(:));
        ssd = (alpha) * (ssd) + (1-alpha) * correspondence_error;
    end
    
end
