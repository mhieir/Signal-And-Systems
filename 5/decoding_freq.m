function m_decoded_output = decoding_freq(s_input, r_info)
    c_allowed = ['a':'z', ' ', '.', ',', '!', ';', '"'];
    m_c2b = cell(2, 32);
    for i = 1:32
        m_c2b{1, i} = c_allowed(i);
        m_c2b{2, i} = bitget(i-1, 5:-1:1);
    end
    M_levels = 2^r_info;
    if r_info == 1
        f_carriers_target = [12, 37];
    elseif r_info == 2
        f_carriers_target = [5, 16, 27, 38];
    else
        f_carriers_target = round(linspace(2, 48, M_levels));
    end
    f_sample = 100;
    n_samples_symbol = f_sample; 
    n_symbols = length(s_input) / n_samples_symbol;
    s_bits_received = [];
    a_freq = (-f_sample/2 : f_sample/n_samples_symbol : f_sample/2 - f_sample/n_samples_symbol);
    for k = 1:n_symbols
        s_current_segment = s_input((k-1)*n_samples_symbol + 1 : k*n_samples_symbol);
        Y_fft_segment = fftshift(fft(s_current_segment));
        [~, i_max] = max(abs(Y_fft_segment));
        f_detected = abs(a_freq(i_max));
        [~, i_symbol] = min(abs(f_carriers_target - f_detected));
        v_symbol = i_symbol - 1;
        s_bits_received = [s_bits_received bitget(v_symbol, r_info:-1:1)];
    end
    m_decoded_output = '';
    n_bpc = 5;
    for i = 1:n_bpc:length(s_bits_received)
        if i + n_bpc - 1 <= length(s_bits_received)
            b_char = s_bits_received(i : i + n_bpc - 1);
            for j = 1:32
                if isequal(b_char, m_c2b{2, j})
                    m_decoded_output = [m_decoded_output m_c2b{1, j}];
                    break;
                end
            end
        end
    end
end