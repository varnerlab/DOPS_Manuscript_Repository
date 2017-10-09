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

%% SWARM SEARCH WITH ADAPTIVE SWITCHING STRATEGY

function[g_best_solution,bestparticle,particle,fitness,num_iters_remaining]=DOPS_PSO_ExperimentalV2(optFunction,MAXJ,MINJ,NP,NI,NS,G,r, initial_guess)
if(nargin ==8)
   initial_guess = []; 
end
fprintf('In PSO. NI = %d\n', NI);
global num_method_switches;
global best_PSO_val;        %keep track of best functional value found by PSO
global best_DDS_val;        %keep track of best functional value found by DDS
global best_PSO_x;          % keep track of best parameters found by PSO
global best_DDS_x;          %keep track of best parameters found by DDS
global solve_tol;
% Parameters for swarm search
Max_Inertia_weight=0.9;
Min_Inertia_weight=0.4;
C1=1.5;C2=1.5;
N=length(MINJ);
SUB_SWARM_SIZE=round(NP/NS);
failure_counter=0;
failure_counter_threshold=4;
dds_swarm_flag=0;
%placeholders
bestval_dds_swarm=[];
best_particle_dds_swarm=[];
best_particles_ls=[];
g_best_solution=[];bestparticle=[];particle=[];fitness = [];
%%
%Initializing the position of the particles within the swarms

if(size(initial_guess,1)==0) %if we're on the initial iteration and don't have a guess
    for i=1:NP
        Z(:,i)=MINJ+(MAXJ-MINJ).*rand(N,1);                                         
        [Z(:,i)]=bind(Z(:,i),MINJ,MAXJ);                                        %Restricting the perturbation to be amongst the bounds specified    
        particle(:,1,i)=Z(:,i);                          
        fitness(i,1)=fit(particle(:,1,i),optFunction);   %was fit7, now just fit                                  %Calculating fitness of each particle
    end
else
    if(best_DDS_val<best_PSO_val)       %if we've improved using DDS
        for i = 1:NP
           Z(:,i)  =best_DDS_x;%.*(MAXJ-MINJ).*rand(N,1).*1/(10*num_method_switches);%.*1/(num_method_switches); 
           [Z(:,i)] = bind(Z(:,i), MINJ, MAXJ);
           particle(:,1,i)=Z(:,i);  
            fitness(i,1)=fit(particle(:,1,i),optFunction);
                                     %peturbation gets smaller as we've switched back more times
        end
    else
        for i =1:NP
            Z(:,i)  =best_PSO_x;%.*(MAXJ-MINJ).*rand(N,1).*1/(10*num_method_switches);%.*1/(num_method_switches); 
           [Z(:,i)] = bind(Z(:,i), MINJ, MAXJ);
           particle(:,1,i)=Z(:,i);  
           fitness(i,1)=fit(particle(:,1,i),optFunction);
        end
    end
end


%Columns of S matrix have the indices of the particles in each swarm - NS*SUB_SWARM_SIZE matrix
[S]=newswarms(NP,NS,SUB_SWARM_SIZE);

%Finding particle best and global best after initialization within each sub
%swarm
for j=1:NS %was NS, now NS-1
    index_particle=S(:,j);

    [ls_pbest_solution(j,:),ls_ITER(j,:)]=particlebest(fitness(index_particle,:));
    [ls_gbest_solution(j),temp_particlenumber]=globalbest(ls_pbest_solution(j,:));
    particlenumber(j)=index_particle(temp_particlenumber);
end

%Finding the best solution among all the swarms
[g_best_solution(1),swarmnumber]=globalbest(ls_gbest_solution);
bestparticle(:,1)=particle(:,ls_ITER(swarmnumber(1),S(:,swarmnumber(1))==particlenumber(swarmnumber(1))),particlenumber(swarmnumber(1)));
if(g_best_solution(1)<best_PSO_val) %are we better than our global min?
    best_PSO_val = g_best_solution(1);
    best_PSO_x = bestparticle(:,1);
end
bestparticle_index(1)=find(S(:,swarmnumber(1))==particlenumber(swarmnumber(1)));
fprintf('Global best is %f and iteration is %d \n',g_best_solution(1),1);

%NI = NI -1; %first iteration complete
%Particle update
for j=2:NI
    
w(j)=((NI - j)*(Max_Inertia_weight - Min_Inertia_weight))/(NI-1) + Min_Inertia_weight;         

%Consider if particles need to reassigned to other swarms
    if(0==mod(j,G))
        [S]=newswarms(NP,NS,SUB_SWARM_SIZE);
        for k=1:NS
            index_particle=S(:,k);

            %Find particle best and global best after initialization within each sub swarm
            [ls_pbest_solution(k,:),ls_ITER(k,:)]=particlebest(fitness(index_particle,:));
            [ls_gbest_solution(k),temp_particlenumber]=globalbest(ls_pbest_solution(k,:));
            particlenumber(k)=index_particle(temp_particlenumber);
        end

    end

    %%Particle update within sub-swarm 
    for k=1:NS
        index_particle=S(:,k);
        
        %Indicates the dimensions of particle that are being perturbed.
        %All dimensions are being perturbed within swarm search.
        %An alternative implementation would be perturbing a subset of
        %dimnensions within swarch search as well
        J=1:N;                                                                              

        for i=1:length(index_particle)

            temp=particle(:,j-1,index_particle(i));
            a1=particle(:,j-1,index_particle(i));
            a2=particle(:,ls_ITER(k,i),index_particle(i));
            a4=particle(:,ls_ITER(k,index_particle==particlenumber(k)),particlenumber(k));

            
              
            temp(J)=w(j)*a1(J)+(C1.*rand).*(a2(J)-a1(J))+(C2.*rand).*(a4(J)-a1(J));                        % Perturb the particle based on particle best and global best within the sub-swarm

            temp=bind(temp,MINJ,MAXJ);                                                                     % Ensure perturbed solution remains within the bounds   
            
            particle(:,j,index_particle(i))=temp;   
            fitness(index_particle(i),j)=fit(temp,optFunction);

            [ls_pbest_solution(k,:),ls_ITER(k,:)]=particlebest(fitness(index_particle,:));                 % Find the local particle best 
            [ls_gbest_solution(k),temp_particlenumber]=globalbest(ls_pbest_solution(k,:));                 % Find the local global best 
            particlenumber(k)=index_particle(temp_particlenumber);

        end
    end
    
    %Find the best particles within each swarm
    for k=1:NS
        best_particles_ls(:,k)=particle(:,ls_ITER(k,(S(:,k)==particlenumber(k))),particlenumber(k));
    end
    
    
    %Finding the best solution among all the swarms-keeping a track of
    %swarmnumber here and the index of the particle in the swarm. This
    %helps in calculation of failure counter and success counter

    [g_best_solution(j),swarmnumber(j)]=globalbest(ls_gbest_solution);
    bestparticle(:,j)=particle(:,ls_ITER(swarmnumber(j),S(:,swarmnumber(j))==particlenumber(swarmnumber(j))),particlenumber(swarmnumber(j)));
    bestparticle_index(j)=find(S(:,swarmnumber(j))==particlenumber(swarmnumber(j)));
    if(g_best_solution(j)< best_PSO_val)
        best_PSO_val =g_best_solution(j);
        best_PSO_x = bestparticle(:,j);
    end
    num_iters_remaining = NI-j*NP;
    fprintf('Global best is %f and iteration is of PSO %d \n',g_best_solution(j),j);

    %Check here if global best is not changing

    if((g_best_solution(j)==g_best_solution(j-1))||(g_best_solution(j)>(0.99*g_best_solution(j-1))))
      failure_counter=failure_counter+1;
    else
      failure_counter=0;
    end
   fprintf('In PSO. On iteration %d of %d failture counter = %d\n', i, NI, failure_counter);
    %Switch to DDS search if the solution has stagnated
    if(failure_counter > failure_counter_threshold)
       return;  
    end

end
end



%% DETERMINE PARTICLE BEST AND GLOBAL BEST 
%Particle best: Best fitness found by the particle in OR "trauma-induced coagulopat all iterations 
%Global best  : Best fitness found by all particles in all iterations

function[pbest_solution,ITER]=particlebest(fitn)
[pbest_solution,ITER]=min(fitn,[],2);
end

function[gbest_solution,particlenumber]=globalbest(par)
[gbest_solution,particlenumber]=min(par);
end

%% ASSIGN PARTICLES TO DIFFERENT SUB-SWARMS
function [S]=newswarms(NP,NS,SUB_SWARM_SIZE)
K=randperm(NP);
S(:,1)=K(1:SUB_SWARM_SIZE);
size(S)
    for i=2:NS %was ns, changed to NS-1
        diff=setdiff(K,S(:,i-1));
        idx=randperm(length(diff));
        diffperm=diff(idx);
        S(:,i)=diffperm(1:SUB_SWARM_SIZE);
        K=diff;
    end
end

%% BOUND FUNCTION - ENSURE SOLUTION IS WITHIN BOUNDS

function [x]=bind(x,MINJ,MAXJ)

	JMIN_NEW=find(x<MINJ);
	x(JMIN_NEW)=MINJ(JMIN_NEW)+(MINJ(JMIN_NEW)-x(JMIN_NEW));

	JTEMP1=find(x(JMIN_NEW)>MAXJ(JMIN_NEW));
	x(JTEMP1)=MINJ(JTEMP1);

	JMAX_NEW=find(x>MAXJ);
	x(JMAX_NEW)=MAXJ(JMAX_NEW)-(x(JMAX_NEW)-MAXJ(JMAX_NEW));

	JTEMP2=find(x(JMAX_NEW)<MINJ(JMAX_NEW));
	x(JTEMP2)=MAXJ(JTEMP2);

	CHKMAX=find(x>MAXJ);
	x(CHKMAX)=MINJ(CHKMAX);

	CHKMIN=find(x<MINJ);
	x(CHKMIN)=MAXJ(CHKMIN);
end

