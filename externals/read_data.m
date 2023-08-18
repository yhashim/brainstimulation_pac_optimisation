%% read_data()

% Inputs: stage_table - path to metadata table (string), ix - index within metadata table to process (int)
% Outputs: t – time (s), x - channel data, 34 x length(t), (uV), fs - sampling rate (Hz), ch_labels - channel names, 1 x 34 cell array
function [t, x, fs, ch_labels] = read_data(data_path, stage_table, ix)
% YH: extract the part of the path we need
path = fullfile(data_path, extractAfter(stage_table.ephys_path{ix},7));

% YH: if path does not exist, return
if exist(path, 'dir') == 0
    disp('Path does not exist');
else
    read_Intan_RHD2000_file_no_dialog(path, 'info.rhd', 'caller');

    fileinfo = dir(fullfile(path, 'time.dat'));
    num_samples = fileinfo.bytes / 4; % int32 = 4 bytes

    num_channels = length(amplifier_channels);
    fid = fopen(fullfile(path, 'amplifier.dat'), 'r');
    x = fread(fid, [num_channels, num_samples], 'int16') * 0.195; % read [uV]
    fclose(fid);

    ch_labels = {amplifier_channels.custom_channel_name};
    fs = frequency_parameters.amplifier_sample_rate;
    t = 0 : 1 / fs : (num_samples - 1) / fs; % sample rate from header file
end
end