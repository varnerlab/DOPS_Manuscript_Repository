function[]=runDEforCoag()
clear all;
more off;
warning('off','all');

bounds=load('coagBounds.mat'); %Bounds on the rate constants
MAXJ=bounds.ub';
MINJ=bounds.lb';


%se=load('randnseed.txt');
%randn('seed',se);
%rand('seed',se);

ctl.XVmin = MINJ;
ctl.XVmax = MAXJ;
ctl.constr= 0;
ctl.const = [];
ctl.NP    = 40;         % NP will be set later
ctl.F     = 0.8;
ctl.CR    = 0.9;
ctl.strategy = 1;
ctl.refresh  = 0;
ctl.VTR   = -Inf;
ctl.tol   = 0;
ctl.maxnfe  = 4000;
%ctl.maxiter = 100;


%pop=load('pop_b5.mat');
pop= load('CoagPop.mat');
pop=permute(pop.pop, [1,3,2]);


for i=1:1
    Z=pop(:,:,1); 
    N = max(size(MINJ));
    Z=MINJ+(MAXJ-MINJ).*rand(ctl.NP,N);   
    %IC=Z(:,i);
    rng(i);
    tstart=tic();
    [bestparticle(:,:,i),g_best_solution(i,:),nfeval(i,:)]=de(@fitCoag,Z,MINJ', MAXJ', ctl.maxnfe);
    timeDE(i)=toc(tstart);

   if(mod(i,1)==0)
        cmd1 = ['save  ./DE_Results_vY/DE_solution_iter',num2str(i),'.mat bestparticle'];
        eval(cmd1)


        cmd2 = ['save -ascii ./DE_Results_vY/DE_error_iter',num2str(i),'.txt g_best_solution'];
        eval(cmd2)


        cmd3 = ['save -ascii ./DE_Results_vY/DE_time_iter',num2str(i),'.txt timeDE'];
        eval(cmd3)


   end


end

save ./DE_Results_vY/DE_solution.mat bestparticle;
save -ascii ./DE_Results_vY/DE_error.txt g_best_solution;
save -ascii ./DE_Results_vY/DE_time.txt timeDE;

end
