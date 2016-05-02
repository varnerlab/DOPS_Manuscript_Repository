
%  ----------------------------------------------------------------------------------- 
%  Copyright (c) 2016 Varnerlab
%  School of Chemical and Biomolecular Engineering
%  Cornell University, Ithaca NY 14853 USA
% 
%  Permission is hereby granted, free of charge, to any person obtaining a copy
%  of this software and associated documentation files (the "Software"), to deal
%  in the Software without restriction, including without limitation the rights
%  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%  copies of the Software, and to permit persons to whom the Software is
%  furnished to do so, subject to the following conditions:

%  The above copyright notice and this permission notice shall be included
%  in
%  all copies or substantial portions of the Software.
%  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%  THE SOFTWARE.
%  ----------------------------------------------------------------------------------- 


clear all;
more off;
warning('off','all');


bounds=load('bounds.txt');
MAXJ=bounds(:,2);
MINJ=bounds(:,1);

%% PARAMETERS FOR SWARM SEARCH AND DYNAMICALLY DIMENSIONED SEARCH

NP=40;                     %Number of particles in the swarm
NI=100;                    %Number of iterations
NS=7;                      %Number of sub swarms
G=10;                      %Number of iterations after which swarms are redistributed
r=0.2;                     %Perturbation parameter for DDS

NUMBER_TRIALS=25;          %The total number of trials 
%%

for i=1:NUMBER_TRIALS

    tstart=tic();          % 
    [g_best_solution(i,:),bestparticle(:,:,i),particle(:,:,:,i),fitness(:,:,i)]=DOPS(MAXJ,MINJ,NP,NI,NS,G,r);
    timeDOPS(i)=toc(tstart);

   %-------This portion save results for every 5 trials. It is optional and the user can choose to comment it out--------% 
   if(~mod(i,5))
        cmd1 = ['save  ./DOPS_Results/DOPS_solution_iter',num2str(i),'.mat bestparticle'];                     %The best solution vector
    	eval(cmd1)

        cmd2 = ['save  ./DOPS_Results/DOPS_particle',num2str(i),'.mat particle'];
    	eval(cmd2)

        cmd3 = ['save  ./DOPS_Results/DOPS_fitness',num2str(i),'.mat fitness'];
    	eval(cmd3)


		cmd4 = ['save -ascii ./DOPS_Results/DOPS_error_iter',num2str(i),'.txt g_best_solution'];
    	eval(cmd4)


		cmd5 = ['save -ascii ./DOPS_Results/DOPS_time_iter',num2str(i),'.txt timeDDSPSO'];
    	eval(cmd5)

   end
end

save ./DOPS_Results/DOPS_solution.mat bestparticle;
save ./DOPS_Results/DOPS_particle.mat particle;
save ./DOPS_Results/DOPS_fitness.mat fitness;

save -ascii ./DOPS_Results/DOPS_error.txt g_best_solution;
save -ascii ./DOPS_Results/DOPS_time.txt timeDOPS;
