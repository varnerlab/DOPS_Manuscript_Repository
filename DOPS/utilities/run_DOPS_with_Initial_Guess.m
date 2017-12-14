
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
function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=run_DOPS_with_Initial_Guess(optFunction, MAXJ,MINJ,lowerIter,upperIter,initial_guess)
    %for running DOPS with an initial parameter guess
    %clear all;
    more off;
    warning('off','all');

    %% PARAMETERS FOR SWARM SEARCH AND DYNAMICALLY DIMENSIONED SEARCH

    NP=40;    %default 40                 %Number of particles in the swarm
    NI=4000;                    %Number of iterations
    NS=5;              %default 5        %Number of sub swarms
    G=10;                      %Number of iterations after which swarms are redistributed
    r=0.2;                     %Perturbation parameter for DDS
    timeDOPS = zeros(1,upperIter-lowerIter);
    %NUMBER_TRIALS=25;          %The total number of trials 
    %%

    for i=lowerIter:upperIter
        if(i ==4)
           rng(805); 
           
        elseif(i ==5 || i ==20)
            rng(765); %let's try a different seed
        else
            rng(i); %for repeatability
        end
        fprintf('On trial %d', i);
        tstart=tic();          % 
      %  [g_best_solution(i,:),bestparticle(:,:,i),particle(:,:,:,i),fitness(:,:,i)]=DOPS_PSO(MAXJ,MINJ,NP,NI,NS,G,r);
      [g_best_solution{i},bestparticle{i},particle{i},fitness{i}, bestval_dds_swarm{i}, best_particle_dds_swarm{i},best_particles_ls{i}]=DOPS_PSO_Initial_Guess(optFunction,MAXJ,MINJ,NP,NI,NS,G,r,initial_guess);
        timeDOPS(i)=toc(tstart);
        fprintf("Time for trial %d is %f\n", i, timeDOPS(i));

       %-------This portion save results and additional results for every trial. It is optional and the user can choose the results and number of trials --------% 
       if(mod(i,1)==0)
            cmd1 = ['save  ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DOPS_solution_iter',num2str(i),'.mat bestparticle'];                                                  % The best solution vector from swarm search
            eval(cmd1)

            cmd2 = ['save  ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DOPS_particle',num2str(i),'.mat particle'];                                                           % The particle matrix - contains particle states for every iteration within the trial
            eval(cmd2)

            cmd3 = ['save  ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DOPS_fitness',num2str(i),'.mat fitness'];                                                             % The fitness matrix - contains fitness states for the corresponding particle matrix 
            eval(cmd3)

            cmd4 = ['save ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DOPS_error_iter',num2str(i),'.mat g_best_solution'];                                            % Fitness value corresponding to best solution vector from swarm search   
            eval(cmd4)

            cmd5 = ['save -ascii ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DOPS_time_iter',num2str(i),'.txt timeDOPS'];
            eval(cmd5)

            cmd6 = ['save  ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_errordds_iter',num2str(i),'.mat bestval_dds_swarm'];            % Best fitness value from DDS search 
            eval(cmd6)

            cmd7 = ['save  ../DOPS_Results/WithInitialGuess/',func2str(optFunction),'/DDSPSO_strategy1_5_swarms_results_DDSPSO_strategy1_particledds_iter',num2str(i),'.mat best_particle_dds_swarm'];   % Best solution vector from DDS search
            eval(cmd7)

       end
    end
end

