%% Populate a matrix with mean vector lengths, Author: YH

% Inputs: t – time (s), x - channel data, 34 x length(t), (uV), ch_i - selected channel
% Outputs: plotted matrix of mean vector length values
function find_pac_mvl_matrix(t, x, fs)
disp('find_pac_mvl_matrix')

freqBands = 1:5:101; % Frequency bands from 1 to 100 with a width of 5
numBands = numel(freqBands);
pac_mvl_matrix = NaN(numBands, numBands);

% BD: check significance, boundaries of the bin, labels middle of bins
signals_cell = cell(2,numBands); % Phase and amplitude signals pre-computed in each frequency band 
for i = 1:numBands
    disp('filtering')
    band = [freqBands(i), freqBands(i)+5];
    center_vect(i) = mean(band);
    
    % BD: filtering
    filtOrder = 3;    
    [filt_b,filt_a] = butter(filtOrder,band/(fs/2));
    xf_filt = filtfilt(filt_b,filt_a,x);

    x_hf = hilbert(xf_filt);
    phaseSignal = angle(x_hf);
    amplitudeSignal = abs(x_hf);

    signals_cell{1,i} = phaseSignal;
    signals_cell{2,i} = amplitudeSignal;
end

for i = 1:numBands % row, amp (y-axis)
    for j = 1:numBands
    % for j = 1:numBands-i % col, phase (x-axis)
         pac_mvl = calculate_pac_mvl(t, signals_cell{1,j}, signals_cell{2,i});
         % pac_mvl_matrix(numBands-i+1,j) = pac_mvl;
         pac_mvl_matrix(i,j) = pac_mvl;
    end
end

% Plot the matrix
figure;
imagesc(center_vect, center_vect, pac_mvl_matrix); % BD: specify corners, check parameters
colorbar;
xlabel('Phase freq (Hz)');
ylabel('Amp freq (Hz)');
set(gca, 'XDir', 'normal');
set(gca, 'YDir', 'normal');
title('PAC MVL matrix');
xticks(1:numBands);
yticks(1:numBands);
xticklabels(freqBands);
yticklabels(freqBands);
end