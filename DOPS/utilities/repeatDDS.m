function [ mean_perf,std_perf ] = repeatDDS( input_args )
    %Repeat DDS for figure2 
    num_repeats = 25;
    allfvals = [];
    allinitial_vals = [];
    for j=1:num_repeats
        fprintf('On repeat %d\n', j);
        [fvals, inital_vals]=runDDSforTable2(j);
        allfvals(j,:,:) = fvals;
        allinitial_vals(j,:,:) = inital_vals;
    end
    mean_perf = mean(allfvals./allinitial_vals,1);
    std_perf = std(allfvals./allinitial_vals,1);
end

