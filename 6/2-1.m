fs = 8000;
T = 0.5;
T_half = 0.25;
tau = 0.025;
fD = 587.33;
fE = 659.25;
fFs = 739.99;
fG = 783.99;
t_L = 0:1/fs:T-1/fs;
t_S = 0:1/fs:T_half-1/fs;
t_R = 0:1/fs:tau-1/fs;
rest = zeros(size(t_R));
note = @(freq, time) sin(2*pi*freq*time);

m1 = [note(fD,t_S), rest, note(fD,t_S), rest, note(fG,t_L), rest, note(fFs,t_L), rest, note(fD,t_L), rest];
m2 = [note(fD,t_S), rest, note(fE,t_S), rest, note(fE,t_S), rest,note(fD,t_S), rest, note(fFs,t_S), rest,note(fD,t_S), rest, note(fE,t_L), rest];
m3 = [note(fD,t_L), rest, note(fE,t_L), rest, note(fFs,t_L), rest, note(fE,t_L), rest];
m4 = m2;

m5 = [note(fD,t_L), rest, note(fE,t_S), rest, note(fD,t_S), rest, note(fFs,t_L), rest, note(fE,t_L), rest];
m6 = m5;
m7 = [note(fD,t_S), rest, note(fD,t_S), rest, note(fE, t_L), rest, note(fFs, t_S), rest, note(fE, t_S), rest, note(fFs, t_L), rest];
m8 = [note(fFs,t_S), rest, note(fE,t_S), rest, note(fFs,t_L), rest, note(fFs,t_L), rest, note(fD,t_L), rest];

song = [m1, m2, m3, m4, m5, m6, m7, m8];
sound(song, fs);
audiowrite('my_song.wav', song, fs);