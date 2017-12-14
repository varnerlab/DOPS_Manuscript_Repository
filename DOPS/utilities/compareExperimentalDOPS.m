function [allDOPS,adjustedAllDOPS,allExperimental,allDOPSTimes]=compareExperimentalDOPS()
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    close('all');
    NUM_ITERS = 25;
    NUM_EVALS = 4000;
    NUM_PARTCILES = 40;
    allDOPS = zeros(NUM_ITERS,NUM_EVALS);
    adjustedAllDOPS = zeros(NUM_ITERS,NUM_EVALS);
    allExperimental = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalbeta = zeros(NUM_ITERS,NUM_EVALS);
    allExperimentalgamma = zeros(NUM_ITERS,NUM_EVALS);
    allDOPSTimes = zeros(NUM_ITERS,1);
    for j=1:NUM_ITERS
       % if(j ==5) %need to skip 5 since rerunning at the moment
       %    adjustedAllDOPS(j,:) = NaN;
       %    continue;
       % end
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
       if(k ==1||k==2|| k ==20)
           allExperimental(k,:) = NaN;
           continue;
        end
        
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2/fitCoag/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimental(k,:) = exp_err;
    end
    
    for k=1:NUM_ITERS
       if(k==3|| k ==4 || k ==16 || k ==19)
           allExperimental(k,:) = NaN;
           continue;
        end
        
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2beta/fitCoag/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalbeta(k,:) = exp_err;
    end
    
     for k=1:NUM_ITERS
       if(k==7 || k==14 || k ==24)
           allExperimental(k,:) = NaN;
           continue;
        end
        
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/ExperimentalV2gamma/fitCoagShrinkFactor1E6/DOPS_error_iter', num2str(k),'.mat'));
        exp_err= g_best_solution{k};
        allExperimentalgamma(k,:) = exp_err;
    end
    f=figure();
    hold('on')
    semilogy(1:NUM_EVALS,nanmean(adjustedAllDOPS,1))
    %semilogy(1:NUM_EVALS,nanmean(allExperimental,1))
    %semilogy(1:NUM_EVALS,nanmean(allExperimentalbeta,1))
    semilogy(1:NUM_EVALS,nanmean(allExperimentalgamma,1))
    %axis([0,4000,1E5,1E8])
    set(gca, 'YScale', 'log')
    xlabel('Number of Functional Evaluations')
    ylabel('Functional Value')
    %legend('DOPS-25 iters', 'Experimental DOPS-22 iters', 'Experimental DOPS beta-21 iters', 'Experimental DOPS gamma')
    legend('DOPS-25 iters', 'Experimental DOPS gamma-25 iters');
    saveas(f, '../DOPS_Results/figures/DOPS_VS_ExpDOPSgamma.pdf', 'pdf');
    
    figure()
    hold('on')
    for j = 1:25
        semilogy(1:NUM_EVALS, allExperimentalgamma(j,:), 'r')
        semilogy(1:NUM_EVALS, adjustedAllDOPS(j,:), 'k');
    end
    set(gca, 'YScale', 'log')
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value')
    legend('Experimental DOPS gamma', 'DOPS')
    saveas(f, '../DOPS_Results/figures/DOPS_VS_ExpDOPSgammaDispCurvesShrinkFactor1E4.pdf', 'pdf');
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

