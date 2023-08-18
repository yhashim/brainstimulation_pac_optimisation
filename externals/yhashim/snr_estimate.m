function SNR = snr_estimate(x, name)
% This function computes the estimate of signal to noise ratio over time and frequency
x = mean(x(1:32,:));
SNR = mean(x)/std(x);
end

