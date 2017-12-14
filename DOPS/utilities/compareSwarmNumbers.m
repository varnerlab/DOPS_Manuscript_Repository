function []=compareSwarmNumbers()
    %this function plots the results of changing the number of particles
    %in a swarm during PSO
    [allDOPS,adjustedAllDOPS,allExperimental]=compareExperimentalDOPS();
    swarmNum = [1,2,4,5,8];
    close('all');
    f = figure();
    hold('on')
    numEvals = 4000;
    numFEvals = 1:1:numEvals;
    %plot DOPS results
    set(gca, 'YScale', 'log')
    semilogy(numFEvals, mean(adjustedAllDOPS,1), 'LineWidth', 2.0,'Color', 'k');
    numRepeats = 25;
    NUM_PARTCILES = 40;
    colors = {repmat(75/255,1,3), repmat(125/255,1,3), repmat(175/255,1,3),[0,0,0], repmat(225/255,1,3)};
    
    for k = 1:size(swarmNum,2)
       adjustedAllDOPS = [];
       currSwarmNum = swarmNum(k);
       for j = 1:numRepeats
           
           load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/PSO_Only/fitCoag/',num2str(currSwarmNum), 'Swarms/DOPS_error_iter',num2str(j),'.mat'));
           PSO_error = g_best_solution{j};
           corrected_PSO_error = fillInPSO(NUM_PARTCILES,PSO_error);
           %load(strcat('/home/rachel/Documents/DOPS/DOPS_Results/PSO_Only/fitCoag/',num2str(currSwarmNum), 'Swarms/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter', num2str(j),'.mat'));
           %DDS_error = bestval_dds_swarm{j};
           %alldata= cat(2,PSO_error,DDS_error);
           correctedAllData = corrected_PSO_error;
           correctedAllData = correctedAllData(1:numEvals);
           adjustedAllDOPS(j,:) = correctedAllData;
       end
       if (currSwarmNum ==5)
           mDOPS=mean(adjustedAllDOPS,1);
         semilogy(numFEvals(1:40:end), mDOPS(1:40:end), 'LineWidth', 1, 'Color', colors{k}, 'Marker', 'o','MarkerFaceColor', 'w');  
       else
        semilogy(numFEvals, mean(adjustedAllDOPS,1), 'LineWidth', 2, 'Color', colors{k});
       end
    end
    legend('DOPS', '1 Swarm', '2 Swarms', '4 Swarms', '5 Swarms', '8 Swarms')
    ylabel('Average Functional Value for N=25 Trials')
    xlabel('Number of Function Evalutions')
    axis([0,4000,7E4,2E7])
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    print('../DOPS_Results/figures/RecreateFigure7.pdf', '-dpdf','-r0');
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