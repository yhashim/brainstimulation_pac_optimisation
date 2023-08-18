function WCoptim(folderName, J, K, n_mltSt, tmax, dt, maxFuncEval, f_target, psd_thres)

if isdeployed
    J = str2double(J); % Node index
    K = str2double(K); % CPU index
    n_mltSt = str2double(n_mltSt);
	tmax = str2double(tmax);
	dt = str2double(dt);
	maxFuncEval = str2double(maxFuncEval);	
    psd_thres = str2double(psd_thres);
    f_target = str2double(f_target);
end

% psd_thres       = 1E-5;
psd_verbose     = false;
df              = 5;
n               = round(tmax/dt);

mkdir(folderName)

%%% ensuring different seeds on each CPU
pause(10*rand)
rng(sum(100*clock)+333*feature('getpid'));

%%% lower and upper bounds on parameters
%  YH:0.01 for time, 0.5 noise, 10 beta
lb = [0 0 0 0 0 0 0 0 0]';
ub = [10 10 10 10 10 10 0.01 0.5 5]';
n_par = length(lb);

%%% optimFile
hyperPar.n_mltSt        = n_mltSt;
hyperPar.tmax           = tmax;
hyperPar.dt             = dt;
hyperPar.n              = n;
hyperPar.lb             = lb;
hyperPar.ub             = ub;
hyperPar.maxFuncEval  	= maxFuncEval;
hyperPar.n_par          = n_par;
hyperPar.f_target       = f_target;
hyperPar.df             = df;
hyperPar.psd_thres      = psd_thres;

optimFname = [folderName filesep 'optimFile.mat'];
try
    if ~isfile(optimFname)
        save(optimFname,'hyperPar');
    end
catch err
    warning('error while trying to write optimFile.mat');
    disp(getReport(err,'extended'));
end

%%% optimisation

% intialising x and fval
x = NaN(n_par,n_mltSt);
fval = NaN(n_mltSt,1);

% looping over local optimisations
for i_mltSt = 1:n_mltSt
    
	% rejecting initial parameters with PSDs very different from data
    PSDok = false;
    tic
    while ~PSDok
        x0 = (ub-lb).*rand(n_par,1)+lb;
        PSDok = isPSDok (x0,dt,n,f_target,df,psd_verbose,psd_thres);
    end
    toc
    
    options = optimoptions('fmincon','MaxFunctionEvaluations',maxFuncEval,...
        'Display','iter');
    
    %optim
    fileName = [folderName '/' num2str(J) '_' num2str(K) '_' num2str(i_mltSt)];
    
    fun_opt = @(x) getCost(x,par1,par2,...); % YH: add inputs
          
    [x,fval] = fmincon(fun_opt,x0,[],[],[],[],lb,ub,[],options);
    x0 = x;
    
    save(fileName,'x','fval')
    
end

if isdeployed
    exit
end

end
