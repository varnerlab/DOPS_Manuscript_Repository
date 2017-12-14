function[allCMAES,allSA,allDE,allDDS,allDOPS,allEss]= replicateFigureS4(Infunction, numRepeats)
    %compares optimization methods for figure S4
    numDims = 300;
    functions = {Infunction};
    ack_bounds = [-15,30];
    rast_bounds = [-5.12,5.12];
    numFEvals = 4000;
    seed = 14850;
    
    for j=1:size(functions,2)
        close('all');
       if(j ==1)
           lb = repmat(ack_bounds(1),numDims,1);
           ub = repmat(ack_bounds(2), numDims,1);
       elseif(j ==2)
               lb = repmat(rast_bounds(1),numDims,1);
               ub = repmat(rast_bounds(2), numDims,1);
       end
       f = figure();
       hold('on');
       allCMAES = [];
       allSA = [];
       allDE = [];
       allDDS = [];
       allDOPS = [];
       allEss = [];
       for k=1:numRepeats
           seed = k;
           cmasesavestr = strcat('../../DOPS/CMAES_Results/', functions{j}, '/Iter', num2str(k));
           [evalCounter,functionalVal]= runCmaes(cmasesavestr,lb,ub,functions{j});
           [best_params, fvalsSA, outputs, inital_vals]=runBasicSimulatedAnnealing(numFEvals,functions{j},lb,ub,seed);
           [best_params, fvalsDE, outputs, inital_vals]=runBasicAdisDE(numFEvals,functions{j},lb,ub,seed);
           [fvalsDDS]=runDDSBasic(numFEvals,functions{j},lb,ub,seed);
           [g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,correctedAllData]=run_DOPSBasic(numFEvals,functions{j},lb,ub,seed);
           [res,f_iterp] = runEss(functions{j},lb,ub, numFEvals,seed,0,k);
       
        %iterpolate for CMAES
        functionalVal_i = interp1(evalCounter,functionalVal,1:1:numFEvals);
        allCMAES(:,k) = functionalVal_i;
        allSA(:,k) = fvalsSA;
        allDE(:,k) = fvalsDE;
        allDDS(:,k) = fvalsDDS;
        allDOPS(:,k) = correctedAllData;
        allEss(:,k) = f_iterp;
       end
           %make plot
           set(gca, 'fontsize', 20);
           plot(1:1:numFEvals,mean(allCMAES,2), 'LineWidth', 2, 'Color', 'b');
           plot(0:1:numFEvals,mean(allSA,2), 'LineWidth', 2, 'Color', 'c');
           plot(1:40:numFEvals,mean(allDE,2), 'LineWidth', 2, 'Color', 'g');
           plot(1:1:numFEvals,mean(allDDS,2), 'LineWidth', 2, 'Color', 'm');
           plot(1:1:numFEvals,mean(allDOPS,2), 'LineWidth', 2, 'Color', 'k');
           plot(0:1:numFEvals, mean(allEss,2), 'LineWidth',2, 'Color', 'r');
           alpha(.5)
           
       
       legend('CMAES', 'Simulated Annealing', 'DE', 'DDS', 'DOPS', 'ESS');
       %set(gca, 'YScale', 'log');
       xlabel('Number of Function Evaluations', 'FontSize', 32)
       ylabel('Objective Functional Value','FontSize',32);
       xlim([0,4000])
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
       if(strcmp('ackley',Infunction))
            print('../DOPS_Results/figures/RecreateRebutalReviewer1_FigS4a.png', '-dpng','-r0'); 
       elseif(strcmp('rast',Infunction))
           print('../DOPS_Results/figures/RecreateRebutalReviewer1_FigS4b.png', '-dpng','-r0'); 
       end
       
    end
end