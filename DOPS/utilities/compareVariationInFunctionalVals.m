function []=compareVariationInFunctionalVals(functionName)
    %for the supplimental figures-this function compares the variation in
    %functional values between the different trials of the various methods
    numRepeats = 25;
    close('all');
    CMAES_f = zeros(1,numRepeats);
    DDS_f = zeros(1,numRepeats);
    DOPS_f = zeros(1,numRepeats);
    ESS_f = zeros(1,numRepeats);
    SA_f = zeros(1,numRepeats);
    DE_f = zeros(1, numRepeats);
    
    %read in functional values or regenerate if cheap to evaluate
    if(strcmp('ackley',functionName) || strcmp('rast',functionName))
       [allCMAES,allSA,allDE,allDDS,allDOPS,allESS]= replicateFigureS4(functionName,numRepeats);
       for j = 1:numRepeats
          CMAES_f(j) = allCMAES(end,j);
          SA_f(j) = allSA(end,j);
          DE_f(j)=allDE(end,j);
          DDS_f(j) = allDDS(end,j);
          DOPS_f(j) = allDOPS(end,j);
          ESS_f(j) = allESS(end,j);
       end
    end
    
    if(strcmp('b4_obj', functionName))
        for j =1:numRepeats
            load(strcat('../ESS_Results/b4_obj/functionalInterpIter', num2str(j), '.mat'));
            ESS_f(j) = f_interp(end);
            load(strcat('../DOPS_Results/b4_obj/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter' ,num2str(j), '.mat'));
            DDS_error = bestval_dds_swarm{j};
            DOPS_f(j) = DDS_error(end);
        end
    end
    
   if(strcmp('fitCoag', functionName))
        for j =1:numRepeats
          %  load(strcat('../ESS_Results/fitCoag/functionalInterpIter', num2str(j), '.mat'));
          %  ESS_f(j) = f_interp(end);
            try
                load(strcat('../DOPS_Results/fitCoag/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter' ,num2str(j), '.mat'));
                DDS_error = bestval_dds_swarm{j};
            catch    
                DDS_error = 0;
            end
            DOPS_f(j) = DDS_error(end);
            
            f=load(strcat('../SA_Results/fitCoag/FuntionalValuesTrial', num2str(j), '.txt'));
            SA_f(j) = f(end);
            f=load(strcat('../DDS_Results/fitCoag/FuntionalValuesTrial', num2str(j), '.txt'));
            DDS_f(j) = f(end);
            
        end
    end
    
    f=figure();
    boxplot([CMAES_f', SA_f', DE_f', DDS_f', ESS_f', DOPS_f']);
    xticklabels({'CMAES', 'SA', 'DE', 'DDS', 'ESS', 'DOPS'})
    xlabel('Algorithm', 'FontSize', 32)
    ylabel('Best Objective Functional Value', 'FontSize', 32);
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 12 12];
    f.PaperSize=[13 13];
    set(gca, 'FontSize', 20);
    if (strcmp('ackley',functionName))
         print('../DOPS_Results/figures/FigureS7a.png', '-dpng','-r0');
    elseif(strcmp('rast',functionName))
        print('../DOPS_Results/figures/FigureS7b.png', '-dpng','-r0');
    elseif(strcmp('b4_obj', functionName))
        xlim([4.5,6.5]); %only show data for DOPS and ESS
        print('../DOPS_Results/figures/FigureS7c.png', '-dpng','-r0');
    elseif(strcmp('fitCoag', functionName))
        print('../DOPS_Results/figures/FigureS7d.png', '-dpng','-r0');
    end
end