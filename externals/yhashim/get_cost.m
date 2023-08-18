function cost = get_cost(x, real_pac, real_psd, weight_pac, weight_psd)
% This function calculates cost for optimization, using PAC and PSDs as features
% Mean squared error is used as the data is continuous numerical and mean squared error is sensitive to outliers
    tau_E, theta_E, tau_I, theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta = deal(x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9), x(10), x(11), x(12), x(13), x(14));

    % Compute model features here
    [aE, aI] = simulate_wc(tau_E, theta_E, tau_I, theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta);
    model_pac = find_pac_shf(x(ch_s,:), fs, 'mi', x(ch_s,:), phase_vec, amp_vec, 'y', 1, 7, ceil(fs/(diff(phase_vec(1:2)))), 0, 0.05, name, '', '', string(ch_s));
    model_psd = plot_PSD(x, fs, [], name);


    % For scaling either use a parameter to deal with it, or z-score and normalize everything first
    % Divide by respective maximums to get to 0-1 scale

    % Calculate mean squared error for PAC values
    % PAC data type is a matrix of PAC values
    diff_pac = real_pac - model_pac;
    squared_diff_pac = diff_pac.^2;
    cost_pac = mean(squared_diff_pac(:));

    % Calculate mean squared error for PSDs
    % PSD data types are single or double and pxx is a PSD estimate, returned as a real-valued nonnegative column vector or matrix
    diff_psd = real_psd - model_psd;
    squared_diff_psd = diff_psd.^2;
    cost_psd = mean(squared_diff_psd(:));

    % Calculate total cost as a weighted sum of PAC and PSD costs
    cost = weight_pac*cost_pac + weight_psd*cost_psd;
end

% lb ub for params based on physiological etc. constraints
% optimFun = @(x) get_cost(x,...)
% for i_opt = 1:n_opt
% x0 = rand within bounds
% call optim (fmincon with optimFun, x0, and bounds)
