function[]= run_DOPS_selected_function(currfun,MAXJ,MINJ)

    [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS(currfunc,MAXJ,MINJ);

    NUMBER_TRIALS=25;
    %fig = figure();
    close('all');
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
    close('all');
    iters = 1:maxlen;
    semilogy(iters,mean(alldata,2),'kx');
    xlabel('Iteration')
    ylabel('Error')
    axis([0,maxlen,1E-16,.8])
    set(gca,'yscale','log')
    saveas(strcat('testFigures/MeanErrorFor', func2str(currfunc)), 'pdf')
end