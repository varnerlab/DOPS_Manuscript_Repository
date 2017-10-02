function[fvals, initial_vals]=runDDSOnCoag()
    r=0.2; 
    NUM_TRIALS = 25;
    NUM_ITERATIONS = 4000;
    fvals = zeros(NUM_TRIALS,NUM_ITERATIONS);
    load('coagBounds.mat')
    MAXJ = ub;
    MINJ  = lb;
    times = [];
    for j = 1:NUM_TRIALS
        rng(j,'twister');
        tstart = tic();
        x0 = MINJ+rand()*(MAXJ-MINJ);
        [best,x_best,dds_swarm_flag]=DOPS_DDS(@fitCoag,x0,MAXJ,MINJ,r,NUM_ITERATIONS);
        times(j) = toc(tstart)
        cmd1= ['save -ascii ../DDS_Results/fitCoag/FuntionalValuesTrial', num2str(j), '.txt best'];
		eval(cmd1)
        cmd2= ['save -ascii ../DDS_Results/fitCoag/ParameterValuesTrial', num2str(j), '.txt x_best'];
		eval(cmd2)
        cmd3= ['save -ascii ../DDS_Results/fitCoag/TimesTrial', num2str(j), '.txt times'];
		eval(cmd3)
        fvals(j,:) = (best);
    end
end