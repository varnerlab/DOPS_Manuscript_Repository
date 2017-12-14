function[]= compareAllTechniques()
    %this function compares serveral techniques to DOPS on the coagulation
    %problem to replication figure 4 from the paper
    [allDOPS,adjustedAllDOPS,allExperimental,allDOPSTimes]=compareExperimentalDOPS();
    [allSAResults,allSATimes] = processSAResults();
    [allDDSResults,allDDSTimes] = processDDSResults();
    [allDEResults,allDETimes] = processDEResults();
    close('all');
    f=figure();
    hold('on')
    plot(mean(adjustedAllDOPS,1), 'LineWidth', 2.0, 'Color', 'k');
    plot(mean(allSAResults,1), 'LineWidth', 2.0, 'Color','g');
    plot(mean(allDDSResults,1), 'LineWidth',2.0, 'Color', 'b');
    plot(1:40:4000,mean(allDEResults,1), 'LineWidth', 2.0,'Color','r');
    set(gca, 'YScale', 'log');
    axis([0,4000,7E4,2E7])
    legend('DOPS', 'Simulated Annealing', 'DDS', 'DE');
    xlabel('Objective Function Evaluations')
    ylabel({'Mean Objective Function Error', '(Number of Trials = 25)'});
    saveas(f,'../DOPS_Results/figures/RecreateFigure4.pdf', 'pdf')

    %to create DOPS dispersion curve
    f=figure();
    hold('on')
    for j=1:25
       semilogy(adjustedAllDOPS(j,:), 'k') 
       alpha(.5); %make lines somewhat transparent
    end
    xlabel('Number of Function Evaluations')
    ylabel('Functional Value');
    set(gca, 'YScale', 'log');
     saveas(f,'../DOPS_Results/figures/DOPSDispersionCurvesOnCoag.pdf', 'pdf')
end

function [allSAResults,allTimes] =processSAResults()
    numTrials = 25;
    numIters = 4000;
    allSAResults = zeros(numTrials,numIters);
    allTimes = zeros(numTrials,1);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/SA_Results/fitCoag/FuntionalValuesTrial',num2str(j),'.txt'));  
       allSAResults(j,:) =currdata(1:4000);
       currtime = load(strcat('/home/rachel/Documents/DOPS/SA_Results/fitCoag/TimesTrial',num2str(j),'.txt'));
       currtime = currtime(j);
       allTimes(j) = currtime;
    end
end

function [allDDSResults,allTimes] =processDDSResults()
    numTrials = 25;
    numIters = 4000;
    allDDSResults = zeros(numTrials,numIters);
    allTimes = zeros(numTrials,1);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/DDS_Results/fitCoag/FuntionalValuesTrial',num2str(j),'.txt'));  
       allDDSResults(j,:) =currdata(1:4000);
       currtime = load(strcat('/home/rachel/Documents/DOPS/DDS_Results/fitCoag/TimesTrial',num2str(j),'.txt'));
       currtime = currtime(j);
       allTimes(j) = currtime;
    end
end

function [allDEResults,allTimes] =processDEResults()
    numTrials = 25;
    numIters = 100;
    allDEResults = zeros(numTrials,numIters);
    allTimes = zeros(numTrials,1);
    for j = 1:numTrials
       currdata =load(strcat('/home/rachel/Documents/DOPS/DOPS/DE_Results_vY/DE_error_iter',num2str(j),'.txt'));  
       allDEResults(j,:) =currdata(j,1:100);
       currtime = load(strcat('/home/rachel/Documents/DOPS/DOPS/DE_Results_vY/DE_time_iter',num2str(j),'.txt'));
       currtime = currtime(j);
       allTimes(j) = currtime;
    end
end