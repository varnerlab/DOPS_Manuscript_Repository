function[mean_data, std_data]=runDOPSforTable2()
    %calculates statistics about DOPS performance
    functions_to_test = {@ackley, @rast, @rast, @rosenbrock, @BukinF6, @Beale};
    bounds_files = {'ackley10d_bounds.mat','rast10d_bounds.mat', 'rast300d_bounds.mat', 'rosenbrock10d_bounds.mat', 'BukinF6Bounds.mat', 'BealeBounds.mat'};
    NUM_TRIALS=25;
    fvals = zeros(size(functions_to_test,2)-3,NUM_TRIALS);
    initial_vals = zeros(size(functions_to_test,2)-3,NUM_TRIALS);
    for j=1:size(functions_to_test,2)-3
        load(bounds_files{j});
         MAXJ = ub;
         MINJ = lb;
         [g_best_solution1,bestparticle1,particle1,fitness1,bestval_dds_swarm1,best_particle_dds_swarm1,best_particles_ls1]=run_DOPS(functions_to_test{j},MAXJ,MINJ,NUM_TRIALS);
        [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS(functions_to_test{j},MAXJ,MINJ,NUM_TRIALS);
         %[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS_onlyPSO(functions_to_test{j},MAXJ,MINJ);
        for k=1:NUM_TRIALS
            if(size(bestval_dds_swarm{k},1) ==0)
                fvals(j,k) = g_best_solution{k}(1); %min(fitness{k}(:,end));
            else
                fvals(j,k) = bestval_dds_swarm{k}(end);
            end
            initial_vals(j,k)=min(fitness1{k}(:,1));
        end
        mean_data(j) = mean(fvals(j,:)./initial_vals(j,:));
        std_data(j) = std(fvals(j,:)./initial_vals(j,:));
    end
end