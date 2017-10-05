function [x,bestparams] = recreateFigureS2()
    NUM_REPEATS = 25;
    functionalvals = [];
    initialvals = [];
    for j =1:NUM_REPEATS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(j),'.mat'))
        functionalvals(j) = bestval_dds_swarm{j}(end);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(j),'.mat'))
        params(j,:) =best_particle_dds_swarm{j}(:,end);
    end
    [smallestf, minIdx] = min(functionalvals);
    bestparams = params(minIdx,:);
   [objective,constraints,residuals,x,t,timeseries_data,scaled_data] = b4_obj_forS2(bestparams);
    num_species = 13;
    f=figure();
    for j = 1:num_species
        subplot(7,2,j);
        hold('on')
        plot(timeseries_data(:,1), scaled_data(:,j), 'rx');
        plot(t,x(:,j), 'b-')
        title(strcat('Obs', num2str(j)))
    end
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 5 10];
    print('../DOPS_Results/figures/RecreatedFigureS2.pdf', '-dpdf','-r0');
end