function [all_curve1,all_curve2,all_curve3,DFIN] = replicateFig6() %for DE, need 2 inputs
    if(nargin<2)
       y = []; 
    end
	DF=DataFile(0,0,0,[]); %Loads the coagulation data structure
	DFIN=DF;
    num_iters = 25;
    all_params = readInParams(num_iters);
    all_curve1 = [];
    all_curve2 = [];
    all_curve3 = [];
    thrombinIdx = 48;
    for j = 1:num_iters
        fprintf('On parameter set %d of %d\n', j, num_iters);
        DFIN.RATE_CONSTANT_VECTOR=all_params(j,:); %Assigns the rate constant vector as the current solution
        [t1,curve1]=SimFunctionFig2E2(DFIN);
        thrombin1 = curve1(:,thrombinIdx);
        [t2,curve2]=SimFunctionFig2E3(DFIN); %Calculates the fitness values by passing the rate constant vector to the objectives E1 and E5
        thrombin2 = curve2(:,thrombinIdx);
        [t3,curve3] = SimFunctionFig2E4(DFIN);
        thrombin3 = curve3(:,thrombinIdx);
        all_curve1(j,:) = thrombin1;
        all_curve2(j,:) = thrombin2;
        all_curve3(j,:) = thrombin3;
    end
   makeFig6Plot(all_curve1,all_curve2,all_curve3,DFIN);
end
function[all_params]= readInParams(num_iters)
    %num_iters = 25;
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    num_params = 148;
    all_params = zeros(num_iters, num_params);
    numParticles =40;
    for j = 1:num_iters
        load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter', num2str(j),'.mat'));
        load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        PSO_error = g_best_solution{j};
        numFEvalsInPSO = size(PSO_error,2)*numParticles;
        adjIdx = 4000-numFEvalsInPSO;
        best_params = best_particle_dds_swarm{j}(:,adjIdx); %correct for interations in PSO
        all_params(j,:) = best_params;
    end
end
