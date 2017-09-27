function[alldata]= makeErrorPlot()
    MAXJ = repmat(10,10,1);
    MINJ = repmat(-10,10,1);
    [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS(@rosenbrock,MAXJ,MINJ);
    [g_best_solution_E,bestparticle_E,particle_E,fitness_E,bestval_dds_swarm_E,best_particle_dds_swarm_E,best_particles_ls_E, DDS_iters]=run_DOPS_ExperimentalV2(@rosenbrock,MAXJ,MINJ);
    NUMBER_TRIALS=25;
    %fig = figure();
    hold('on');
    maxlen = 0;
    for j=1:NUMBER_TRIALS
        currlen=size([g_best_solution{j},bestval_dds_swarm{j}],2);
        if(currlen>maxlen)
           maxlen = currlen;
        end
       % alldata(j,:)=([g_best_solution{j},bestval_dds_swarm{j}]);
    end
    alldata = zeros(maxlen,NUMBER_TRIALS);
    for k=1:NUMBER_TRIALS
       currdata = ([g_best_solution{k}, bestval_dds_swarm{k}]);
       if(size(currdata,2)<maxlen)
          currdata(size(currdata):maxlen)=1E-16; %should find a better way of making these numbers not count 
       end
       size(currdata)
       alldata(:,k)=currdata;
    end

    size(alldata)
    mat_Exp_data = cell2mat(g_best_solution_E);
    mat_Exp_data = reshape(mat_Exp_data, [],25);
    mean_Exp = mean(mat_Exp_data,2);
    close('all');
    hold('on')
    iters = 1:maxlen;
    fig=loglog(iters,mean(alldata,2),'k.');
    loglog(mean_Exp, 'r.');
    xlabel('Iteration')
    ylabel('Error')
    axis([0,4000,10^0,10^1])
    set(gca,'yscale','log')
    legend('DOPS', 'Experimental DOPS V2');
    saveas(fig, 'testFigures/DOPSOnRosenbrockCompareExperimentalDOPSV2.pdf')
end