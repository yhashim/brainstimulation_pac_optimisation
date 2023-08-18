%% Calculate mean vector length, Author: YH
% Introduced by Canolty et al to quantify phase-amplitude coupling

function pac_mvl = calculate_pac_mvl(t, phaseSignal, amplitudeSignal)
disp('pac_mvl');

n = length(t);
sum_val = 0;

% Calculate the sum of complex vectors to obtain mean vector length
for i = 1:n
    amplitude = amplitudeSignal(i);
    theta = phaseSignal(i); % Phase-angle
    sum_val = sum_val + amplitude*exp(1i*theta);
end

% Calculate the mean vector length of phase-amplitude coupling
pac_mvl = abs(sum_val/n);
end