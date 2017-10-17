function [ output_args ] = RunEssOnSelectedFunction( input_args )
%run ESS on Coag and problem b4
    addpath(genpath('CoagulationFiles')) %add coagulation functions to path
    functions_to_test = {@b4_obj, @fitCoag};
    bounds_files = { 'b4_bounds.mat', 'coagBounds.mat'};
    num_repeats = 25;
    num_f_eval = 4000;
    for j = 1:size(functions_to_test,2)
        load(bounds_files{j});
       for k =1:num_repeats
           fprintf('On function %d of %d, on ESS repeat %d of %d', j,size(functions_to_test,2),k,num_repeats);
           runEss(func2str(functions_to_test{j}), lb, ub, num_f_eval,k,1,k);
       end
    end
end

