function[best_params, fvals, outputs, inital_vals]=runPSO(seed)
    poss_iter_nums =[40,2000,4000];
    functions_to_test = {@ackley, @rast, @rast};
    bounds = {[30;-15], [5.12;-5.12], [5.12;-5.12]};
    dimensions =[10,10,300];
    best_params = {};
    fvals = zeros(size(dimensions,2),size(functions_to_test,2));
    inital_vals = zeros(size(dimensions,2), size(functions_to_test,2));
    outputs = {};
    NUM_PARTCLES = 40;
    for k =1:size(poss_iter_nums,2)
        NUM_ITERATIONS=poss_iter_nums(k);
        for j=1:size(functions_to_test,2)
            %create bounds
            rng(seed)
            options = optimoptions('particleswarm','MaxIterations',1, 'SwarmSize',40);
            currlimits = bounds{j};
            MAXJ = repmat(currlimits(1),dimensions(j),1);
            MINJ = repmat(currlimits(2), dimensions(j),1);
            x0 = MAXJ-MINJ.*rand(size(MAXJ,1),1)+MINJ; %create an initial guess within bounds
            [x,fval,exitflag,output]=particleswarm(functions_to_test{j},size(MINJ,1),MINJ,MAXJ,options);
            inital_vals(j,k) = fval; %call our inital val the result after 1 iteration of PSO
             options = optimoptions('particleswarm','MaxIterations',NUM_ITERATIONS/NUM_PARTCLES, 'SwarmSize',40);% 'MinNeighborsFraction', 0);
             %now run PSO for actual number of interations
             rng(seed);
            [x,fval,exitflag,output]=particleswarm(functions_to_test{j},size(MINJ,1),MINJ,MAXJ,options);
            best_params{j,k} = x;
            fvals(j,k) = fval;
            outputs{j,k} = output;
        end
    end
end