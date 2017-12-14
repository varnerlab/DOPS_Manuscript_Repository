function[fvals,inital_vals]=runDE(seed)
    % VTR		"Value To Reach" (stop when ofunc < VTR)
            VTR = -Inf; 

    % D		number of parameters of the objective function 
            D = 2; 

    % XVmin,XVmax   vector of lower and bounds of initial population
    %    		the algorithm seems to work well only if [XVmin,XVmax] 
    %    		covers the region where the global minimum is expected
    %               *** note: these are no bound constraints!! ***
            XVmin = [-2 -2]; 
            XVmax = [2 2];

    % y		problem data vector (remains fixed during optimization)
            y=[]; 

    % NP            number of population members
            NP = 40; %to match with DOPS 

    % itermax       maximum number of iterations (generations)
            itermax = 200; 

    % F             DE-stepsize F ex [0, 2]
            F = 0.8; 

    % CR            crossover probabililty constant ex [0, 1]
            CR = 0.9; 

    % strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
    %                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
    %                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
    %                4 --> DE/best/2/exp           9 --> DE/best/2/bin
    %                5 --> DE/rand/2/exp           else  DE/rand/2/bin

            strategy = 1;

    % refresh       intermediate output will be produced after "refresh"
    %               iterations. No intermediate output will be produced
    %               if refresh is < 1
            refresh = 0; 
    poss_iter_nums =[40,2000,4000];
    functions_to_test = {'ackley', 'rast', 'rast'};
    bounds = {[30;-15], [5.12;-5.12], [5.12;-5.12]};
    dimensions =[10,10,300];
    best_params = {};
    fvals = zeros(size(dimensions,2),size(functions_to_test,2));
    inital_vals = zeros(size(dimensions,2), size(functions_to_test,2));
    for k=1:size(poss_iter_nums,2)
        for j =1:size(functions_to_test,2)            
            currlimits = bounds{j};
            MAXJ = repmat(currlimits(1),dimensions(j),1);
            MINJ = repmat(currlimits(2), dimensions(j),1);
            rng(seed);
            [x_init,f_init,nf_init] = devec3(functions_to_test{j},VTR,dimensions(j),MINJ',MAXJ',y,NP,1,F,CR,strategy,refresh);
            rng(seed+2);
            [x,f,nf] = devec3(functions_to_test{j},VTR,dimensions(j),MINJ',MAXJ',y,NP,poss_iter_nums(k)/NP,F,CR,strategy,refresh);
            fvals(j,k) = f;
            inital_vals(j,k)=f_init;
        end
    end
end