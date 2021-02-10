function [I] = seamCut(current_block, new_block, size_overlap, overlap_type)
    
    size_block = size(current_block, 1);
    
    % Vertical seam
    if overlap_type == "left" || overlap_type == "double"
        E_v = (current_block(1:size_block, 1:size_overlap, :) - new_block(1:size_block, 1:size_overlap, :));
        E_v = E_v .^ 2;
        E_v = sum(E_v, 3);
        M_v = zeros(size(E_v));
        M_v(1,:) = E_v(1,:);
        height_v = size(M_v,1);
        width_v = size(M_v,2);
        % Compute energy vertically
        for i = 2:height_v
            for j = 1:width_v
                if j == 1
                    M_v(i,j) = E_v(i,j) + min(M_v(i-1, j:j+1));
                elseif j == width_v
                    M_v(i,j) = E_v(i,j) + min(M_v(i-1, j-1:j));
                else
                    M_v(i,j) = E_v(i,j) + min(M_v(i-1, j-1:j+1));
                end
            end
        end
        
        % Find vertical path
        seam_v = zeros(size_block, 1);
        [~, j] = min(M_v(size_block, :));
        seam_v(size_block) = j;
        for i = size_block-1 : -1 : 1
            if j == 1
                [~, x] = min(M_v(i, j:j+1));
                j = j + x - 1;
            elseif j == width_v
                [~, x] = min(M_v(i, j-1:j));
                j = j + x - 2;
            else
                [~, x] = min(M_v(i, j-1:j+1));
                j = j + x - 2;
            end
            seam_v(i) = j;
        end
        
    end
    
    % Horizontal seam
    if overlap_type == "top" || overlap_type == "double"
        E_h = (current_block(1:size_overlap, 1:size_block, :) - new_block(1:size_overlap, 1:size_block, :));
        E_h = E_h .^ 2;
        E_h = sum(E_h, 3);
        M_h = zeros(size(E_h));
        M_h(:,1) = E_h(:,1);
        height_h = size(M_h,1);
        width_h = size(M_h,2);
        % Compute energy horizontally
        for j = 2:width_h
            for i = 1:height_h
                if i == 1
                    M_h(i,j) = E_h(i,j) + min(M_h(i:i+1, j-1));
                elseif i == height_h
                    M_h(i,j) = E_h(i,j) + min(M_h(i-1:i, j-1));
                else
                    M_h(i,j) = E_h(i,j) + min(M_h(i-1:i+1, j-1));
                end
            end
        end
        
        % Find horizontal path
        seam_h = zeros(size_block, 1);
        [~, i] = min(M_h(:, size_block));
        seam_h(size_block) = i;
        for j = size_block-1 : -1 : 1
            if i == 1
                [~, y] = min(M_h(i:i+1, j));
                i = i + y - 1;
            elseif i == height_h
                [~, y] = min(M_h(i-1:i, j));
                i = i + y - 2;
            else
                [~, y] = min(M_h(i-1:i+1, j));
                i = i + y - 2;
            end
            seam_h(j) = i;
        end
        
    end
    
    % Make the cut (replace some parts of the new block by the old one)
    if overlap_type == "left" || overlap_type == "double"
        % Vertical cut
        for i = 1:size_block
            for j = 1:size_overlap
                if j == seam_v(i)
                    break;
                end
                new_block(i,j,:) = current_block(i,j,:);
            end
        end
    end
        
    if overlap_type == "top" || overlap_type == "double"
        % Horizontal cut
        for j = 1:size_block
            for i = 1:size_overlap
                if i == seam_h(j)
                    break;
                end
                new_block(i,j,:) = current_block(i,j,:);
            end
        end
    end
    
    I = new_block;
    
end
