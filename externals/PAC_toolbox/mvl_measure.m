function mvlval = mvl_measure(phase_sig, amp_sig)
% Calculate mean vector length, Author: YH
% Introduced by Canolty et al to quantify phase-amplitude coupling

n = size(phase_sig, 1);
sum_val = 0;

% amp_sig = abs(amp_sig);
% phase_sig = angle(phase_sig);

% Calculate the sum of complex vectors to obtain mean vector length
for i = 1:n
    amplitude = amp_sig(i);
    theta = phase_sig(i); % Phase-angle
    sum_val = sum_val + amplitude*exp(1i*theta);
end

% Calculate the mean vector length of phase-amplitude coupling
mvlval = abs(sum_val/n);
end
