function[mean_data, std_data]=runDOPSforTable2()
    functions_to_test = {@ackley, @rast, @rast};
    bounds_files = {'ackley10d_bounds.mat','rast10d_bounds.mat', 'rast300d_bounds.mat'};
    NUM_TRIALS=25;
    fvals = zeros(size(functions_to_test,2),NUM_TRIALS);
    initial_vals = zeros(size(functions_to_test,2),NUM_TRIALS);
    for j=1:size(functions_to_test,2)
        load(bounds_files{j});
         MAXJ = ub;
         MINJ = lb;
        [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS(functions_to_test{j},MAXJ,MINJ);
        for k=1:NUM_TRIALS
            fvals(j,k) = min(fitness{k}(:,end));%g_best_solution{k}(end);
            initial_vals(j,k)=min(fitness{k}(:,1));
        end
        mean_data(j) = mean(fvals(j,:)./initial_vals(j,:));
        std_data(j) = std(fvals(j,:)./initial_vals(j,:));
    end
end