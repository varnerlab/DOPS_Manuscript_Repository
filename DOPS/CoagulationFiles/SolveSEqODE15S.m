function [SU]=SolveSEqODE15S(pMassBalances,TSTART,TSTOP,Ts,STATES,DFIN)
	% Check to see if I need to load the datafile
	if (~isempty(DFIN))
		DF = DFIN;
	else
		DF = feval(pDataFile,TSTART,TSTOP,Ts);
	end;

	% Get reqd stuff from data struct -
	IC = DF.INITIAL_CONDITIONS;
	
	% Get the number of time steps -
	TSIM=TSTART:Ts:TSTOP;
	NSTEPS=length(TSIM);
	
	NSTATES=size(STATES,2);
    
	% Get the number of parameters --
	NPARAMETERS_k=DF.NUMBER_PARAMETERS;
	
	% Total number of states -
	NPARAMETERS = NPARAMETERS_k+NSTATES;
	
	% Initialize the sensitvity array -
	SU = zeros(NSTATES,NPARAMETERS);
    SX = zeros(NSTATES,NPARAMETERS);
    SI = zeros(NSTATES,NPARAMETERS);
	
	% Ok, main loop -
	for step_index=1:NSTEPS-1
		
		% First thing, we need calculate the Jacobian and P matrix at this point -
		% Set the 'nominal' values -
		TN=TSIM(step_index+1);
		XN=STATES(step_index+1,:); 
	
		% Calculate the parameter sensitvity matrix -
		[BM]=CalculatePMatrixLSQ(pMassBalances,TN,XN,DF);
	
		% Calculate the Jacobian -
		[JM]=CalculateJacobianLSQ(pMassBalances,TN,XN,DF);
		
		% Ok, so now we have enough to take a Sensitvity step -
		
		% Get dimensions -
		NSTATES=size(JM,1);
		NPARAMETERS=size(BM,2);
		
		% Formulate the matrices in the sensitivity Mass Balances -
% 		[DSDT] = JM*SX + BM;
		%keyboard;
        SI = SU(NSTATES*(step_index-1)+1:NSTATES*step_index,:);
		
		% Call the ODE solver - the default is ODE15s
        for ode_index = 1: NPARAMETERS
		[T,X]=ode15s(@SenBalances,[TSIM(step_index),TN],SI(:,ode_index),[],JM,BM(:,ode_index));
        SX(:,ode_index) = transpose(X(end,:));
        end
		SU=[SU ; SX];
	
		msg=['Doing inversion step - ',num2str(step_index),' of ',num2str(NSTEPS)];
		disp(msg);
		
		%keyboard;
	end;
return;


