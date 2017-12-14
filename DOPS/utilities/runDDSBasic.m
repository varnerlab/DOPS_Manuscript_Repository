function[best]=runDDSBasic(numIters,functionToTest,MINJ,MAXJ,seed)
    r=0.2; 
    NUM_ITERATIONS = numIters;
    load('coagBounds.mat')
        rng(seed,'twister');
        tstart = tic();
        x0 = MINJ+rand()*(MAXJ-MINJ);
        [best,x_best,dds_swarm_flag]=DOPS_DDS(str2func(functionToTest),x0,MAXJ,MINJ,r,NUM_ITERATIONS);
        times = toc(tstart);
end