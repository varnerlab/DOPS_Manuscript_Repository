function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,DDS_iters]=runForTable1ExperimentalV2gamma(lowerIter,upperIter)
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj_v2, @fitCoag, @rast300, @BukinF6, @rosenbrock, @Eggholder, @mccorm, @hart6, @stybtang};
   % functions_to_test = {@rast, @ackley,@rosenbrock, @ButkinF6, @fitCoag};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat', 'rast300d_bounds.mat', 'BukinF6Bounds.mat','rosenbrock10d_bounds.mat', 'EggholderBounds.mat', 'mccorm_bounds.mat'...
        'hart6_bounds' ,'stybtang100d_bounds'};
    %bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat','rosenbrock10d_bounds.mat', 'BukinF6Bounds.mat','coagBounds.mat'}; 
   for j=5:5%size(functions_to_test,2):size(functions_to_test,2)%-4
        load(bounds_files{j});
        %deal with transposed files
        if(j ==3 || j ==4)
           MAXJ = ub';
           MINJ = lb';
        else
        
            MAXJ = ub;
            MINJ = lb;
        end
        [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,DDS_iters]=run_DOPS_ExperimentalV2gamma(functions_to_test{j},MAXJ,MINJ,lowerIter,upperIter);
    end
end
