function [allDOPS,adjustedAllDOPS,allExperimental]=compareExperimentalDOPS()
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allExperimental = zeros(NUM_ITERS,NUM_EVALS);
    for j=1:NUM_ITERS
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
        load(strcat('DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
        DDS_error = bestval_dds_swarm{j};
        alldata= cat(2,PSO_error,DDS_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NUM_EVALS);
        allDOPS(j,:) =alldata;
        adjustedAllDOPS(j,:) = correctedAllData;
    end
   
    for k=1:NUM_ITERS
        if(k ==9)
           %iter 9 didn't finish, so skip it for now
           continue; 
        end
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2/fitCoag/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimental(k,:) = exp_err;
    end
%     figure()
%     hold('on')
%     semilogy(1:NUM_EVALS,mean(allDOPS,1))
%     semilogy(1:NUM_EVALS,mean(allExperimental,1))
%     axis([0,4000,1E5,1E8])
%     set(gca, 'YScale', 'log')
%     xlabel('Iteration Number')
%     ylabel('Functional Value')
%     legend('DOPS', 'Experimental DOPS')
    
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

