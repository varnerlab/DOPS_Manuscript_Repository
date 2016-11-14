function [x]=ModifyState(t,x,DF)

% Get the index of surface species -
IDX_SURFACE = DF.INDEX_SURFACE;
IDX_BOUND_PLATELETS = DF.INDEX_BOUND_ACTIVATED_PLATELETS;
IDX_FREE_PLATELETS = DF.INDEX_BOUND_ACTIVATED_PLATELETS;

% Ok, so I need to correct all the surface species
% by multiplying by the bound activated platelet concentration
N=length(IDX_SURFACE);
PLA = x(IDX_BOUND_PLATELETS)+x(IDX_FREE_PLATELETS);
for state_index=1:N
	x(IDX_SURFACE(state_index))=x(IDX_SURFACE(state_index))*PLA;
end;
return;
