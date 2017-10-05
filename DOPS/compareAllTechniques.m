function[]= compareAllTechniques()
    [allDOPS,adjustedAllDOPS,allExperimental]=compareExperimentalDOPS();
    allSAResults = processSAResults();
    allDDSResults = processDDSResults();
    allDEResults = processDEResults();
    close('all');
    f=figure();
    hold('on')
    plot(mean(adjustedAllDOPS,1), 'LineWidth', 2.0, 'Color', 'k');
    plot(mean(allSAResults,1), 'LineWidth', 2.0, 'Color','g');
    plot(mean(allDDSResults,1), 'LineWidth',2.0, 'Color', 'b');
    plot(1:40:4000,mean(allDEResults,1), 'LineWidth', 2.0,'Color','r');
    set(gca, 'YScale', 'log');
    axis([0,4000,7E4,2E7])
    legend('DOPS-N=25', 'Simulated Annealing-N=25', 'DDS-N=23', 'DE-N=1');
    xlabel('Number of Function Evaluations')
    ylabel('Average Functional Value');
    saveas(f,'../DOPS_Results/figures/RecreateFigure4.pdf', 'pdf')
    
end

function [allSAResults] =processSAResults()
    numTrials = 25;
    numIters = 4000;
    allSAResults = zeros(numTrials,numIters);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/SA_Results/fitCoag/FuntionalValuesTrial',num2str(j),'.txt'));  
       allSAResults(j,:) =currdata(1:4000);
    end
end

function [allDDSResults] =processDDSResults()
    numTrials = 23;
    numIters = 4000;
    allDDSResults = zeros(numTrials,numIters);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/DDS_Results/fitCoag/FuntionalValuesTrial',num2str(j),'.txt'));  
       allDDSResults(j,:) =currdata(1:4000);
    end
end

function [allDEResults] =processDEResults()
    numTrials = 1;
    numIters = 100;
    allDEResults = zeros(numTrials,numIters);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/DOPS/DE_Results_vY/DE_error_iter',num2str(j),'.txt'));  
       allDEResults(j,:) =currdata(1:100);
    end
end