function [allDOPS,adjustedAllDOPS,allExperimental,allDOPSTimes]=compareDOPSVersionsOnSelectedFunction(functionName)
    addpath(strcat('/home/rachel/Documents/DOPS/DOPS_Results/',functionName));
    close('all');
    NUM_ITERS = 250;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allExperimental = zeros(NUM_ITERS,NUM_EVALS);
    allDOPSTimes = zeros(NUM_ITERS,1);
    for j=1:NUM_ITERS
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
        load(strcat('DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
        DDS_error = bestval_dds_swarm{j};
        alldata= cat(2,PSO_error,DDS_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NUM_EVALS);
        %allDOPS(j,:) =alldata;
        adjustedAllDOPS(j,:) = correctedAllData;
        
        currTime = load(strcat('DOPS_time_iter', num2str(j), '.txt'));
        currTime = currTime(j);
        allDOPSTimes(j) = currTime;
    end
   
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/',functionName, '/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimental(k,:) = exp_err;
    end
    
    f=figure();
    hold('on')
    semilogy(1:NUM_EVALS,nanmean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color','k')
    semilogy(1:NUM_EVALS,nanmean(allExperimental,1), 'LineWidth',2, 'Color','r')
    %axis([0,4000,1E5,1E8])
    set(gca, 'YScale', 'log')
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value')
    legend('DOPS', 'Experimental DOPS')
    saveas(f, strcat('../DOPS_Results/figures/2versionsofDOPSOn',functionName, '.pdf'), 'pdf');
    
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