function [allhistory]= runPSOOnCoag()
	seed = 1;
	b=load('coagBounds.mat');
	lb = b.lb;
	ub = b.ub;
   function [stop] = myoutput(optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.meanfval];
              besthistory =[besthistory;optimvalues.bestfval];
		optimvalues.iteration %so I can see what's going on'
        end
        optchanged = false;
    end
	NUM_ITERATIONS = 4000;
	options = optimoptions('particleswarm','MaxIterations',NUM_ITERATIONS, 'OutputFcn', @myoutput, 'SwarmSize',40, 'UseParallel', true);
	NUM_REPEATS = 25;
	allhistory = [];
	for j=1:NUM_REPEATS
		fprintf("On trial %d\n", j)
		history = [];
        besthistory=[];
		%create initial guess
        rng(j,'twister');
		x0 = lb-ub.*rand(size(lb,1),1)+lb;
		tstart = tic();
		[x,fval,exitflag,output] = particleswarm(@fitCoag,size(lb,1),lb,ub,options);
		timeSA(j) = toc(tstart)
		size(history) %history is one longer than number of iterations 
		cmd1= ['save -ascii ../PSO_Results/fitCoag/MeanFuntionalValuesTrial', num2str(j), '.txt history'];
		eval(cmd1)
		cmd2= ['save -ascii ../PSO_Results/fitCoag/TimesTrial', num2str(j), '.txt timeSA'];
		eval(cmd2)
        cmd3= ['save -ascii ../PSO_Results/fitCoag/BestFuntionalValuesTrial', num2str(j), '.txt besthistory'];
		eval(cmd3)
		%allhistory(j,:) = history;
	end
end
