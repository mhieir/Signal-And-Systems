rate = 8000;
len_full = 0.5;
len_half = 0.25;
gap = 0.025;
f_C = 523.25; f_B = 493.88; f_A = 440.00; f_G = 392.00; f_F = 349.23;
f_E = 329.63; f_D = 293.66;

t_f = 0:1/rate:len_full-1/rate;
t_h = 0:1/rate:len_half-1/rate;
t_g = 0:1/rate:gap-1/rate;

silence = zeros(size(t_g));
play = @(frq, tm) sin(2*pi*frq*tm);

ph1 = [play(f_C, t_f), silence, play(f_B, t_h), silence, play(f_A, t_h), silence, play(f_G, t_h), silence, play(f_F, t_f), silence];
ph2 = [play(f_G, t_h), silence, play(f_A, t_h), silence, play(f_C, t_f), silence, play(f_B, t_h), silence, play(f_A, t_h), silence, play(f_G, t_h), silence, play(f_F, t_f), silence, play(f_E, t_f)];
final_melody = [ph1, ph2];
sound(final_melody, rate);
audiowrite('moon_song.wav', final_melody, rate);
info = audioinfo('moon_song.wav');
fprintf('Bits per sample: %d\n', info.BitsPerSample);