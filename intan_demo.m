clear, close all;
% run and time, shorten to test
% Data paths
data_path = fullfile('./files/');

% Metadata tables
stage_table = readtable('./files/stim_table and stages/baseline.xlsx');
% stim_table = readtable('./files/stim_table and stages/stim_table.xlsx');

% Auxiliary scripts
addpath(genpath('./externals/'));

% Skip excluded recording stages. Reasons for exclusion: recording errors, closed loop software errors, excessive noise, low transfection rate
% if strcmp(stage_table.exclude(ix), 'f')

%full_set = [11, 16, 449, 424, 2117, 2330, 305, 355, 3158, 3159, 3160, 3161, 3162, 3163, 2830, 524, 2855, 2486, 2223, 2902, 26, 25, 39, 56, 280, 330, 374, 399, 356, 474, 499]; % baseline indices in stage table, exclude = 'f'
baseline_set = [2, 3, 4, 20, 27, 6];
for i = 1:length(baseline_set) 
    ix = baseline_set(i)-1;

    % Check type of stage
    % replay_source is empty if type not 'replay'
    % [type, replay_source] = read_stage_type(stage_table, stim_table, ix);

    % Read channel data
    [t, x, fs, ch_labels] = read_data(data_path, stage_table, ix);

    % Read stimulation datakip_channels
    % 'baseline' type stages have no stim info available
    % if ~strcmp(type, 'baseline')
    %     [stim_times, stim_length] = read_stim(data_path, stage_table, stim_table, ix, fs);
    % end

    name = strrep(extractAfter(stage_table.ephys_path{ix},7),'_','-')

    s = stage_table.selected_channel{ix};
    ch_s = str2double(s);

    p = stage_table.phase(ix);
    ch_p = str2double(p{1});
    a = stage_table.amplitude(ix);
    ch_a = str2double(a{1});

    % common_average_reference(x, ix, stage_table);
    % coherence(x, ch_1, ch_2, name);

    % SNR = snr(mean(x))
    % SNR = snr_estimate(x, name)

    % for ch_i = 1:34 % Iterate through channels
        % Figures for mean of all channels
        % x = mean(x(1:32,:)); 
        % plot_activity(t, x, [], name);        
        % plot_PSD(x, fs, [], name);

        % Plot activity and PSDs
        % plot_activity(t, x(ch_i,:), ch_i, name);

        % plot_PSD(x(ch_s,:), fs, ch_s, name);
        % plot_PSD(x(ch_p,:), fs, ch_p, name);
        % plot_PSD(x(ch_a,:), fs, ch_a, name);

        if ix == 1
            plot_PSD(x(ch_a,:), fs, ch_a, name);
        elseif ix == 5
            plot_PSD(x(ch_p,:), fs, ch_p, name);
        elseif ix == 26
            plot_PSD(x(ch_a,:), fs, ch_a, name);
        end

        % % 1. Quantify phase-amplitude coupling by modulation index using Onslow et al PAC library
        % phase_vec = 1:1:30;
        % amp_vec = 1:5:101;
        % 
        % ch = string(ch_p) + ',' + string(ch_a)
        % find_pac_shf(x(ch_a,:), fs, 'mi', x(ch_p,:), phase_vec, amp_vec, 'y', 1, 7, ceil(fs/(diff(phase_vec(1:2)))), 50, 0.05, name, '', '', ch);
        % % find_pac_shf(x(ch_s,:), fs, 'mi', x(ch_s,:), phase_vec, amp_vec, 'y', 1, 7, ceil(fs/(diff(phase_vec(1:2)))), 50, 0.05, name, '', '', string(ch_s));
        % 
        % % 2. Quantify phase-amplitude coupling by mean vector length
        % find_pac_shf(x(ch_a,:), fs, 'mvl', x(ch_p,:), phase_vec, amp_vec, 'y', 1, 7, ceil(fs/(diff(phase_vec(1:2)))), 50, 0.05, name, '', '', ch);
        % % find_pac_shf(x(ch_s,:), fs, 'mvl', x(ch_s,:), phase_vec, amp_vec, 'y', 1, 7, ceil(fs/(diff(phase_vec(1:2)))), 50, 0.05, name, '', '', string(ch_s));
    % end
    % clear t x fs ch_labels;
end

% exit;