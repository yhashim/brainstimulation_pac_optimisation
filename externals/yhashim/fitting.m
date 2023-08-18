%% Fitting and optimization, Author: YH
% Determine the parameters (weights such as wEI and wIE) such that features (PSDdata, PACdata and PSDmodel, PACmodel) are very close

function fitting()
if isdeployed
    % str2double params     tau_E, theta_E, tau_I, theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta 
end

% set random seeds
% set matrix with bounds
% save hyperprarams to optimFile
% 
% options
% 
% 
% x = fmincon(@simulate_wc, x0)
% 
% 
% if isdeployed?
% exit;
end