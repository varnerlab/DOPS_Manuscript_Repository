function[best_params, fvals, outputs, inital_vals]=runSimulatedAnnealing(seed)
    function [stop,options,optchanged] = myoutput(options,optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.fval];
        end
        optchanged = false;
    end
    

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
            x0 = MAXJ-MINJ.*rand(size(MAXJ,1),1)+MINJ; %create an initial guess within bounds
            inital_vals(j,k) = feval(functions_to_test{j},x0);
            history = [];
            [x,fval,exitflag,output]=simulannealbnd(functions_to_test{j},x0,MINJ,MAXJ,options);
            best_params{j,k} = x;
            fvals(j,k) = fval;
            outputs{j,k} = output;
        end
    end
end