function s_output = coding_freq(m_input, r_info)
    c_allowed = ['a':'z', ' ', '.', ',', '!', ';', '"'];
    m_c2b = cell(2, 32);
    for i = 1:32
        m_c2b{1, i} = c_allowed(i);
        m_c2b{2, i} = bitget(i-1, 5:-1:1);
    end
    s_bits_total = [];
    for i = 1:length(m_input)
        idx = find(c_allowed == m_input(i));
        s_bits_total = [s_bits_total m_c2b{2, idx}];
    end
    n_bps = r_info;
    n_symbols = ceil(length(s_bits_total) / n_bps);
    s_bits_padded = [s_bits_total zeros(1, n_symbols * n_bps - length(s_bits_total))];
    M_levels = 2^r_info;
    if r_info == 1
        f_carriers = [12, 37]; % 1 bps: Freqs for 0 and 1 [cite: 80]
    elseif r_info == 2
        f_carriers = [5, 16, 27, 38]; % 2 bps: Freqs for 00, 01, 10, 11 [cite: 104, 118]
    else
        f_carriers = round(linspace(2, 48, M_levels));
    end
    f_sample = 100;
    t_v_symbol = 0:1/f_sample:1-1/f_sample;
    s_output = [];
        for k = 1:n_symbols
        b_current_symbol = s_bits_padded((k-1)*r_info + 1 : k*r_info);
        v_symbol_index = sum(b_current_symbol .* 2.^(r_info-1:-1:0)); 
        f_carrier_symbol = f_carriers(v_symbol_index + 1);
        s_output = [s_output sin(2*pi*f_carrier_symbol*t_v_symbol)];
    end
end