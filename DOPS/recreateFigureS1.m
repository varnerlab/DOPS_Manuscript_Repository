function [x,bestparams,initialvals,functionalvals] = recreateFigureS1()
    close('all')
    NUM_REPEATS = 10;
    functionalvals = [];
    initialvals = [];
    num_states = 276;
    for j =1:NUM_REPEATS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(j),'.mat'))
        functionalvals(j) = bestval_dds_swarm{j}(end);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DOPS_error_iter',num2str(j),'.mat'))
        initialvals(j) = g_best_solution{j}(1);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(j),'.mat'))
        params(j,:) =best_particle_dds_swarm{j}(:,end);
    end
    [smallestf, minIdx] = nanmin(functionalvals); %ignore NAN
    bestparams = params(minIdx,:);
   [objective,constraints,residuals,x_sel,x,t,scaled_data] = b1_obj_forS1(bestparams);
    num_species = 44;
    scaled_data = scaled_data{1};
    f=figure();
    for j = 1:num_species
        subplot(9,5,j);
        hold('on')
        plot(t, scaled_data(:,j), 'rx');
        plot(t,x_sel(:,j), 'b-')
        title(strcat('Obs', num2str(j)))
    end
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 5 10];
    print('../DOPS_Results/figures/RecreatedFigureS1.pdf', '-dpdf','-r0');
        [ydot,x_int,p] = b1([0]);
    f=figure();
    hold('on')
    plot(log(p(1:size(bestparams,2))), log(bestparams), 'b.', 'MarkerSize', 20);
    plot([-15,10], [-15,10], 'k-');
    xlabel('Nominal Parameters (log)')
    ylabel('Optimal Parameters (log)')
    print('../DOPS_Results/figures/RecreatedFigureS3a.pdf', '-dpdf','-r0');
    
   %get results of running model with original params
    [objective_o,constraints_o,residuals_o,x_sel_o,x_o,t_o,scaled_data_o] = b1_obj_forS1(p);
    scaled_data_o = scaled_data_o{1};
    f = figure();
    hold('on')
    for j=1:num_states
        plot(log(norm(x_o(:,j))), log(norm(x(:,j))), 'b.', 'MarkerSize',20);
    end
    plot([-6,10], [-6,10], 'k-');
    xlabel('Norm of Measured States With Nominal Paramters (log)')
    ylabel('Norm of Measured States With Optimal Paramters (log)')
    print('../DOPS_Results/figures/RecreatedFigureS3b.pdf', '-dpdf','-r0');
end