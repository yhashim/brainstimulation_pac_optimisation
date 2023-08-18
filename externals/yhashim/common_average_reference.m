function x = common_average_reference(x, ix, stage_table)
temp = stage_table.skip_channels(ix);
    ch_list = 1:32;
    if ~isempty(temp{1})
        ch_excl = split(stage_table.skip_channels(ix), ',');
        for j = 1:32
           if ismember(string(j), ch_excl)
               ch_list = ch_list(ch_list~=j);
            end
        end
        % ch_i = ch_list(1);
    else
        % ch_i = 1;
    end

% Need to remove DC offset from amplifier channels
channel_offset = mean(x(ch_list, :), 2);

% Use resample() for analogue signals, it applies anti-aliasing filtering unlike downsample(), which only takes every nth sample
x = resample((x(ch_list, :) - channel_offset)', 1, 1)';
x = x(1:32,:)-mean(x(1:32,:));
end

