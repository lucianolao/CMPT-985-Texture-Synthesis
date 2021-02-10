function [ssd] = getSSD(current_block, new_block, size_overlap, overlap_type)
    
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
    
end
