function[evalCounter,functionalVal]= runCmaes(savestr,lb,ub,functionName)
    OPTS=cmaes;
    OPTS.LogModulo = 1;
    OPTS.SaveVariables = 1;
    OPTS.LogFilenamePrefix=savestr;
    OPTS.MaxFunEvals=4000; %to compare equally across methods
    OPTS.TolX=1E-16;  %'1e-11*max(insigma) % stop if x-change smaller TolX';
    %OPTS.TolUpX= '1e3*max(insigma) % stop if x-changes larger TolUpX';
    OPTS.TolFun=1E-16;% '1e-12 % stop if fun-changes smaller TolFun';
    OPTS.TolHistFun=1E-16;% '1e-13 % stop if back fun-changes smaller TolHistFun';
    OPTS.StopOnStagnation ='off';% 'on  % stop when fitness stagnates for a long time';
    %make 300 dimensional
%     lb = repmat(lb(1),300,1);
%     ub = repmat(ub(1),300,1);
    
    [X, F, E, STOP, OUT]=cmaes(functionName, lb+rand()*(ub-lb),2,OPTS);
    
    f=load(strcat(OPTS.LogFilenamePrefix, 'fit.dat'));
    evalCounter = f(:,2);
    functionalVal = f(:,6);
%     fig= plot(f(:,2), f(:,6)) %plot cmaes functional value vs iteration number
%     xlabel('Number of Functional Evaluations');
%     ylabel('Functional Value');
%     saveas(fig,'../DOPS_Results/figures/RecreateRebutalReviewer1.pdf', 'pdf')
end


   