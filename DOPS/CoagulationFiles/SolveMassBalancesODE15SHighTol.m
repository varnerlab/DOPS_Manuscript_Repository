function [T,X]=SolveMassBalancesODE15SHighTol(pDataFile,TSTART,TSTOP,Ts,DFIN)


% Check to see if I need to load the datafile
if (~isempty(DFIN))
	DF = DFIN;
else
	DF = feval(pDataFile,TSTART,TSTOP,Ts,[]);
end;

% Get reqd stuff from data struct -
IC = DF.INITIAL_CONDITIONS;
TSIM = TSTART:Ts:TSTOP;
% create options for solving
%options = odeset('RelTol', 1E-4, 'AbsTol', 1E-4, 'Stats', 'off', 'NonNegative', true);
options= odeset('NonNegative',1, 'RelTol', 1E-2, 'AbsTol', 1E-3);
% Call the ODE solver - the default is ODE15s
%tic();
[T,X]=ode23t(@MassBalances,TSIM,IC,[],DF);
%toc()
return;
