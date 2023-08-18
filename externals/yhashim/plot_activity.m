%% Plot activity of a given channel over time, Author: YH

% Inputs: t – time (s), x - channel data at selected channel (uV), name - extracted from path (string)
% Saves plot of activity under path and name
function plot_activity(t, x, ch_i, name)
figure;
plot(t, x);

title('Channel Average');
% title(sprintf('Channel %d', ch_i));
subtitle(name);

xlabel('Time (s)');
ylabel('Voltage (uV)');

% % Save the figure
% save_path = fullfile('figures', name, 'activity');
% if ~isfolder(save_path)
%     mkdir(save_path);
% end
% saveas(gcf, fullfile(save_path, sprintf('%s.svg', 'plot'+string(ch_i))));
close(gcf);
end