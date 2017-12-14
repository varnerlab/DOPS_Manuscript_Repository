function [all_curve1,all_curve2] = replicateFig5() %for DE, need 2 inputs
    if(nargin<2)
       y = []; 
    end
	DF=DataFile(0,0,0,[]); %Loads the coagulation data structure
	DFIN=DF;
    num_iters = 25;
    all_params = readInParams(num_iters);
    all_curve1 = [];
    all_curve2 = [];
    thrombinIdx = 48;
    for j = 1:num_iters
        fprintf('On parameter set %d of %d\n', j, num_iters);
        DFIN.RATE_CONSTANT_VECTOR=all_params(j,:); %Assigns the rate constant vector as the current solution
        [t1,curve1]=SimFunctionFig2E1(DFIN);
        thrombin1 = curve1(:,thrombinIdx);
        [t2,curve2]=SimFunctionFig2E5(DFIN); %Calculates the fitness values by passing the rate constant vector to the objectives E1 and E5
        thrombin2 = curve2(:,thrombinIdx);
        all_curve1(j,:) = thrombin1;
        all_curve2(j,:) = thrombin2;
    end
   makePlot(all_curve1,all_curve2,DFIN);
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

function makePlot(allcurve1, allcurve2,DFIN)
    close('all');
    f = figure();
   plot(mean(allcurve1,1), 'k')
    hold('on')
    plot(mean(allcurve2,1), 'k')
    std(allcurve1,1)
    numRepeats = 25;
    top1 = mean(allcurve1,1)+ 2.58*std(allcurve1,1)/sqrt(numRepeats);
    bottom1 = mean(allcurve1,1)- 2.58*std(allcurve1,1)/sqrt(numRepeats);
    x = 1:1:250;
    idx = find(bottom1<0);
    bottom1(idx) = 0; %remove things less than 0
    fill([x,fliplr(x)],[top1, fliplr(bottom1)], [.5, .5, .5],'facealpha', .5)
    top2 = mean(allcurve2,1)+ 2.58*std(allcurve2,1)/sqrt(numRepeats);
    bottom2 = mean(allcurve2,1)- 2.58*std(allcurve2,1)/sqrt(numRepeats);
    x = 1:1:250;
    idx = find(bottom2<0);
    bottom2(idx) = 0; %remove things less than 0
    fill([x,fliplr(x)],[top2, fliplr(bottom2)], [.25, .25, .25], 'facealpha', .5)
    DATA1 = DFIN.EXPT_DATA_FIG2E1;
    DATA2 = DFIN.EXPT_DATA_FIG2E5;
    plot(DATA1(:,1), DATA1(:,2), 'b.', 'MarkerSize', 12);
    plot(DATA2(:,1), DATA2(:,2), 'r.', 'MarkerSize',12);
   % legend('', '', '5pm Trigger', '5nm Trigger')
    xlabel('Time (Seconds)');
    ylabel('Thrombin Concentration (nM)');
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 8 7];
    print('../DOPS_Results/figures/ReplicateFigure5DivBySqrtN.pdf', '-dpdf','-r0');
    NSE5pm = calculateNSE(DATA1,mean(allcurve1,1), x);
    NSE5nm = calculateNSE(DATA2,mean(allcurve2,1),x);
    fprintf('NSE for 5 pm trigger is %f\n', NSE5pm);
    fprintf('NSE for 5 nm trigger is %f\n', NSE5nm);
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

