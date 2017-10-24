function [res,f_interp] = runEss(functionName, lb, ub, numEval,seed,saveOn, trialNum)

    %numEval = 4000;
    %set up problem
    if(seed ==13)
       seed = 765; %we appear to be getting stuck on iter 13  
    end
    rng(seed, 'twister');
    problem.f = functionName;
%     lb = repmat(-15,300,1);
%     ub=repmat(30,300,1);
    problem.x_L =lb;
    problem.x_U = ub;
    N = max(size(lb));
    problem.x_0 = lb+(ub-lb).*rand(N,1); 
        
    
    initial_f = feval(functionName, problem.x_0);
    %set opts
    opts.maxeval = numEval; %do 4000 evaulations
    opts.maxtime = 60*60*10; %max cpu time is 10 hours
    opts.iterprint = 1; %print stuff out
    opts.inter_save = 1; %save itermediate results
    opts.local.finish = 0; %do not to extra local searching
    opts.local.solver = 0; %no local search
    
    res = ess_kernel(problem,opts);
    
     %don't get values back at every evaluation, need to interpolate
     f_interp = interp1([0,res.neval], [initial_f,res.f], 0:1:numEval);
     %write results to disk
     if(saveOn ==1)
        save(strcat('../ESS_Results/', functionName,'/resultsIter', num2str(trialNum), '.mat'), '-struct', 'res');
         save(strcat('../ESS_Results/', functionName,'/functionalInterpIter', num2str(trialNum), '.mat'), 'f_interp');
     end
    
end