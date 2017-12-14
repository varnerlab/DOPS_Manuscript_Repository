function[]=runForTable1WithInitialGuess(lowerIter, upperIter)
    %example of running with an initial guess
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj, @fitCoag, @BukinF6, @rosenbrock, @Eggholder, @mccorm, @hart6, @stybtang};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat', 'BukinF6Bounds.mat','rosenbrock10d_bounds.mat', 'EggholderBounds.mat', 'mccorm_bounds.mat'...
        'hart6_bounds.mat', 'stybtang100d_bounds.mat'};
    for j=4:4
        load(bounds_files{j});
        best_idx = 6;
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(best_idx),'.mat'))
        initial_guess = best_particle_dds_swarm{j}(:,end);
        %deal with transposed files
        if(j>2 && j<=4)
            MAXJ = ub';
            MINJ=lb';
        else
            MAXJ = ub;
            MINJ = lb;
        end
        rng(14850);
        run_DOPS_with_Initial_Guess(functions_to_test{j},MAXJ,MINJ,lowerIter,upperIter,initial_guess);
    end
end