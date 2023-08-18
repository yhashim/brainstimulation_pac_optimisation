function out = isPSDok (x,dt,n,f_target,df,verbose,thres)

%%%% CODE TO ADAPT %%%%

%w_EE = x(1);
%w_EI = x(2);
%w_IE = x(3);
%theta_I = x(4);
%theta_E = x(5);
%beta = x(6);
%tau = x(7);

tau_E, theta_E, tau_I, theta_I, wEE, wEI, wIE, wII, aE_init, aI_init, dt, range_t, beta, zeta = deal(x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9), x(10), x(11), x(12), x(13), x(14)); % YH

rE_init
rI_init

%%% simulate model
% [t0,y] = ode113(@(t,y) odefun_1WC_FourierStim(t,y,w_EE,w_EI,w_IE,theta_I,theta_E,beta,tau,Omega_s,c1,c2), tspan, y0);
aE = simulate_WC(tau_E, theta_E, tau_I,theta_I, wEE, wEI, wIE, wII, rE_init, rI_init, dt, range_t, beta, zeta)); % YH, t is current time, y is vector of state variables changing in ODE 

toRm = 1:round(length(aE)*0.3); % removes first 30%
t(toRm) = [];
aE(toRm) = [];
aE_c = aE - mean(aE);

% PSD
% try
[pxx,f] = pwelch(aE_c,[],[],[],1/dt);

% check if whithin tolerances
inds = (f > f_target - df) & (f < f_target + df);
[maxMod,iMod] = max(pxx(inds));
out = maxMod > thres;

% plot if verbose and successful
if verbose && out
    figure
    hold on
    plot(f,pxx,'linewidth',1,'displayName','model')
    freqs = f(inds);
    scatter(freqs(iMod),maxMod,'displayName','model')
    ylabel('PSD')
    xlabel('frequency (Hz)')
    legend('location','best')
    xlim([0 f_target + 3*df])
    ylim([0 2*maxMod])
    
    figure
    plot(aE_c)
%     keyboard
%     close
end
% catch
%     out = false;
% end
end
