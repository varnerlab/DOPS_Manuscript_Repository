function [DXDT]=MassBalances(t,x,DF)
% This file is machine generated. Plz don't change. I know who you are...
% 
% global DF;
% global IDX_BOUND_PLATELETS;
% global IDX_FREE_PLATELETS;
% global IDX_SURFACE;
% global S;


% Get some stuff from the data struct -
S = DF.STOICHIOMETRIC_MATRIX;
IDX_SURFACE = DF.INDEX_SURFACE;
IDX_BOUND_PLATELETS = DF.INDEX_BOUND_ACTIVATED_PLATELETS;
IDX_FREE_PLATELETS = DF.INDEX_FREE_ACTIVATED_PLATELETS;

% Need to correct the surface species as thier volume
% basis is platelets
[xM]=ModifyState(t,x,DF);
% [xM]=ModifyStateFunction(x,t);
% xM=x;
% Call the kinetics
[rV]=Kinetics(t,xM,DF);

% Calculate the input vector
[uV]=Inputs(t,xM,DF);

% Calculate DXDT
DXDT = S*rV+uV;

% return to caller

return;
