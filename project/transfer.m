function [I] = transfer(img, size_block, size_overlap, tolerance, n_best, img_transfer, alpha)
    
    bool_seam_cut = true;
    bool_transfer = true;
    [out_height, out_width, ~] = size(img_transfer);
    
    img_transfer = imgaussfilt(img_transfer, 2);
    
    I = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, bool_seam_cut, bool_transfer, img_transfer, alpha);
    
end
