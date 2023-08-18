%% read_stage_type()

% Inputs: stage_table - path to stage metadata table (string), stim_table - path to table of stimulation patterns (string), ix - index within metadata table to process (int)
% Outputs: type – stage type, e.g. baseline, replay, etc. (string), replay_source - if open-loop replay, name of closed-loop stage (string)
function [type, replay_source] = read_stage_type(stage_table, stim_table, ix)
if ~strcmp(stage_table.stim_pattern(ix), 'replay')
    stim_pattern = ismember(stim_table.stim_pattern, stage_table.stim_pattern(ix));
    replay_source = '';
else % Replay trials need to refer to original for stim parameters
    stage_ix = ismember(stage_table.stage, stage_table.replay_source{ix});
    if sum(stage_ix) == 0
        stage_ix = (stage_table.stage == str2double(stage_table.replay_source{ix}));
    end
    tmp = ismember(stage_table.block, stage_table.block(ix)) & stage_ix;
    stim_pattern = ismember(stim_table.stim_pattern, stage_table.stim_pattern(tmp));
    if isnumeric(stage_table.replay_source{ix})
        replay_source = stage_table.replay_source{ix};
    else
        replay_source = sprintf('%06d', stage_table.replay_source{ix});
    end
end
type = char(stim_table.stim_pattern(stim_pattern));
end