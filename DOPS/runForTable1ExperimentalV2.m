function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,DDS_iters]=runForTable1ExperimentalV2()
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj_v2, @fitCoag};
   % functions_to_test = {@rast, @ackley,@rosenbrock,@fitCoag};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat'};
    %bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat','rast10d_bounds.mat', 'coagBounds.mat'}; 
   for j=3:size(functions_to_test,2)-2
        load(bounds_files{j});
        %deal with transposed files
            MAXJ = ub';
            MINJ = lb';
        [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,DDS_iters]=run_DOPS_ExperimentalV2(functions_to_test{j},MAXJ,MINJ);
    end
end