function [T,X]=SolveMassBalancesODE15S(pDataFile,TSTART,TSTOP,Ts,DFIN)


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
%options = odeset('RelTol', 1E-3, 'AbsTol', 1E-4, 'Stats', 'off');

% Call the ODE solver - the default is ODE15s
%tic();
[T,X]=ode15s(@MassBalances,TSIM,IC,[],DF);
%toc()
return;
