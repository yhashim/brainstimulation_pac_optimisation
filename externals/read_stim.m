%% read_stim()

% Inputs: data_path - path to recording data (string), stage_table - path to stage metadata table (string), stim_table - path to table of stimulation patterns (string), table_ix - index within metadata table to process (int), fs - sampling rate (Hz)
% Outputs: stim_times – list of stimulation times, centre of pulse (s), stim_length - length of stimulus (s)
function [stim_times, stim_length] = read_stim(data_path, stage_table, stim_table, ix, fs)
% path = fullfile(data_path, stage_table.ephys_path{ix});
% YH: Change path (remove part we don't have in directory)
path = fullfile(data_path, extractAfter(stage_table.ephys_path{ix},7));

% Stage types
is_baseline = strcmp(stage_table.stim_pattern(ix), 'baseline');
is_replay = strcmp(stage_table.stim_pattern(ix), 'replay');
is_open_loop = startsWith(stage_table.stim_pattern(ix), 'open');

if is_baseline
    stim_times = [];
    stim_length = [];
else
    % %  READ STIMULATION DATA  % %
    if is_replay || is_open_loop
        % Replay and open loop stages always use digitalin.dat
        fileinfo = dir(fullfile(path, 'time.dat'));
        num_samples = fileinfo.bytes / 2; % uint16 = 2 bytes
        fid = fopen(fullfile(path, 'digitalin.dat'), 'r');
        do = fread(fid, [1, num_samples], 'uint16');
        fclose(fid);
        stim = (bitand(do, 2^2) > 0); % Isolates channel 2^ch, where ch=0-15
    else
        try % Some recordings are missing digitalout.dat
            fileinfo = dir(fullfile(path, 'time.dat'));
            num_samples = fileinfo.bytes / 2; % uint16 = 2 bytes
            fid = fopen(fullfile(path, 'digitalout.dat'), 'r');
            do = fread(fid, [1, num_samples], 'uint16');
            fclose(fid);
        catch % Backup is available in digitalin.dat
            fileinfo = dir(fullfile(path, 'time.dat'));
            num_samples = fileinfo.bytes / 2; % uint16 = 2 bytes
            fid = fopen(fullfile(path, 'digitalin.dat'), 'r');
            do = fread(fid, [1, num_samples], 'uint16');
            fclose(fid);
        end
        stim = (bitand(do, 2^14) > 0);
    end

    % % IDENTIFYING STIMULATION PATTERN % %
    if ~is_replay
        stim_pattern = ismember(stim_table.stim_pattern, stage_table.stim_pattern(ix));
    else % Replay stages need to refer to original for stim parameters
        stage_ix = ismember(stage_table.stage, stage_table.replay_source{ix});
        if sum(stage_ix) == 0
            stage_ix = (stage_table.stage == str2double(stage_table.replay_source{ix}));
        end
        tmp = ismember(stage_table.block, stage_table.block(ix)) & stage_ix;
        stim_pattern = ismember(stim_table.stim_pattern, stage_table.stim_pattern(tmp));
    end

    % %  EXTRACTING STIMULATION MIDPOINTS  % %
    stim_length_us = stim_table(stim_pattern, 'stim_length_us'); % [us]
    stim_length = stim_length_us{:,:} * 1e-6;
    n_pulses = table2array(stim_table(stim_pattern, 'n_pulses'));
    shift = round(stim_length * fs / 2); % [samples]

    tlist = []; % Growing list to collect all stim events
    count = 0;
    for k = 1 : length(stim) - 1
        if ~stim(k) && stim(k + 1)
            if ~count
                tlist(end + 1) = k + shift; %#ok<AGROW>
            end
            count = mod(count + 1, n_pulses);
        end
    end
    % The following check is necessary due to the shift
    stim_times = tlist(1, tlist <= num_samples) / fs;
end
end