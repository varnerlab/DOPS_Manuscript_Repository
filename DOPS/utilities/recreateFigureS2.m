function [x,bestparams,functionalvals,initialvals] = recreateFigureS2()
    %also makes s3b and s3d
    close('all')
    NUM_REPEATS = 25;
    functionalvals = [];
    initialvals = [];
    for j =1:NUM_REPEATS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(j),'.mat'))
        functionalvals(j) = bestval_dds_swarm{j}(end);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/DOPS_error_iter',num2str(j),'.mat'))
        initialvals(j) = g_best_solution{j}(1);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(j),'.mat'))
        params(j,:) =best_particle_dds_swarm{j}(:,end);
    end
    [smallestf, minIdx] = min(functionalvals);
    bestparams = params(minIdx,:);
   [objective,constraints,residuals,x_all,x,t,timeseries_data,scaled_data] = b4_obj_forS2(bestparams);
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
    f.PaperPosition = [0 0 6 11];
    print('../DOPS_Results/figures/RecreatedFigureS2.pdf', '-dpdf','-r0');
    [ydot,x_int,p] = b4([0]);
    f=figure();
    set(gca, 'fontsize', 20);
    hold('on')
    plot(log(p), log(bestparams), 'bo', 'MarkerSize', 5);
    plot([-6,8], [-6,8], 'k-');
    xlabel('Nominal Parameters (log)','FontSize', 32)
    ylabel('Optimal Parameters (log)','FontSize', 32)
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/RecreatedFigureS3c.png', '-dpng','-r0');
    
    %get results of running model with original params
    [objective_o,constraints_o,residuals_o,x_all_o,x_o,t_o,timeseries_data_o,scaled_data_o] = b4_obj_forS2(p);
    f = figure();
    set(gca, 'fontsize', 20);
    hold('on')
    for j=1:size(x_o,2)
        plot(log((x_o(:,j))), log((x(:,j))), 'bo', 'MarkerSize',5);
    end
    plot([-2,14], [-2,14], 'k-');
    xlabel('Measured States With Nominal Parameters (log)','FontSize', 32)
    ylabel('Measured States With Optimal Parameters (log)','FontSize', 32)
     f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/RecreatedFigureS3d.png', '-dpng','-r0');
end