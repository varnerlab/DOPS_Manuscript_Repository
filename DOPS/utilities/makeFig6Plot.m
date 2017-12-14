function makeFig6Plot(allcurve1, allcurve2,allcurve3,DFIN)
    %plot coagulation curves for figure 6
    close('all');
    f = figure();
    plot(mean(allcurve1,1), 'k');
    hold('on')
    plot(mean(allcurve2,1), 'k');
    plot(mean(allcurve3,1), 'k');
    numRepeats = 25;
    top1 = mean(allcurve1,1)+ 2.58*std(allcurve1,1)/sqrt(numRepeats);
    bottom1 = mean(allcurve1,1)- 2.58*std(allcurve1,1)/sqrt(numRepeats);
    x = 1:1:250;
    idx = find(bottom1<0);
    bottom1(idx) = 0; %remove things less than 0
    fill([x,fliplr(x)],[top1, fliplr(bottom1)], [.25, .25, .25],'facealpha', .5)
    top2 = mean(allcurve2,1)+ 2.58*std(allcurve2,1)/sqrt(numRepeats);
    bottom2 = mean(allcurve2,1)- 2.58*std(allcurve2,1)/sqrt(numRepeats);
    x = 1:1:250;
    idx = find(bottom2<0);
    bottom2(idx) = 0; %remove things less than 0
    fill([x,fliplr(x)],[top2, fliplr(bottom2)], [.25, .25, .25], 'facealpha', .5)
    top3 = mean(allcurve3,1)+ 2.58*std(allcurve3,1)/sqrt(numRepeats);
    bottom3 = mean(allcurve3,1)- 2.58*std(allcurve3,1)/sqrt(numRepeats);
    x = 1:1:250;
    idx = find(bottom3<0);
    bottom3(idx) = 0; %remove things less than 0
    fill([x,fliplr(x)],[top3, fliplr(bottom3)], [.25, .25, .25],'facealpha', .5)
    DATA1 = DFIN.EXPT_DATA_FIG2E2;
    DATA2 = DFIN.EXPT_DATA_FIG2E3;
    DATA3 = DFIN.EXPT_DATA_FIG2E4;
    plot(DATA1(:,1), DATA1(:,2), 'b.', 'MarkerSize', 12);
    plot(DATA2(:,1), DATA2(:,2), 'm.', 'MarkerSize',12);
    plot(DATA3(:,1), DATA3(:,2), '.', 'MarkerSize',12, 'MarkerFaceColor', [238/256,118/256,0]);
   % legend('10pm Trigger', '50pm Trigger', '500pm Trigger')
    axis([0,200,0,1600])
    xlabel('Time (seconds)')
    ylabel('Thombin Concentration (nM)')
    f.PaperPositionMode = 'auto';
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 8 7];
    print('../DOPS_Results/figures/ReplicateFigure5DivBySqrtN.pdf', '-dpdf','-r0');
end
