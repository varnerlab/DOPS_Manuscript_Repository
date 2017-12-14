
%  ----------------------------------------------------------------------------------- 
%  Copyright (c) 2016 Varnerlab
%  School of Chemical and Biomolecular Engineering
%  Cornell University, Ithaca NY 14853 USA
%
%----------------*****  Code Author Information *****----------------------
%   Code Author (Implementation Questions, Bug Reports, etc.): 
%       Adithya Sagar: asg242@cornell.edu
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
function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,DDS_iters]=run_DOPS_PSO_only(optFunction, MAXJ,MINJ,lowerIter,upperIter,numSwarms)
    %only run PSO, no DDS
    %clear all;
    more off;
    warning('off','all');

    %% PARAMETERS FOR SWARM SEARCH AND DYNAMICALLY DIMENSIONED SEARCH

    NP=40;    %default 40                 %Number of particles in the swarm
    NI=100;                    %Number of iterations
    NS=numSwarms;              %default 5        %Number of sub swarms
    G=10;                      %Number of iterations after which swarms are redistributed
    r=0.2;                     %Perturbation parameter for DDS
    
    NUMBER_TRIALS=25;          %The total number of trials 
    %%

    for i=lowerIter:upperIter
        rng(i); %for repeatability
        fprintf('On trial %d', i);
        tstart=tic();          
      [g_best_solution{i},bestparticle{i},particle{i},fitness{i}, bestval_dds_swarm{i}, best_particle_dds_swarm{i},best_particles_ls{i}]=DOPS_PSO_only(optFunction,MAXJ,MINJ,NP,NI,NS,G,r);
        timeDOPS(i)=toc(tstart);
        fprintf("Time for trial %d is %f\n", i, timeDOPS(i));

       %-------This portion save results and additional results for every trial. It is optional and the user can choose the results and number of trials --------% 
       if(~mod(i,1))
            cmd1 = ['save  ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DOPS_solution_iter',num2str(i),'.mat bestparticle'];                                                  % The best solution vector from swarm search
            eval(cmd1)

            cmd2 = ['save  ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DOPS_particle',num2str(i),'.mat particle'];                                                           % The particle matrix - contains particle states for every iteration within the trial
            eval(cmd2)

            cmd3 = ['save  ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DOPS_fitness',num2str(i),'.mat fitness'];                                                             % The fitness matrix - contains fitness states for the corresponding particle matrix 
            eval(cmd3)

            cmd4 = ['save ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DOPS_error_iter',num2str(i),'.mat g_best_solution'];                                            % Fitness value corresponding to best solution vector from swarm search   
            eval(cmd4)

            cmd5 = ['save -ascii ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DOPS_time_iter',num2str(i),'.txt timeDOPS'];
            eval(cmd5)

            cmd6 = ['save  ../DOPS_Results/PSO_Only/',func2str(optFunction),'/', num2str(NS), 'Swarms','/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(i),'.mat bestval_dds_swarm'];            % Best fitness value from DDS search 
            eval(cmd6)

       end
    end
end

