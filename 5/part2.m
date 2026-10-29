% Part 1: Mapset Creation (Character to Bit Mapping)
c_allowed = ['a':'z', ' ', '.', ',', '!', ';', '"'];
m_c2b = cell(2, 32);
for i = 1:32
    m_c2b{1, i} = c_allowed(i);
    m_c2b{2, i} = bitget(i-1, 5:-1:1);
end
% Part 3: Encoding and Signal Plotting (Rate 1 bps and Rate 5 bps)
m_send = 'signal';
s_encoded_r1 = coding_freq(m_send, 1);
s_encoded_r5 = coding_freq(m_send, 5);
figure;
subplot(2,1,1);
plot(s_encoded_r1, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980]);
title('Encoded Signal: Message "signal" (Rate = 1 bps)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Samples', 'FontSize', 10);
ylabel('Amplitude', 'FontSize', 10);
grid on;
set(gca, 'GridLineStyle', ':');
subplot(2,1,2);
plot(s_encoded_r5, 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
title('Encoded Signal: Message "signal" (Rate = 5 bps)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Samples', 'FontSize', 10);
ylabel('Amplitude', 'FontSize', 10);
grid on;
set(gca, 'GridLineStyle', ':');
% Part 4: Decoding Clean Signals (Validation)
m_decoded_r1 = decoding_freq(s_encoded_r1, 1);
m_decoded_r5 = decoding_freq(s_encoded_r5, 5);
fprintf('\n Clean Decoding\n');
fprintf('Original: %s\n', m_send);
fprintf('Rate 1 Decoded: %s\n', m_decoded_r1);
fprintf('Rate 5 Decoded: %s\n', m_decoded_r5);
fprintf('\n');
% Part 5: Encoding with Noise (Variance = 0.1) and Decoding
m_send = 'signal';
v_noise = 0.0001;
s_encoded_r1 = coding_freq(m_send, 1);
n_r1 = sqrt(v_noise) * randn(size(s_encoded_r1));
s_received_r1 = s_encoded_r1 + n_r1;
o_decoded_r1 = decoding_freq(s_received_r1, 1);
s_encoded_r5 = coding_freq(m_send, 5);
n_r5 = sqrt(v_noise) * randn(size(s_encoded_r5));
s_received_r5 = s_encoded_r5 + n_r5;
o_decoded_r5 = decoding_freq(s_received_r5, 5);
fprintf('\n Decoding with Noise (Var=%.4f)\n', v_noise);
fprintf('Original: %s\n', m_send);
fprintf('Rate 1 Decoded: %s\n', o_decoded_r1);
fprintf('Rate 5 Decoded: %s\n', o_decoded_r5);
fprintf('\n');
% Part 6: Noise Resistance Test (Varying Variances)
m_send = 'signal';
v_noise_test = 0.1:0.1:4;
fprintf('TEST: Noise Resistance\n');
fprintf('Signal: "%s"\n', m_send);
fprintf(' Var 1 bps Output OK 5 bps Output OK\n');
for v_curr = v_noise_test
    s_r1_clean = coding_freq(m_send, 1);
    s_r1_noisy = s_r1_clean + sqrt(v_curr) * randn(size(s_r1_clean));
    m_decoded_r1_test = decoding_freq(s_r1_noisy, 1);
    m_match_r1 = strcmp(m_decoded_r1_test, m_send);
    s_r5_clean = coding_freq(m_send, 5);
    s_r5_noisy = s_r5_clean + sqrt(v_curr) * randn(size(s_r5_clean));
    m_decoded_r5_test = decoding_freq(s_r5_noisy, 5);
    m_match_r5 = strcmp(m_decoded_r5_test, m_send);
    match_output_r1 = m_match_r1 * 2 + 1;
    match_output_r5 = m_match_r5 * 2 + 1;
    fprintf(' %.4f %s %d %s %d\n', ...
            v_curr, m_decoded_r1_test, match_output_r1, m_decoded_r5_test, match_output_r5);
end
fprintf('\n');