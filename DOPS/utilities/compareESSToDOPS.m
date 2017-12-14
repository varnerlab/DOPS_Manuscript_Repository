function [] = compareESSToDOPS()
    %this function plots the performance of ESS and DOPS on the coagulation
    %problem and problem b4
    close('all');
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allESS = zeros(NUM_ITERS,NUM_EVALS+1);
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    for j=1:NUM_ITERS
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
        load(strcat('DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
        DDS_error = bestval_dds_swarm{j};
        alldata= cat(2,PSO_error,DDS_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NUM_EVALS);
        adjustedAllDOPS(j,:) = correctedAllData;
    end
   
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/ESS_Results/fitCoag/functionalInterpIter', num2str(k),'.mat'));
        exp_err= f_interp(1:NUM_EVALS+1);
        allESS(k,:) = exp_err;
    end
    f=figure();
    hold('on')
    plot(1:NUM_EVALS,nanmean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color', 'r')
    plot(0:NUM_EVALS,nanmean(allESS,1), 'LineWidth', 2, 'Color','k')
    set(gca, 'YScale', 'log')
    set(gca, 'fontsize', 20);
    xlabel('Number of Function Evaluations', 'FontSize', 32)
    ylabel('Functional Value', 'FontSize',32)
    legend('DOPS', 'ESS')
     f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/CompareDOPSToESSOnCoag.png', '-dpng','-r0');
    
    f = figure();
    hold('on')
     set(gca, 'YScale', 'log')
    set(gca, 'fontsize', 20);
    xlabel('Number of Function Evaluations', 'FontSize', 32)
    ylabel('Functional Value', 'FontSize',32)
    for j =1:NUM_ITERS
        plot(1:NUM_EVALS,adjustedAllDOPS(j,:), 'LineWidth', 1, 'Color', 'k');
    end
     f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/DOPSDispCurvesCoag.png', '-dpng','-r0');
    
    figure()
    hold('on')
    for j = 1:25
        plot(0:NUM_EVALS,allESS(j,:), 'LineWidth', 1, 'Color','k')
    end
    set(gca, 'YScale', 'log')
    
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allESS = zeros(NUM_ITERS,NUM_EVALS+1);
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj');
    for j=1:NUM_ITERS
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
        load(strcat('DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
        DDS_error = bestval_dds_swarm{j};
        alldata= cat(2,PSO_error,DDS_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NUM_EVALS);
        adjustedAllDOPS(j,:) = correctedAllData;
    end
   
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/ESS_Results/b4_obj/functionalInterpIter', num2str(k),'.mat'));
        exp_err= f_interp(1:NUM_EVALS+1);
        allESS(k,:) = exp_err;
    end
    f=figure();
    hold('on')
    plot(1:NUM_EVALS,nanmean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color', 'r')
    plot(0:NUM_EVALS,nanmean(allESS,1), 'LineWidth', 2, 'Color','k')
    set(gca, 'YScale', 'log')
    set(gca, 'fontsize', 20);
    xlabel('Number of Function Evaluations', 'FontSize', 32)
    ylabel('Functional Value', 'FontSize',32)
    legend('DOPS', 'ESS')
     f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/CompareDOPSToESSOnb4.png', '-dpng','-r0');
    
    figure()
    hold('on')
    for j = 1:25
        plot(0:NUM_EVALS,allESS(j,:), 'LineWidth', 1, 'Color','k')
    end
    set(gca, 'YScale', 'log')
    
    f = figure();
    hold('on')
    set(gca, 'YScale', 'log')
    set(gca, 'fontsize', 20);
    xlabel('Number of Function Evaluations', 'FontSize', 32)
    ylabel('Functional Value', 'FontSize',32)
    for j =1:NUM_ITERS
        plot(1:NUM_EVALS,adjustedAllDOPS(j,:), 'LineWidth', 1, 'Color', 'k');
    end
     f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/DOPSDispCurvesb4.png', '-dpng','-r0');
end

function[filledInData]=fillInPSO(numParticles,PSO_error)
    filledInData = zeros(1,numParticles*size(PSO_error,2));
    lowerIdx = 1;
    upperIdx = numParticles;
    for j=1:size(PSO_error,2)
        filledInData(lowerIdx:upperIdx)=PSO_error(j);
        lowerIdx=upperIdx;
        upperIdx = upperIdx+numParticles;
    end
end