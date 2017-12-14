function[fvals, initial_vals]=runDDSforTable2(seed)
    functions_to_test = {@ackley, @rast, @rast};
    bounds_files = {'ackley10d_bounds.mat','rast10d_bounds.mat', 'rast300d_bounds.mat'};
    poss_num_evals = [40,2000,4000];
    r=0.2; 
    initial_vals = zeros(size(functions_to_test,2), size(poss_num_evals,2));
    fvals=zeros(size(functions_to_test,2), size(poss_num_evals,2));
    for j=1:size(poss_num_evals,2)
        for k=1:size(functions_to_test,2)
            rng(seed)
            load(bounds_files{k});
            MAXJ = ub;
            MINJ  = lb;
            x0 = MINJ+rand()*(MAXJ-MINJ);
            initial_vals(j,k) = feval(functions_to_test{k}, x0);
            [best,x_best,dds_swarm_flag]=DOPS_DDS(functions_to_test{k},x0,MAXJ,MINJ,r,poss_num_evals(j));
            fvals(j,k) = min(best);
        end
    end
end