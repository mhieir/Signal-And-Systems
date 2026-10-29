function coded_img = coding(msg, Mapset, img, th)
    msg = [msg ';'];
    bin_msg = '';
    for k = 1:length(msg)
        found = false;
        for idx = 1:size(Mapset, 2)
            if Mapset{1,idx} == msg(k)
                bin_msg = [bin_msg Mapset{2,idx}];
                found = true;
                break;
            end
        end
        if ~found
            error('Character "%c" not found in Mapset.', msg(k));
        end
    end
    if length(bin_msg) > numel(img)
        error('Message too long for selected image.');
    end
    coded_img = uint8(img);
    [rows, cols] = size(img);
    blk_size = 5;
    bit_idx = 1;
    bin_msg_num = bin_msg - '0';
    for r = 1:blk_size:rows-blk_size+1
        for c = 1:blk_size:cols-blk_size+1
            block = img(r:r+blk_size-1, c:c+blk_size-1);
            if std(double(block(:))) > th
                flat = block(:);
                for k = 1:length(flat)
                    if bit_idx > length(bin_msg_num)
                        break;
                    end
                    flat(k) = bitset(flat(k), 1, bin_msg_num(bit_idx));
                    bit_idx = bit_idx + 1;
                end
                coded_img(r:r+blk_size-1, c:c+blk_size-1) = reshape(flat, blk_size, blk_size);
            end
            if bit_idx > length(bin_msg_num)
                break;
            end
        end
        if bit_idx > length(bin_msg_num)
            break;
        end
    end
    if bit_idx <= length(bin_msg_num)
        error('Not enough textured blocks to hide entire message.');
    end
end
