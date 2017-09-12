function DF=DataFile(TSTART,TSTOP,Ts,INDEX)
% Datafile machine generated.

% Load the stoichiometrix matrix --
S=load('Coagulation_STM.dat');
[NROWS,NCOLS]=size(S);

% Load the parameters -

% Some tmps needs to be changed -
beta=21*(1000)*(1/8.413);
T1K=37+273;
T2K=25+273;
T2K2=22+273;
CFT=exp(-beta*(1/T2K-1/T1K));
CFT2=exp(-beta*(1/T2K2-1/T1K));

% Formulate the rate constant vector k --
k=zeros(NCOLS,1);
k=[
	5e-2	% 1 VII+TF <--> VII_TF
	5e-3	% 2 VII_TF <--> VII+TF
	5e-2	% 3 VIIa+TF <--> VIIa_TF
	5e-3	% 4 VIIa_TF <--> VIIa+TF
	5e-3	% 5 Xa+VII_TF <--> Xa_VII_TF
	1.0		% 6 Xa_VII_TF <--> Xa+VII_TF
	5e-3	% 7 Xa_VII_TF <--> VIIa_TF+Xa
	3.92e-4	% 8 IIa+VII_TF <--> IIa_VII_TF
	1.0		% 9 IIa_VII_TF <--> IIa+VII_TF
	3.92e-4	% 10 IIa_VII_TF <--> VIIa_TF+IIa
	0.1		% 11 X+VIIa_TF <--> X_VIIa_TF
	5.5		% 12 X_VIIa_TF <--> X+VIIa_TF
	1.4		% 13 X_VIIa_TF <--> VIIa_TF+Xa
	0.1		% 14 IX+VIIa_TF <--> IX_VIIa_TF
	2.2		% 15 IX_VIIa_TF <--> IX+VIIa_TF
	0.47	% 16 IX_VIIa_TF <--> VIIa_TF+IXa
	0.1		% 17 VII+Xa <--> VII_Xa
	1.0		% 18 VII_Xa <--> VII+Xa
	0.5		% 19 VII_Xa <--> VIIa+Xa
	0.1		% 20 VII+IIa <--> VII_IIa
	10		% 21 VII_IIa <--> VII+IIa
	0.5		% 22 VII_IIa <--> VIIa+IIa
	0.1		% 23 V+IIa <--> V_IIa
	7.2*CFT	% 24 V_IIa <--> V+IIa
	0.26	% 25 V_IIa <--> Va+IIa
	0.1		% 26 VIII+IIa <--> VIII_IIa
	15*CFT2	% 27 VIII_IIa <--> VIII+IIa
	0.9		% 28 VIII_IIa <--> VIIIa+IIa
	0.1		% 29 Xa+IX <--> Xa_IX
	1.5		% 30 Xa_IX <--> Xa+IX
	0.023	% 31 Xa_IX <--> Xa+IXa
	0.1		% 32 Xa+V <--> Xa_V
	1.0		% 33 Xa_V <--> Xa+V
	0.043	% 34 Xa_V <--> Xa+Va
	0.1 	% 35 Xa+VIII <--> Xa_VIII
	2.1		% 36 Xa_VIII <--> Xa+VIII
	0.023	% 37 Xa_VIII <--> Xa+VIIIa
	7.5e-6	% 38 Xa+II <--> Xa_II
	1e-9	% 39 Xa_II <--> Xa+II
	7.5e-6	% 40 Xa_II <--> IIa+Xa
	0.01	% 41 IX+P9s <--> IX_P9s
	2.5e-2	% 42 IX_P9s <--> IX+P9s
	0.01	% 43 IXa+P9s <--> IXa_P9s
	2.5e-2	% 44 IXa_P9s <--> IXa+P9s
	0.01	% 45 IXa+P9s_specific <--> IXa_P9s_specific
	2.5e-2	% 46 IXa_P9s_specific <--> IXa+P9s_specific
	0.1		% 47 X+P10s <--> X_P10s
	2.5e-2	% 48 X_P10s <--> X+P10s
	0.1		% 49 Xa+P10s <--> Xa_P10s
	2.5e-2	% 50 Xa_P10s <--> Xa+P10s
	5.7		% 51 V+P5s <--> V_P5s
	0.17	% 52 V_P5s <--> V+P5s
	5.7 	% 53 Va+P5s <--> Va_P5s
	0.17	% 54 Va_P5s <--> Va+P5s
	5e-2	% 55 VIII+P8s <--> VIII_P8s
	0.17	% 56 VIII_P8s <--> VIII+P8s
	5e-2	% 57 VIIIa+P8s <--> VIIIa_P8s
	0.17	% 58 VIIIa_P8s <--> VIIIa+P8s
	0.01	% 59 II+P2s <--> II_P2s
	5.9		% 60 II_P2s <--> II+P2s
	0.01	% 61 IIa+P2s <--> IIa_P2s
	2.042	% 62 IIa_P2s <--> IIa+P2s
	0.9		% 63 PL+Psub <--> AP_Psub
	20		% 64 PL+Psub <--> PL_Psub
	0.2		% 65 AP+Psub <--> AP_Psub
	5e-7	% 66 PL+AP <--> PL_AP
	1.0		% 67 PL_AP <--> PL+AP
	5e-7	% 68 PL_AP <--> 2*AP
	5e-7	% 69 PL+AP_Psub <--> PL_AP_Psub
	1.0		% 70 PL_AP_Psub <--> PL+AP_Psub
	5e-7	% 71 PL_AP_Psub <--> AP+AP_Psub
	3e-7	% 72 PL+IIa <--> PL_IIa
	1.0		% 73 PL_IIa <--> PL+IIa
	3e-7	% 74 PL_IIa <--> AP+IIa
	3e-2	% 75 PL_Psub+IIa <--> PL_Psub_IIa
	0.01	% 76 PL_Psub_IIa <--> PL_Psub+IIa
	9e-3	% 77 PL_Psub_IIa <--> AP_Psub+IIa
	0.1		% 78 V_P5s+Xa_P10s <--> V_P5s_Xa_P10s
	1.0		% 79 V_P5s_Xa_P10s <--> V_P5s+Xa_P10s
	4.6		% 80 V_P5s_Xa_P10s <--> Va_P5s+Xa_P10s
	1.73e-2	% 81 V_P5s+IIa_P2s <--> V_P5s_IIa_P2s
	1.0		% 82 V_P5s_IIa_P2s <--> V_P5s+IIa_P2s
	4.6		% 83 V_P5s_IIa_P2s <--> Va_P5s+IIa_P2s
	0.1		% 84 X_P10s+VIIIa_P8s_IXa_P9s <--> X_P10s_VIIIa_P8s_IXa_P9s
	0.01	% 85 X_P10s_VIIIa_P8s_IXa_P9s <--> X_P10s+VIIIa_P8s_IXa_P9s
	20		% 86 X_P10s_VIIIa_P8s_IXa_P9s <--> Xa_P10s+VIIIa_P8s_IXa_P9s
	0.1		% 87 X_P10s+VIIIa_P8s_IXa_P9s_specific <--> X_P10s_VIIIa_P8s_IXa_P9s_specific
	0.01	% 88 X_P10s_VIIIa_P8s_IXa_P9s_specific <--> X_P10s+VIIIa_P8s_IXa_P9s_specific
	20		% 89 X_P10s_VIIIa_P8s_IXa_P9s_specific <--> Xa_P10s+VIIIa_P8s_IXa_P9s_specific
	0.1		% 90 VIII_P8s+Xa_P10s <--> VIII_P8s_Xa_P10s
	2.1		% 91 VIII_P8s_Xa_P10s <--> VIII_P8s+Xa_P10s
	0.023*CFT2	% 92 VIII_P8s_Xa_P10s <--> VIIIa_P8s+Xa_P10s
	0.1		% 93 VIII_P8s+IIa_P2s <--> VIII_P8s_IIa_P2s
	15*CFT2	% 94 VIII_P8s_IIa_P2s <--> VIII_P8s+IIa_P2s
	0.9		% 95 VIII_P8s_IIa_P2s <--> VIIIa_P8s+IIa_P2s
	0.1		% 96 II_P2s+Va_P5s_Xa_P10s <--> II_P2s_Va_P5s_Xa_P10s
	0.05*CFT	% 97 II_P2s_Va_P5s_Xa_P10s <--> II_P2s+Va_P5s_Xa_P10s
	30*CFT	% 98 II_P2s_Va_P5s_Xa_P10s <--> IIa_P2s+Va_P5s_Xa_P10s
	0.1		% 99 VIIIa_P8s+IXa_P9s <--> VIIIa_P8s_IXa_P9s
	0.4		% 100 VIIIa_P8s_IXa_P9s <--> VIIIa_P8s+IXa_P9s
	0.1		% 101 VIIIa_P8s+IXa_P9s_specific <--> VIIIa_P8s_IXa_P9s_specific
	0.4		% 102 VIIIa_P8s_IXa_P9s_specific <--> VIIIa_P8s+IXa_P9s_specific
	1.0		% 103 Va_P5s+Xa_P10s <--> Va_P5s_Xa_P10s
	1.0		% 104 Va_P5s_Xa_P10s <--> Va_P5s+Xa_P10s
	1e-3	% 105 IX_P9s+Xa_P10s <--> IX_P9s_Xa_P10s
	1.5		% 106 IX_P9s_Xa_P10s <--> IX_P9s+Xa_P10s
	0.023	% 107 IX_P9s_Xa_P10s <--> IXa_P9s+Xa_P10s
	0.12	% 108 APC+VIIIa_P8s <--> APC_VIIIa_P8s
	1.0		% 109 APC_VIIIa_P8s <--> APC+VIIIa_P8s
	0.5		% 110 APC_VIIIa_P8s <--> APC+VIIIa_P8s_inactive
	0.12	% 111 APC+Va_P5s <--> APC_Va_P5s
	1.0		% 112 APC_Va_P5s <--> APC+Va_P5s
	0.5		% 113 APC_Va_P5s <--> APC+Va_P5s_inactive
	0.12	% 114 APC+Va_P5s_Xa_P10s <--> APC_Va_P5s_Xa_P10s
	1.0		% 115 APC_Va_P5s_Xa_P10s <--> APC+Va_P5s_Xa_P10s
	0.5		% 116 APC_Va_P5s_Xa_P10s <--> APC+Va_P5s_Xa_P10s_inactive
	0.12	% 117 APC+VIIIa_P8s_IXa_P9s <--> APC_VIIIa_P8s_IXa_P9s
	1.0		% 118 APC_VIIIa_P8s_IXa_P9s <--> APC+VIIIa_P8s_IXa_P9s
	0.5		% 119 APC_VIIIa_P8s_IXa_P9s <--> APC+VIIIa_P8s_IXa_P9s_inactive
	0.12	% 120 APC+VIIIa_P8s_IXa_P9s_specific <--> APC_VIIIa_P8s_IXa_P9s_specific
	1.0		% 121 APC_VIIIa_P8s_IXa_P9s_specific <--> APC+VIIIa_P8s_IXa_P9s_specific
	0.5		% 122 APC_VIIIa_P8s_IXa_P9s_specific <--> APC+VIIIa_P8s_IXa_P9s_specific_inactive
	1.6e-3	% 123 TFPI+Xa <--> TFPI_Xa
	3.3e-4	% 124 TFPI_Xa <--> TFPI+Xa
	1e-3	% 125 TFPI_Xa+VIIa_TF <--> TFPI_Xa_VIIa_TF
	1.1e-3	% 126 TFPI_Xa_VIIa_TF <--> TFPI_Xa+VIIa_TF
	0.32	% 127 TFPI+Xa_VIIa_TF <--> TFPI_Xa_VIIa_TF
	1.1e-4	% 128 TFPI_Xa_VIIa_TF <--> TFPI+Xa_VIIa_TF
	4.9e-7	% 129 ATIII+IXa <--> ATIII_IXa
	1e-9	% 130 ATIII_IXa <--> ATIII+IXa
	4.9e-7	% 131 ATIII_IXa <--> ATIII+IXa_inactive
	2e-4	% 132 ATIII+Xa <--> ATIII_Xa
	1e-9	% 133 ATIII_Xa <--> ATIII+Xa
	1.5e-6	% 134 ATIII_Xa <--> ATIII+Xa_inactive
	1.5e-5	% 135 ATIII+IIa <--> ATIII_IIa
	1e-9	% 136 ATIII_IIa <--> ATIII+IIa
	4.75e-6	% 137 ATIII_IIa <--> ATIII+IIa_inactive
	1.35e-4	% 138 IIa <--> IIa_inactive
	2.5e-7	% 139 ATIII+VIIa_TF <--> VIIa_TF_ATIII
	1e-9	% 140 VIIa_TF_ATIII <--> ATIII+VIIa_TF
	1.003e-6	% 141 PC+IIa <--> PC_IIa
	1e-9	% 142 PC_IIa <--> PC+IIa
	0.01*(1/60)	% 143 PC_IIa <--> APC+IIa
	3e-2	% 144 IIa+TM <--> IIa_TM
	0.045	% 145 IIa_TM <--> IIa+TM
	1.4e-4	% 146 IIa_TM+PC <--> IIa_TM_PC
	0.5		% 147 IIa_TM_PC <--> IIa_TM+PC
	40		% 148 IIa_TM_PC <--> IIa_TM+APC
];

% Formulate the initial condition vector IC --
IC=zeros(NROWS,1);
IC=[
	0.0	%1 Xa_VII_TF
	0.0	%2 IIa_VII_TF
	0.0	%3 X_VIIa_TF
	0.0	%4 IX_VIIa_TF
	0.0	%5 VII_Xa
	0.0	%6 VII_IIa
	0.0	%7 V_IIa
	0.0	%8 VIII_IIa
	0.0	%9 Xa_IX
	0.0	%10 Xa_V
	0.0	%11 Xa_VIII
	0.0	%12 Xa_II
	0.0	%13 PL_AP
	0.0	%14 PL_AP_Psub
	0.0	%15 PL_IIa
	0.0	%16 PL_Psub_IIa
	0.0	%17 V_P5s_Xa_P10s
	0.0	%18 V_P5s_IIa_P2s
	0.0	%19 X_P10s_VIIIa_P8s_IXa_P9s
	0.0	%20 X_P10s_VIIIa_P8s_IXa_P9s_specific
	0.0	%21 VIII_P8s_Xa_P10s
	0.0	%22 VIII_P8s_IIa_P2s
	0.0	%23 II_P2s_Va_P5s_Xa_P10s
	0.0	%24 APC_VIIIa_P8s
	0.0	%25 APC_Va_P5s
	0.0	%26 APC_Va_P5s_Xa_P10s
	0.0	%27 APC_VIIIa_P8s_IXa_P9s
	0.0	%28 APC_VIIIa_P8s_IXa_P9s_specific
	0.0	%29 ATIII_IXa
	0.0	%30 ATIII_Xa
	0.0	%31 ATIII_IIa
	0.0	%32 PC_IIa
	0.0	%33 IIa_TM_PC
	0.0	%34 VII
	0.0	%35 TF
	0.0	%36 VII_TF
	0.0	%37 VIIa
	0.0	%38 VIIa_TF
	0.0	%39 IX
	0.0	%40 IXa
	0.0	%41 X
	0.0	%42 Xa
	0.0	%43 V
	0.0	%44 Va
	0.0	%45 VIII
	0.0	%46 VIIIa
	0.0	%47 II
	0.0	%48 IIa
	0.0	%49 P9s
	0.0	%50 P9s_specific
	0.0	%51 P10s
	0.0	%52 P5s
	0.0	%53 P8s
	0.0	%54 P2s
	0.0	%55 IX_P9s
	0.0	%56 IXa_P9s
	0.0	%57 IXa_P9s_specific
	0.0	%58 X_P10s
	0.0	%59 Xa_P10s
	0.0	%60 V_P5s
	0.0	%61 Va_P5s
	0.0	%62 VIII_P8s
	0.0	%63 VIIIa_P8s
	0.0	%64 II_P2s
	0.0	%65 IIa_P2s
	0.0	%66 IX_P9s_Xa_P10s
	0.0	%67 VIIIa_P8s_IXa_P9s
	0.0	%68 VIIIa_P8s_IXa_P9s_specific
	0.0	%69 Va_P5s_Xa_P10s
	0.0	%70 AP
	0.0	%71 Psub
	0.0	%72 PL
	0.0	%73 PL_Psub
	0.0	%74 AP_Psub
	0.0	%75 APC
	0.0	%76 PC
	0.0	%77 TM
	0.0	%78 IIa_TM
	0.0	%79 ATIII
	0.0	%80 VIIa_TF_ATIII
	0.0	%81 TFPI
	0.0	%82 TFPI_Xa
	0.0	%83 Xa_VIIa_TF
	0.0	%84 TFPI_Xa_VIIa_TF
	0.0	%85 IXa_inactive
	0.0	%86 Xa_inactive
	0.0	%87 IIa_inactive
	0.0	%88 VIIIa_P8s_inactive
	0.0	%89 Va_P5s_inactive
	0.0	%90 Va_P5s_Xa_P10s_inactive
	0.0	%91 VIIIa_P8s_IXa_P9s_inactive
	0.0	%92 VIIIa_P8s_IXa_P9s_specific_inactive
];

% Need to specify the index of surface species -
% This is *NOT* machine generated, so if you re-run Generate.sh you'll loose this
% modification
IDX_SURFACE=[17:28 49:69 88:92];

% Setup initial condition vector -
IC=0.000000001*rand(NROWS,1);

%IC(39,1)=90;		%39 IX
%IC(41,1)=170;		%41 X
%IC(43,1)=20;		%43 V
%IC(45,1)=0.7;		%45 VIII

% The following initial conditions are to be varied for different experiments
%IC(38,1)=0.00125; 	%38 VIIa_TF
%IC(47,1)=1700; 		%47 II
%IC(49:54,1)=50;  	%49 P9s	%50 P9s_specific %51 P10s %52 P5s %54 P2s
%IC(53,1)=(5e-10);	%53 P8s
%IC(71,1)=100;		%71 Psub
%IC(72,1)=150; 		%72 PL
%IC(76,1)=65; 		%76 PC
%IC(77,1)=10; 		%77 TM
%IC(79,1)=3400;      %79 ATIII
%IC(81,1)=5.0;       %81 TFPI

%keyboard;
NPARAMETERS=length(k);
NSTATES=length(IC);

% Ok, override the choice of parameters above, load from disk -
% if (~isempty(INDEX))
% 	cmd=['load ./psets/PSET_',num2str(INDEX),'.mat'];
% 	eval(cmd);
% 	kV = kP;
% 	
% 	% get k and IC -
% 	k=kV(1:NPARAMETERS);
% % 	IC=kV((NPARAMETERS+1):end);
% end;
kV = [k ; IC];
DF.DATA_FIG2A1=load('./sampledata/Fig2A1.txt');
DF.DATA_FIG2A4=load('./sampledata/Fig2A4.txt');
DF.DATA_FIG2B3=load('./sampledata/Fig2B3.txt');
DF.DATA_FIG2B4=load('./sampledata/Fig2B4.txt');
DF.DATA_FIG2D2=load('./sampledata/Fig2D2.txt');
DF.DATA_FIG2E1=load('./sampledata/Fig2E1.txt');


DF.EXPT_DATA_FIG2A1=load('./data_expt/Data_Fig2A1.txt');
DF.EXPT_DATA_FIG2A2=load('./data_expt/Data_Fig2A2.txt');
DF.EXPT_DATA_FIG2A3=load('./data_expt/Data_Fig2A3.txt');
DF.EXPT_DATA_FIG2A4=load('./data_expt/Data_Fig2A4.txt');
DF.EXPT_DATA_FIG2B1=load('./data_expt/Data_Fig2B1.txt');
DF.EXPT_DATA_FIG2B2=load('./data_expt/Data_Fig2B2.txt');
DF.EXPT_DATA_FIG2B3=load('./data_expt/Data_Fig2B3.txt');
DF.EXPT_DATA_FIG2B4=load('./data_expt/Data_Fig2B4.txt');
DF.EXPT_DATA_FIG2C1=load('./data_expt/Data_Fig2C1.txt');
DF.EXPT_DATA_FIG2C2=load('./data_expt/Data_Fig2C2.txt');
DF.EXPT_DATA_FIG2C3=load('./data_expt/Data_Fig2C3.txt');
DF.EXPT_DATA_FIG2D1=load('./data_expt/Data_Fig2D1.txt');
DF.EXPT_DATA_FIG2D2=load('./data_expt/Data_Fig2D2.txt');
DF.EXPT_DATA_FIG2D3=load('./data_expt/Data_Fig2D3.txt');
DF.EXPT_DATA_FIG2E1=load('./data_expt/Data_Fig2E1.txt');
DF.EXPT_DATA_FIG2E2=load('./data_expt/Data_Fig2E2.txt');
DF.EXPT_DATA_FIG2E3=load('./data_expt/Data_Fig2E3.txt');
DF.EXPT_DATA_FIG2E4=load('./data_expt/Data_Fig2E4.txt');
DF.EXPT_DATA_FIG2E5=load('./data_expt/Data_Fig2E5.txt');
DF.EXPT_DATA_FIG2F1=load('./data_expt/Data_Fig2F1.txt');
DF.EXPT_DATA_FIG2F2=load('./data_expt/Data_Fig2F2.txt');




% =========== DO NOT EDIT BELOW THIS LINE ==============
DF.STOICHIOMETRIC_MATRIX=S;
DF.RATE_CONSTANT_VECTOR=k;
DF.INITIAL_CONDITIONS=IC;
DF.INDEX_SURFACE = IDX_SURFACE;
DF.INDEX_BOUND_ACTIVATED_PLATELETS = 74;
DF.INDEX_FREE_ACTIVATED_PLATELETS = 70;
DF.NUMBER_PARAMETERS=NPARAMETERS;
DF.NUMBER_OF_STATES=NSTATES;
DF.NUMBER_OF_RATES = NPARAMETERS;
DF.PARAMETER_VECTOR=kV;
% ======================================================
return;
