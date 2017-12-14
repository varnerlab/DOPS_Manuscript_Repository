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
        dyn1 = checkForDynamics(thrombin1);
        dyn2 = checkForDynamics(thrombin2);
        dyn3 = checkForDynamics(thrombin3);
        allDyn = [dyn1, dyn2, dyn3];
        for m = 1:max(size(allDyn))
           if(allDyn(m)==0)
              fprintf('On param set %d, curve %d did not have dynamics', j, m); 
           end
               
        end
        
        all_curve1(j,:) = thrombin1;
        all_curve2(j,:) = thrombin2;
        all_curve3(j,:) = thrombin3;
    end
   makeFig6Plot(all_curve1,all_curve2,all_curve3,DFIN);
    DATA1 = DFIN.EXPT_DATA_FIG2E2;
    DATA2 = DFIN.EXPT_DATA_FIG2E3;
    DATA3 = DFIN.EXPT_DATA_FIG2E4;
    x = [1:1:250];
    NSE10pm = calculateNSE(DATA1,mean(all_curve1,1), x);
    NSE50pm = calculateNSE(DATA2,mean(all_curve2,1),x);
    NSE500pm = calculateNSE(DATA3,mean(all_curve3,1),x);
    
    fprintf('NSE for 10 pm trigger is %f\n', NSE10pm);
    fprintf('NSE for 50 pm trigger is %f\n', NSE50pm);
    fprintf('NSE for 500 pm trigger is %f\n', NSE500pm);
end
function[all_params]= readInParams(num_iters)
    %num_iters = 25;
    addpath('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag');
    num_params = 148;
    all_params = zeros(num_iters, num_params);
    numParticles =40;
    for j = 1:num_iters
        if(j ==5)
            load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter', num2str(j),'_old.mat'));
            load(strcat('DOPS_error_iter',num2str(j),'_old.mat'));
        else    
            load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/fitCoag/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter', num2str(j),'.mat'));
            load(strcat('DOPS_error_iter',num2str(j),'.mat'));
        end
        PSO_error = g_best_solution{j};
        numFEvalsInPSO = size(PSO_error,2)*numParticles;
        adjIdx = 4000-numFEvalsInPSO;
        best_params = best_particle_dds_swarm{j}(:,adjIdx); %correct for interations in PSO
        all_params(j,:) = best_params;
    end
end

function [dynamics] = checkForDynamics(curve)
    %we should have some thrombin by 75 seconds
    %each time step in one second
    if(max(size(curve))<75)
       dynamics = 0;
       return;
    end
    
    if(curve(75)-curve(1) > 10)
        dynamics = 1;
    else
        dynamics = 0;
    end
end

function [NSE]= calculateNSE(exp_data, sim_data,sim_time)
    time_pts = exp_data(:,1);
    sim_data_interp = interp1(sim_time,sim_data, time_pts);
    NSE = 0;
    for j = 1:max(size(exp_data))
       NSE = NSE +sqrt((exp_data(j,2)-sim_data_interp(j))^2); 
    end
    NSE = 1/max(exp_data(:,2))*1/sqrt(max(size(exp_data)))*NSE;
end