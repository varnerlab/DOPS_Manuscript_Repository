function[best_params, history, outputs, inital_vals]=runBasicSimulatedAnnealing(numIters,functionToTest,MINJ,MAXJ,seed)
    function [stop,options,optchanged] = myoutput(options,optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.fval];
        end
        optchanged = false;
    end
    
         options = optimoptions(@simulannealbnd,'MaxIterations',numIters, 'OutputFcn', @myoutput);
            %create bounds
            rng(seed, 'twister')
            x0 = MAXJ-MINJ.*rand(size(MAXJ,1),1)+MINJ; %create an initial guess within bounds
            inital_vals = feval(functionToTest,x0);
            history = [];
            [x,fval,exitflag,output]=simulannealbnd(str2func(functionToTest),x0,MINJ,MAXJ,options);
            best_params = x;
            fvals= fval;
            outputs= output;

end