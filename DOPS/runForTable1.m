function[]=runForTable1(lowerIter, upperIter)
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj, @fitCoag, @BukinF6, @rosenbrock, @Eggholder, @mccorm, @hart6, @stybtang};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat', 'BukinF6Bounds.mat','rosenbrock10d_bounds.mat', 'EggholderBounds.mat', 'mccorm_bounds.mat'...
        'hart6_bounds.mat', 'stybtang100d_bounds.mat'};
    for j=size(functions_to_test,2):size(functions_to_test,2)
        load(bounds_files{j});
        %deal with transposed files
        if(j>2 && j<=4)
            MAXJ = ub';
            MINJ=lb';
        else
            MAXJ = ub;
            MINJ = lb;
        end
        rng(14850);
        run_DOPS(functions_to_test{j},MAXJ,MINJ,lowerIter,upperIter);
    end
end