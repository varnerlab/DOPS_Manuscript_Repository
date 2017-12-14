function [allDOPS,adjustedAllDOPS,allExperimental,allDOPSTimes]=compareDOPSVersionsOnB4()
    %this function was developed with testing different versions of
    %experimental DOPS. It plots the performance of different versions on
    %the b4 problem
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/b4_obj');
    close('all');
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allExperimental = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalbeta = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalgamma = zeros(NUM_ITERS,NUM_EVALS);
    
    allExperimentalgamma_shrinkfactor1E5 = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalgamma_shrinkfactor1E6 = zeros(NUM_ITERS,NUM_EVALS);
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
        adjustedAllDOPS(j,:) = correctedAllData;
        
        currTime = load(strcat('DOPS_time_iter', num2str(j), '.txt'));
        currTime = currTime(j);
        allDOPSTimes(j) = currTime;
    end
   
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2/b4_obj/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimental(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2beta/b4_obj/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalbeta(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/b4_obj_shrinkFactor1E5/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalgamma(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/b4_obj_shrinkFactor1000/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalgamma_shrinkfactor1000(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/b4_obj_shrinkFactor100000/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalgamma_shrinkfactor1E6(k,:) = exp_err;
    end
    
     for k=1:NUM_ITERS
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/b4_obj_shrinkFactor1E5/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalgamma_shrinkfactor1E5(k,:) = exp_err;
    end
    f=figure();
    hold('on')
    semilogy(1:NUM_EVALS,nanmean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color','k')
    %semilogy(1:NUM_EVALS,nanmean(allExperimental,1))
    %semilogy(1:NUM_EVALS,nanmean(allExperimentalbeta,1), 'k')
    %semilogy(1:NUM_EVALS,nanmean(allExperimentalgamma,1))
    %semilogy(1:NUM_EVALS,nanmean(allExperimentalgamma_shrinkfactor1000,1))
    semilogy(1:NUM_EVALS,nanmean(allExperimentalgamma_shrinkfactor1E5,1), 'LineWidth',2, 'Color','r')
    %axis([0,4000,1E5,1E8])
    set(gca, 'YScale', 'log')
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value')
    legend('DOPS', 'Experimental DOPS')
    saveas(f, '../DOPS_Results/figures/2versionsofDOPS.pdf', 'pdf');
    
    %create dispersion curves on b4
    f=figure();
    hold('on')
    for j=1:25
       semilogy(adjustedAllDOPS(j,:), 'k') 
       alpha(.5); %make lines somewhat transparent
    end
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value');
    set(gca, 'YScale', 'log');
     saveas(f,'../DOPS_Results/figures/DOPSDispersionCurvesOnb4.pdf', 'pdf')
     
         f=figure();
    hold('on')
    for j=1:25
        semilogy(adjustedAllDOPS(j,:), 'k') 
       semilogy(allExperimentalgamma_shrinkfactor1E5(j,:), 'r') 
       alpha(.5); %make lines somewhat transparent
    end
    legend('DOPS', 'Exp DOPS Gamma, shrink factor=1E5');
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value');
    set(gca, 'YScale', 'log');
     saveas(f,'../DOPS_Results/figures/ExpDOPSgammaDispersionCurvesOnb4.pdf', 'pdf')
    
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