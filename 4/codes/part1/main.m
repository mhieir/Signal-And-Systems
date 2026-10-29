close all;
clc;
clear;

%% 1
NumberOfChar = 32;
mapset = cell(2,NumberOfChar);
Alphabet = 'abcdefghijklmnopqrstuvwxyz .,!;"';
for i = 1:NumberOfChar
    mapset{1,i} = Alphabet(i);
    mapset{2,i} = dec2bin(i-1,5);
end

%% 3
Fs = 100;
txt_msg = 'signal';
enc_sig = cell(1,3);
figure
for k=1:3
    enc_sig{k} = coding_amp(txt_msg,k, mapset);
    time_vec = 0:(1/Fs):(length(enc_sig{k})/Fs)-(1/Fs);
    subplot(1,3,k);
    plot(time_vec,enc_sig{k})
end

%% 4
rec_str = cell(1,3);
for k=1:3
    rec_str{k} = decoding_amp(enc_sig{k},k, mapset);
    fprintf("Message number %d with bitrate = %d and the message = %s \n", k, k, rec_str{k});
end

%% 5
g_noise = randn(1,3000);
figure
histogram(g_noise)
mu = mean(g_noise)
sig2 = var(g_noise)

%% 6
amp = 0.01;
sig_w_noise = cell(1,3);
for k=1:3
    curr_noise = amp * randn(1, length(enc_sig{k}));
    sig_w_noise{k} = enc_sig{k} + curr_noise;
    time_vec = 0:(1/Fs):(length(sig_w_noise{k})/Fs)-(1/Fs);
    subplot(1,3,k);
    plot(time_vec,sig_w_noise{k})
    dec_msg = decoding_amp(sig_w_noise{k},k, mapset);
    fprintf("Message number %d with bitrate = %d and the message = %s \n", k, k, dec_msg);
end

%% 7
Amp_Levels = [0.05, 0.5, 5];
figure
for j = 1:3
    curr_amp = Amp_Levels(j);
    fprintf('Standard Deviation = %d\n', curr_amp);
    for k=1:3
        added_noise = curr_amp * randn(1, length(enc_sig{k}));
        sig_w_noise{k} = enc_sig{k} + added_noise;
        time_vec = 0:(1/Fs):(length(sig_w_noise{k})/Fs)-(1/Fs);
        subplot(3,3,3*(j-1) + k);
        plot(time_vec,sig_w_noise{k})
        dec_msg = decoding_amp(sig_w_noise{k},k, mapset);
        fprintf("Message number %d with bitrate = %d and the message = %s \n", k, k, dec_msg);
    end
end

%% 8
Test_Levels = [2, 0.5, 0.3];
figure
for k=1:3
    lim_amp = Test_Levels(k);
    lim_noise = lim_amp * randn(1, length(enc_sig{k}));
    sig_w_noise{k} = enc_sig{k} + lim_noise;
    time_vec = 0:(1/Fs):(length(sig_w_noise{k})/Fs)-(1/Fs);
    subplot(1, 3, k);
    plot(time_vec,sig_w_noise{k})
    dec_msg = decoding_amp(sig_w_noise{k},k, mapset);
    fprintf("Message number %d with bitrate = %d and the message = %s \n", k, k, dec_msg);
end