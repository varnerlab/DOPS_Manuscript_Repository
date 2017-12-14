function [allDOPS,adjustedAllDOPS,allExperimental]=compareExperimentalDOPSOnProblemB4()
    %this function compares DOPS to various versions of experimental DOPS
    %on problem b4
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj/');
    close('all')
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = [];
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allExperimental = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalBeta = zeros(NUM_ITERS,NUM_EVALS);
    allESS = zeros(NUM_ITERS,NUM_EVALS+1);
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
    end
   
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/b4_obj/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimental(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2beta/b4_obj/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalBeta(k,:) = exp_err;
    end
    
    for k = 1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/ESS_Results/b4_obj/functionalInterpIter', num2str(k), '.mat'))
        allESS(k,:) = f_interp;
    end
    f=figure()
     hold('on')
     x = 1:NUM_EVALS;
     semilogy(1:NUM_EVALS,mean(adjustedAllDOPS,1), 'r', 'LineWidth', 2)
     semilogy(1:NUM_EVALS,mean(allExperimental,1), 'c')
     %semilogy(1:NUM_EVALS,mean(allExperimentalBeta,1), 'b')
     %semilogy(0:NUM_EVALS, mean(allESS,1), 'k', 'LineWidth', 2);
     
     set(gca, 'YScale', 'log')
     xlabel('Number of Functional Evaluations')
     ylabel('Functional Value')
     legend('DOPS', 'Exp DOPS ESS gamma')
     saveas(f, '../DOPS_Results/figures/CompareExperimentalDOPSProblemB4.pdf');
     
%      f = figure();
%      hold('on')
%      for k = 1:NUM_ITERS
%          semilogy(1:NUM_EVALS,adjustedAllDOPS(k,:), 'g')
%          semilogy(1:NUM_EVALS,allExperimental(k,:), 'c')
%          semilogy(1:NUM_EVALS,allExperimentalBeta(k,:), 'b')
%          alpha(.5);
%          
%      end
%      set(gca, 'YScale', 'log')
%     xlabel('Number of Functional Evaluations')
%      ylabel('Functional Value')
%      legend('DOPS', 'Experimental DOPS', 'Experimental DOPS beta')
%      saveas(f, '../DOPS_Results/figures/CompareExperimentalDOPSOnProblemB4DispersionCurves.pdf');
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