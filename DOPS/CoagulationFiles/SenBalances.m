function [DSDT]=SenBalances(t,X,JM,BM)
		DSDT = JM*X + BM;

return;
