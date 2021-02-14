function [I] = transfer(img, size_block, size_overlap, tolerance, n_best, transfer_brightness, alpha)
    
    bool_seam_cut = true;
    bool_transfer = true;
    [out_height, out_width, ~] = size(transfer_brightness);
    
    texture_brightness = imgaussfilt(img, 2);
    texture_brightness = rgb2lab(texture_brightness);
    texture_brightness = texture_brightness(:,:,1); % brightness
    texture_brightness = texture_brightness / 100; % range from 0 to 1
    
    transfer_brightness = imgaussfilt(transfer_brightness, 2);
    transfer_brightness = rgb2lab(transfer_brightness);
    transfer_brightness = transfer_brightness(:,:,1); % brightness
    transfer_brightness = transfer_brightness / 100; % range from 0 to 1
    
    I = method_2(img, size_block, size_overlap, out_height, out_width, tolerance, n_best, bool_seam_cut, bool_transfer, texture_brightness, transfer_brightness, alpha);
    
end
