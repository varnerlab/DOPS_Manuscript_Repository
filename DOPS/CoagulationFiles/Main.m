% Main script for running sensitvity analysis

% Setup some constants -
NPARAMETER_SETS = 100;
TSTART = 10.0;
TSTOP = 480.0;
Ts = 10;

% main parameter loop -
for loop_index = 1:NPARAMETER_SETS
	% load the datafile -
%     loop_index = [];
	DF=DataFile(TSTART,TSTOP,Ts,loop_index);

	% Run the model with the new parameter set -
	[TN,XN]=SolveMassBalancesODE15S(@DataFile,TSTART,TSTOP,Ts,DF);
% 	[TN,XN]=SolveMassBalances(@DataFile,TSTART,TSTOP,Ts,DF,[]);	

	% Run the collocation code -
	%[SA]=RunCollocation(XN,TN);
%	[SA]=RunANAJSensCode(XN,TN,Ts);
	[SA]=SolveSEqODE15S(@MassBalances,TSTART,TSTOP,Ts,XN,DF);
	
	% Dump the SA to disk -
	cmd = ['save ./ODE15S/SA_ODE_',num2str(loop_index),'.mat SA'];
	eval(cmd);
end;
