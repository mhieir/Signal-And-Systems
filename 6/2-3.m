function [note_list, time_list] = extract_notes(song, fs)
    pitches = [523.25, 554.37, 587.33, 622.25, 659.25, 698.46, 739.99, 783.99, 830.61, 880.00, 932.33, 987.77, 0];
    labels = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B', 'Rest'};
    win_len = floor(0.05 * fs);
    note_list = {};
    time_list = [];
    prev_pitch = -1;
    for k = 1:win_len:(length(song) - win_len)
        block = song(k : k + win_len);
        if max(abs(block)) < 0.01
            detected_f = 0;
        else
            L = length(block);
            Y_val = fft(block);
            mag = abs(Y_val(1:floor(L/2)+1));
            f_vec = (0:floor(L/2)) * (fs/L);
            [~, peak_idx] = max(mag);
            detected_f = f_vec(peak_idx);
        end
        [~, best_fit] = min(abs(pitches - detected_f));
        match_f = pitches(best_fit);
        match_name = labels{best_fit};
        if match_f ~= prev_pitch
            note_list{end+1} = match_name;
            time_list(end+1) = win_len/fs;
            prev_pitch = match_f;
        else
            time_list(end) = time_list(end) + win_len/fs;
        end
    end
end

[track, track_fs] = audioread('my_song.wav');
[found_notes, found_times] = extract_notes(track, track_fs);
output_table = table(found_notes', found_times', 'VariableNames', {'Note', 'Seconds'});
disp(output_table);