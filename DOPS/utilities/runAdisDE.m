function[best_params, fvals, outputs, inital_vals]=runAdisDE(seed)
    %runs DE for comparsion with DOPS
    function [stop,options,optchanged] = myoutput(options,optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.fval];
        end
        optchanged = false;
    end
    

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
    poss_iter_nums =[40,2000,4000];
    functions_to_test = {@ackley, @rast, @rast};
    bounds = {[30;-15], [5.12;-5.12], [5.12;-5.12]};
    dimensions =[10,10,300];
    best_params = {};
    fvals = zeros(size(dimensions,2),size(functions_to_test,2));
    inital_vals = zeros(size(dimensions,2), size(functions_to_test,2));
    outputs = {};
    for k =1:size(poss_iter_nums,2)
        NUM_ITERATIONS=poss_iter_nums(k);
         options = optimoptions(@simulannealbnd,'MaxIterations',NUM_ITERATIONS, 'OutputFcn', @myoutput);
        for j=1:size(functions_to_test,2)
            %create bounds
            rng(seed)
            currlimits = bounds{j};
            MAXJ = repmat(currlimits(1),dimensions(j),1);
            MINJ = repmat(currlimits(2), dimensions(j),1);
            x0 = MAXJ-MINJ.*rand(size(MAXJ,1),numParticles)+MINJ; %create an initial guess within bounds
            inital_vals(j,k) = min(feval(functions_to_test{j},x0));
            [bestparticle, g_best_solution,nfeval] = de(functions_to_test{j},x0,MINJ,MAXJ,poss_iter_nums(k)/numParticles);
            fvals(j,k) = g_best_solution(end);
        end
    end
end