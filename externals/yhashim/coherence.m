function coherence(x, ch_1, ch_2, name)
% Plot coherence estimate using mscohere for selected channels

n_seg = 16*4;
window = (length(x)/n_seg)*1.5;
mscohere(x(ch_1,:),x(ch_2,:), window, [], [], fs);
xlim([0 0.3]);
title(sprintf('Coherence Estimate via Welch, Channels: %d, %d' ,ch_1, ch_2));
subtitle(name);
end

