function decoded_message = decoding_amp(coded_sig,bit_rate, mapset)
    fs = 100;
    decoded_message = [];
    bin_message = [];
    thresholds=[];
    for k=1:(2^bit_rate)-1
        thresholds(k) = ((2*k)-1)/(2*((2^bit_rate)-1));
    end
    t = 0:(1/fs):1-(1/fs);
    ref = 2*sin(2*pi*t);
    for j=0:(length(coded_sig)/fs)-1
        to_check = coded_sig((j*fs)+1:((j+1)*fs));
        corr = 0.01*sum(to_check.*ref);
        initial_corr = thresholds(1);
        for t=1:length(thresholds)
            if corr<=thresholds(t)
                corr = ((initial_corr*2*((2^bit_rate)-1))-t)/((2^bit_rate)-1);
                break;
            elseif t==length(thresholds)
                corr = 1;
            else
                initial_corr = thresholds(t+1);
            end
        end
        bin_message = [bin_message dec2bin(round(corr*((2^bit_rate)-1)),bit_rate)];
    end
    for p = 1:5:length(bin_message)-4
        message_to_check = bin_message(p:p+4);
        message_to_check = mapset{1,bin2dec(message_to_check)+1};
        decoded_message = [decoded_message message_to_check];
    end
end