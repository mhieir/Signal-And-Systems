clc; clear; close all;

f_base = 5;
s_rate = 100;
span = 1;
ticks = 0:1/s_rate:span-1/s_rate;
c_vel = 3e8;

dist_val = 250e3;
v_val_kmh = 180;
v_val_ms = v_val_kmh / 3.6;
att_fact = 0.5;
dop_sens = 0.3;

f_dop = dop_sens * v_val_ms;
t_delay = 2 * dist_val / c_vel;

sig_tx = cos(2*pi*f_base*ticks);

figure;
subplot(2,1,1);
plot(ticks, sig_tx, 'LineWidth', 1.5);
title('Transmitted Signal x(t)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

sig_rx = att_fact * cos(2*pi*(f_base + f_dop)*(ticks - t_delay));

subplot(2,1,2);
plot(ticks, sig_rx, 'r', 'LineWidth', 1.5);
title('Received Signal y(t)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on;

len_sig = length(sig_rx);
spec_rx = fftshift(fft(sig_rx));
freq_bins = (-len_sig/2 : len_sig/2 - 1) * (s_rate/len_sig);

[~, peak_pos] = max(abs(spec_rx));
f_found = freq_bins(peak_pos);

if f_found < 0
    f_found = -f_found;
    phase_val = -angle(spec_rx(peak_pos));
else
    phase_val = angle(spec_rx(peak_pos));
end

f_dop_est = f_found - f_base;
v_est_val = f_dop_est / dop_sens * 3.6;
t_delay_est = -phase_val / (2*pi*f_found);

while t_delay_est < 0
    t_delay_est = t_delay_est + 1/f_found;
end

dist_est_val = (c_vel * t_delay_est) / 2 / 1000;

fprintf('Estimated Speed: %.2f Km/h (Actual: %.2f)\n', v_est_val, v_val_kmh);
fprintf('Estimated Distance: %.2f Km (Actual: %.2f)\n', dist_est_val, dist_val/1000);
levels = 0:0.5:15;
fprintf('\nNoise Amp | Est Speed (Km/h) | Est Dist (Km) | Status\n');
fprintf('-----------------------------------------------------------\n');
for n_amp = levels
    interference = n_amp * (rand(size(sig_rx)) - 0.5);
    sig_dirty = sig_rx + interference;
    n_pts = length(sig_dirty);
    n_spec = fftshift(fft(sig_dirty));
    n_freqs = (-n_pts/2 : n_pts/2 - 1) * (s_rate/n_pts);
    [~, n_peak_idx] = max(abs(n_spec));
    n_f_peak = n_freqs(n_peak_idx);
    if n_f_peak < 0
        n_f_peak = -n_f_peak;
        n_phase = -angle(n_spec(n_peak_idx));
    else
        n_phase = angle(n_spec(n_peak_idx));
    end
    n_dop_est = n_f_peak - f_base;
    n_v_est = n_dop_est / dop_sens * 3.6;
    n_t_est = -n_phase / (2*pi*n_f_peak);
    while n_t_est < 0
        n_t_est = n_t_est + 1/n_f_peak;
    end
    n_dist_est = (c_vel * n_t_est) / 2 / 1000;
    if abs(n_v_est - v_val_kmh) > (0.05 * v_val_kmh)
        state = '!!! SPEED FAILED !!!';
    elseif abs(n_dist_est - dist_val/1000) > (0.05 * dist_val/1000)
        state = 'DIST WRONG';
    else
        state = 'OK';
    end
    fprintf('%9.1f | %16.2f | %13.2f | %s\n', n_amp, n_v_est, n_dist_est, state);
end

range1 = 250e3; v1_raw = 180/3.6; g1 = 0.5;
range2 = 200e3; v2_raw = 216/3.6; g2 = 0.6;
dop1 = dop_sens * v1_raw; dly1 = 2 * range1 / c_vel;
dop2 = dop_sens * v2_raw; dly2 = 2 * range2 / c_vel;
part1 = g1 * cos(2*pi*(f_base + dop1)*(ticks - dly1));
part2 = g2 * cos(2*pi*(f_base + dop2)*(ticks - dly2));
total_sig = part1 + part2;
figure;
plot(ticks, total_sig);
title('Received Signal from Two Objects');
xlabel('Time (s)'); grid on;
total_spec = fftshift(fft(total_sig));
total_mag = abs(total_spec);
limit = max(total_mag) * 0.5;
[~, loc_points] = findpeaks(total_mag, 'MinPeakHeight', limit);
valid_locs = loc_points(freq_bins(loc_points) > 0);
found_freqs = freq_bins(valid_locs);
found_phases = angle(total_spec(valid_locs));
for m = 1:length(found_freqs)
    curr_f = found_freqs(m);
    curr_phi = found_phases(m);
    curr_v = (curr_f - f_base) / dop_sens * 3.6;
    curr_t = -curr_phi / (2*pi*curr_f);
    while curr_t < 0
        curr_t = curr_t + 1/curr_f;
    end
    curr_r = (c_vel * curr_t) / 2 / 1000;
    fprintf('Object %d detected: V = %.2f Km/h, R = %.2f Km\n', m, curr_v, curr_r);
end