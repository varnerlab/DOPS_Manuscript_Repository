function[best_params, fvals, outputs, inital_vals]=runBasicAdisDE(numIters,functionToTest,MINJ,MAXJ,seed)
    function [stop,options,optchanged] = myoutput(options,optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.fval];
        end
        optchanged = false;
    end
    
    best_params = [];
    outputs = [];
    numParticles = 40;
    ctl.constr= 0;
    ctl.const = [];
    ctl.NP    = numParticles;         % NP will be set later
    ctl.F     = 0.8;
    ctl.CR    = 0.9;
    ctl.strategy = 1;
    ctl.refresh  = 0;
    ctl.VTR   = -Inf;
    ctl.tol   = 0;
    ctl.maxnfe  = 1e6;
            %create bounds
            rng(seed,'twister')
            x0 = MAXJ-MINJ.*rand(size(MAXJ,1),numParticles)+MINJ; %create an initial guess within bounds
            inital_vals = min(feval(functionToTest,x0));
            [bestparticle, g_best_solution,nfeval] = de(functionToTest,x0,MINJ,MAXJ,numIters);
            fvals = g_best_solution;

end