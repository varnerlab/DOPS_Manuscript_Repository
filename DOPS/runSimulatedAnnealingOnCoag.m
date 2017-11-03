function [allhistory]= runSimulatedAnnealingOnCoag()
	seed = 1;
	b=load('coagBounds.mat');
	lb = b.lb;
	ub = b.ub;
   function [stop,options,optchanged] = myoutput(options,optimvalues,flag)
        stop = false;
        if isequal(flag,'iter')
              history = [history; optimvalues.fval];
            fprintf('Iter %d and functional value %f\n', optimvalues.iteration, optimvalues.fval);  
            optimvalues.iteration; %so I can see what's going on'
        end
        optchanged = false;
    end
	NUM_ITERATIONS = 2000;
	options = optimoptions(@simulannealbnd,'MaxIterations',NUM_ITERATIONS, 'OutputFcn', @myoutput);
	NUM_REPEATS = 25;
	allhistory = zeros(NUM_REPEATS, NUM_ITERATIONS+1);
	for j=10:NUM_REPEATS
        rng(j);
		fprintf("On trial %d\n", j)
		history = [];
		%create initial guess
		x0 = lb-ub.*rand(size(lb,1),1)+lb;
		tstart = tic();
		[x,fval,exitflag,output] = simulannealbnd(@fitCoag,x0,lb,ub,options);
		timeSA(j) = toc(tstart)
		%size(history) %history is one longer than number of iterations 
		cmd1= ['save -ascii ../SA_Results/fitCoag/FuntionalValuesTrial', num2str(j), '.txt history'];
		eval(cmd1)
		cmd2= ['save -ascii ../SA_Results/fitCoag/TimesTrial', num2str(j), '.txt timeSA'];
		eval(cmd2)
		allhistory(j,:) = history;
	end
end
