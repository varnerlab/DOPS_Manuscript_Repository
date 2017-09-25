function[mean_data, std_data]=runDOPSforTable2()
    functions_to_test = {@ackley, @rast, @rast, @rosenbrock};
    bounds_files = {'ackley10d_bounds.mat','rast10d_bounds.mat', 'rast300d_bounds.mat', 'rosenbrock10d_bounds.mat'};
    NUM_TRIALS=5;
    fvals = zeros(size(functions_to_test,2),NUM_TRIALS);
    initial_vals = zeros(size(functions_to_test,2),NUM_TRIALS);
    for j=1:size(functions_to_test,2)-1
        load(bounds_files{j});
         MAXJ = ub;
         MINJ = lb;
        [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS(functions_to_test{j},MAXJ,MINJ,NUM_TRIALS);
         %[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS_onlyPSO(functions_to_test{j},MAXJ,MINJ);
        for k=1:NUM_TRIALS
            if(size(bestval_dds_swarm,1) ==0)
                fvals(j,k) = g_best_solution{k}(end); %min(fitness{k}(:,end));
            else
                fvals(j,k) = bestval_dds_swarm{k}(end);
            end
            initial_vals(j,k)=min(fitness{k}(:,1));
        end
        mean_data(j) = mean(fvals(j,:)./initial_vals(j,:));
        std_data(j) = std(fvals(j,:)./initial_vals(j,:));
    end
end