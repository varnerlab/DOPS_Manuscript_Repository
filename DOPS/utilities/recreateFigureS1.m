function [x,bestparams,initialvals,functionalvals] = recreateFigureS1()
    %also makes figures S3a and S3b
    close('all')
    NUM_REPEATS = 76;
    functionalvals = [];
    calculatedfunctionalvals = [];
    initialvals = [];
    num_states = 276;
    for j =1:NUM_REPEATS
        if(j==20 || j ==26 ||j==28 || j ==29|| j==33 || j==35||j==39||j==41||j==42||j==44|| j==45||j==46||j==47||j==48||j==52||j==53||j==65||j==67||j==70||j==73||j==74||j==75)
           params(j,:) = NaN; 
           functionalvals(j)=10^20;
           continue;
        end
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(j),'.mat'))
        functionalvals(j) = bestval_dds_swarm{j}(end);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DOPS_error_iter',num2str(j),'.mat'))
        initialvals(j) = g_best_solution{j}(1);
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/b1_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(j),'.mat'))
        params(j,:) =best_particle_dds_swarm{j}(:,end);
    end
    %[smallestf, minIdx] = nanmin(functionalvals); %ignore NAN
    minIdx = 2; %this is just hard coding which parameter set performs the best
    bestparams = params(minIdx,:);
%      for j = 1:NUM_REPEATS
%          fprintf('Calculating functional value for param set %d \n', j);
%         if(isnan(params(j,:)))
%            calculatedfunctionalvals(j) = 1E20;
%            continue;
%         else
%              [objective,constraints,residuals,x_sel,x,t,scaled_data] = b1_obj_forS1(params(j,:),j);
%              calculatedfunctionalvals(j) = objective;
%         end
%         fprintf('Calculated functional value for param set %d is %f\n', j, objective);
%      end
     
   [objective,constraints,residuals,x_sel,x,t,scaled_data] = b1_obj_forS1(bestparams,100);
   containsNANS = max(isnan(x(:)));
   repCounter = 1;
   while(containsNANS ==1 && repCounter <600) %keep trying until we actually solve
         fprintf('Attempting to solve problem b1. On attempt %d\n', repCounter);
         [objective,constraints,residuals,x_sel,x,t,scaled_data] = b1_obj_forS1(bestparams);
         containsNANS = max(isnan(x(:)));
         repCounter = repCounter +1;
   end
   
    num_species = 44;
    scaled_data = scaled_data{1};
    f=figure();
    for j = 1:num_species
        subplot(9,5,j);
        hold('on')
        plot(t, scaled_data(:,j), 'rx');
        plot(t,x_sel(:,j), 'b-')
        title(strcat('Obs', num2str(j)))
        xlim([0,125])
    end
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 5 10];
    print('../DOPS_Results/figures/RecreatedFigureS1.pdf', '-dpdf','-r0');
        [ydot,x_int,p] = b1([0]);
    f=figure();
     set(gca, 'fontsize', 20);
    hold('on')
    plot(log(p(1:size(bestparams,2))), log(bestparams), 'bo', 'MarkerSize', 5);
    plot([-15,10], [-15,10], 'k-');
    xlabel('Nominal Parameters (log)','FontSize', 32)
    ylabel('Optimal Parameters (log)','FontSize', 32)
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/RecreatedFigureS3a.png', '-dpng','-r0');
    
   %get results of running model with original params
    [objective_o,constraints_o,residuals_o,x_sel_o,x_o,t_o,scaled_data_o] = b1_obj_forS1(p,-1);
    scaled_data_o = scaled_data_o{1};
    f = figure();
    hold('on')
     set(gca, 'fontsize', 20);
    for j = 1:size(x_sel_o,2)
        plot(log((x_sel_o(:,j))), log((x_sel(:,j))), 'bo', 'MarkerSize',5);
    end
    plot([-20,5], [-20,5], 'k-');
    xlabel('Measured States With Nominal Parameters (log)','FontSize', 32)
    ylabel('Measured States With Optimal Parameters (log)','FontSize', 32)
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/RecreatedFigureS3b.png', '-dpng','-r0');
end