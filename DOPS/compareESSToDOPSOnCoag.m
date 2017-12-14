function [] = compareESSToDOPS()
    close('all');
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allESS = zeros(NUM_ITERS,NUM_EVALS+1);
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    for j=1:25
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
        load(strcat('DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
        DDS_error = bestval_dds_swarm{j};
        alldata= cat(2,PSO_error,DDS_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NUM_EVALS);
       % allDOPS(j,:) =alldata;
        adjustedAllDOPS(j,:) = correctedAllData;
    end
   
    for k=1:NUM_ITERS
%         if(k ==18 || k ==19 || k ==20)
%            allESS(k,:) = NaN;
%            continue;
%         end
        load(strcat('/home/rachel/Documents/DOPS/ESS_Results/fitCoag/functionalInterpIter', num2str(k),'.mat'));
        exp_err= f_interp(1:NUM_EVALS+1);
        allESS(k,:) = exp_err;
    end
    f=figure();
    hold('on')
    plot(1:NUM_EVALS,nanmean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color', 'r')
    plot(0:NUM_EVALS,nanmean(allESS,1), 'LineWidth', 2, 'Color','k')
    %axis([0,4000,1E5,1E8])
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
    
    figure()
    hold('on')
    for j = 1:25
        plot(0:NUM_EVALS,allESS(j,:), 'LineWidth', 1, 'Color','k')
    end
    set(gca, 'YScale', 'log')
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