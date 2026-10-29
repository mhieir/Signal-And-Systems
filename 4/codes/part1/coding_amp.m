function encoded_wave = coding_amp(input_str, R, char_map)
    Fs = 100;
    encoded_wave = [];
    MapSize = 32;
    L = strlength(input_str);
    temp_bins = cell(1, L);
    for i = 1:L
        this_char = input_str(i);
        for j = 1:MapSize
            if this_char == char_map{1,j}
                temp_bins{i} = char_map{2,j};
            end
        end
    end
    bit_stream = cell2mat(temp_bins);
    total_bits = length(bit_stream);
    for idx = 1:R:total_bits
        if idx + R - 1 > total_bits
            break;
        end
        current_bits = bit_stream(idx : idx + R - 1);
        dec_val = bin2dec(current_bits);
        amp_coeff = dec_val / ((2^R) - 1);
        t_start = idx / R;
        time_vec = t_start : (1/Fs) : t_start + 1 - (1/Fs);
        wave_chunk = amp_coeff * sin(2 * pi * (time_vec - t_start));
        encoded_wave = [encoded_wave wave_chunk];
    end
end