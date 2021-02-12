function [I] = method_3(img, size_block, size_overlap, out_height, out_width, tolerance, n_best)
    
    bool_seam_cut = true;
    I = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, bool_seam_cut);
    
end
