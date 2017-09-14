function[]=runForTable1()
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@rast, @ackley,@b4_obj, @b1_obj_v2, @fitCoag};
    bounds_files = {'rast_bounds.mat', 'ackley_bounds.mat', 'b4_bounds.mat','b1_bounds.mat', 'coagBounds.mat'};
    for j=1:size(functions_to_test,2)
        load(bounds_files{j});
        %deal with transposed files
        if(j>2 && j<=4)
            MAXJ = ub';
            MINJ=lb';
        else
            MAXJ = ub;
            MINJ = lb;
        end
        run_DOPS(functions_to_test{j},MAXJ,MINJ);
    end
end