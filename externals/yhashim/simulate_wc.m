%% Wilson-Cowan model simulation using Euler-Maruyama method, Author: YH
% Approximate numerical solutions of stochastic differential equations

% Amplitude of noise
zeta = 0.0001;

% Weights of connections
wEE = 2.4;
wEI = 2;
wIE = 2;
wII = 0;

% Time constants
tau_E = 0.0032;
tau_I = 0.0032;

% Gain for sinusoidal response function
beta = 4;

% Initial activity
aE_init = 0;
aI_init = 0;

dt = 1E-4; % dt should be very low magnitude
range_t = 0:dt:1;

% External input 
theta_E = 0.2;
theta_I = 0;

% % Oscillatory external input
% % Baseline value + amplitude * sin(2pi to convert to radians for sin, 5 Hz, generate for array of range_t)
theta_E = 0.25 + 0.05 * sin(2*pi * 4 * range_t); % 4A
%theta_E = 0.375 + 0.375 * sin(2*pi * 4 * range_t); % 4B
%theta_E = 0.6 + 0.05 * sin(2*pi * 4 * range_t); % 4C
%theta_E = 1.25 + 0.25 * sin(2*pi * 4 * range_t); % 4D
%theta_E = 0.75 + 0.75 * sin(2*pi * 4 * range_t); % 4E

% Simulate trajectory
[aE, aI] = simulate(tau_E, theta_E, tau_I, theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta);

% % Visualize
% figure;
% plot(range_t, aE, 'b', 'LineWidth', 2);
% hold on;
% plot(range_t, aI, 'r', 'LineWidth', 2);
% legend('Excitatory population', 'Inhibitory population');
% xlabel('Time', 'FontSize', 11);
% ylabel('Activity', 'FontSize', 11);
% % t = 'Wilson-Cowan Model';
% % title(t);

% Visualize
figure;

% % Top plot: External inputs to the populations
% subplot(2, 1, 1);
% plot(range_t, theta_E * ones(size(range_t)), 'r', 'LineWidth', 2);
% hold on;
% plot(range_t, theta_I * ones(size(range_t)), 'b', 'LineWidth', 2);
% xlabel('Time', 'FontSize', 11);
% ylabel('External Inputs', 'FontSize', 11);
% title('External Inputs to Populations', 'FontSize', 12);
% legend('Input to Excitatory', 'Input to Inhibitory');

% Top plot: External inputs to the populations
subplot(2, 1, 1);
plot(range_t, theta_E, 'r', 'LineWidth', 2);
hold on;
plot(range_t, theta_I * ones(size(range_t)), 'b', 'LineWidth', 2);
xlabel('Time', 'FontSize', 11);
% ylabel('External Inputs', 'FontSize', 11);
title('External Inputs to Populations', 'FontSize', 12, 'FontWeight', 'normal');
% legend('Input to Excitatory', 'Input to Inhibitory');

% Bottom plot: Population activities
subplot(2, 1, 2);
plot(range_t, aE, 'r', 'LineWidth', 2);
hold on;
plot(range_t, aI, 'b', 'LineWidth', 2);
% legend('Excitatory population', 'Inhibitory population');
xlabel('Time', 'FontSize', 11);
% ylabel('Activity', 'FontSize', 11);
title('Population Activities', 'FontSize', 12, 'FontWeight', 'normal');

% Adjust subplots for better layout
% sgtitle('Wilson-Cowan Model Simulation', 'FontSize', 14);

function [aE, aI] = simulate(tau_E, theta_E, tau_I,theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta)
% Function takes model parameters, initial conditions and simulation settings
% Returns simulated activity of populations (aE and aI)

% Initialize activity arrays
Lt = numel(range_t); % Number of time steps in the simulation
aE = [aE_init, zeros(1, Lt-1)];
aI = [aI_init, zeros(1, Lt-1)];

% Simulate the Wilson-Cowan equations using Euler-Maruyama method
% nE and nI are random noise terms
for t = 1:Lt - 1
    % Calculate the derivative of the E population
    nE = zeta*randn()*sqrt(dt);
    %dE = dt/tau_E*(-aE(t)+ F(wEE*aE(t)-wEI*aI(t) + theta_E, beta)) +nE; % If constant theta_E
    dE = dt/tau_E*(-aE(t)+ F(wEE*aE(t)-wEI*aI(t) + theta_E(t), beta)) +nE; % If oscillatory theta_E

    % Calculate the derivative of the I population
    nI = zeta*randn()*sqrt(dt);
    dI = dt/tau_I*(-aI(t)+ F(wIE*aE(t)-wII*aI(t) + theta_I, beta)) +nI; 

    % Update using Euler-Maruyama method
    aE(t+1) = aE(t)+dE;
    aI(t+1) = aI(t)+dI;
end
    
    % Sigmoidal response function
    function y = F(x, beta)
        y = 1./(1+exp(-beta*(x-1)));
    end
end
