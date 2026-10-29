function msg = decoding(coded_img, Mapset, th)
    coded_img = uint8(coded_img);
    blk_size = 5;
    [rows, cols] = size(coded_img);
    bits = [];
    for r = 1:blk_size:rows-blk_size+1
        for c = 1:blk_size:cols-blk_size+1
            block = coded_img(r:r+blk_size-1, c:c+blk_size-1);
            if std(double(block(:))) > th
                flat = block(:);
                bits = [bits; bitget(flat, 1)];
            end
        end
    end
    n = floor(length(bits)/5);
    if n == 0
        msg = '';
        return;
    end
    bits = bits(1:n*5);
    bits5 = reshape(bits, 5, [])';
    msg = '';
    for i = 1:n
        bin_str = sprintf('%d', bits5(i,:));
        for idx = 1:size(Mapset, 2)
            if strcmp(Mapset{2,idx}, bin_str)
                c = Mapset{1,idx};
                if c == ';'
                    return;
                end
                msg = [msg c];
                break;
            end
        end
    end
end