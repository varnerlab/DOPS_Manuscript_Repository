function[]=runForTable1DOPS_PSO_Only(lowerIter,upperIter,numSwarms)
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
   % functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj_v2, @fitCoag};
    functions_to_test = {@rast, @ackley,@fitCoag};
   % bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat'};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'coagBounds.mat'}; 
   for j=3:size(functions_to_test,2)
        load(bounds_files{j});
        %deal with transposed files
            MAXJ = ub;
            MINJ = lb;
        run_DOPS_PSO_only(functions_to_test{j},MAXJ,MINJ,lowerIter,upperIter,numSwarms);
    end
end