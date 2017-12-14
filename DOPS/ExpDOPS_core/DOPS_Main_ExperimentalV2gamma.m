function [ g_best_solution,bestparticle,particle,fitness, bestval_dds_swarm, best_particle_dds_swarm,best_particles_ls,DDS_iters] =DOPS_Main_ExperimentalV2gamma( optFunction,MAXJ,MINJ,NP,NI,NS,G,r)
%to switch back between PSO and DDS in experimental version of DOPS
    global best_PSO_val;        %keep track of best functional value found by PSO
    global best_DDS_val;        %keep track of best functional value found by DDS
    global best_PSO_x;          % keep track of best parameters found by PSO
    global best_DDS_x;          %keep track of best parameters found by DDS
    global num_method_switches; %keep track of how many times we've switched methods
    global solve_tol;
num_iters_remaining = NI;
g_best_solution=[];
bestparticle=[];
particle=[];
fitness=[]; 
bestval_dds_swarm=[]; best_particle_dds_swarm=[];best_particles_ls = [];
DDS_iters = [];
count = 0;
while((num_iters_remaining > 0) && size(g_best_solution,2)<NI)
    %call PSO, first time without feeding back guess
    if(count ==0)
        [g_best_solution_r,bestparticle_r,particle_r,fitness_r,num_iters_remaining] = DOPS_PSO_ExperimentalV2gamma(optFunction,MAXJ,MINJ,NP,num_iters_remaining,NS,G,r);
    else
        if(num_iters_remaining == 1)
            %so that PSO will actually run
            num_iters_remaining = 2;
        end
        [g_best_solution_r,bestparticle_r,particle_r,fitness_r,num_iters_remaining] = DOPS_PSO_ExperimentalV2gamma(optFunction,MAXJ,MINJ,NP,num_iters_remaining,NS,G,r,IC);
    end
    if(size(g_best_solution,2)>NI)
        break;
    end
    %concat results
    filled_in_g_best_solution=fillInPSO(NP,g_best_solution_r);
    g_best_solution = cat(2,g_best_solution,filled_in_g_best_solution);
    
    bestparticle =cat(2,bestparticle,bestparticle_r);
    particle = cat(2,particle, particle_r);
    fitness = cat(2,fitness,fitness_r);
    if(count~=0)
        if(best_DDS_val<best_PSO_val)
           IC = best_DDS_x;
        else
            IC = best_PSO_x;
        end
    else
        IC = bestparticle(:,end);
    end
    
    %call DDS
    fprintf('Switching to DDS %d iters remaining.\n', num_iters_remaining);
    DDS_iters = cat(2,DDS_iters,num_iters_remaining);
    [bestval_dds_swarm_r,best_particle_dds_swarm_r,num_iters_remaining]=DOPS_DDS_ExperimentalV2gamma(optFunction,IC,MAXJ,MINJ,r,num_iters_remaining);
    DDS_iters = cat(2,DDS_iters,num_iters_remaining);
    %concat results
    g_best_solution = cat(2,g_best_solution, bestval_dds_swarm_r);
    bestparticle = cat(2,bestparticle,best_particle_dds_swarm_r);
    bestval_dds_swarm=cat(2,bestval_dds_swarm, bestval_dds_swarm_r);
    best_particle_dds_swarm =cat(2,best_particle_dds_swarm, best_particle_dds_swarm_r);
    count = count+1;
    if(count~=0)
        if(best_DDS_val<best_PSO_val)
           IC = best_DDS_x;
        else
            IC = best_PSO_x;
        end
    end
    if(size(g_best_solution,2)>NI)
        break;
    end
end
g_best_solution = g_best_solution(1:NI); %trim off end, if neccessary

end

function[filledInData]=fillInPSO(numParticles,PSO_error)
    filledInData = zeros(1,numParticles*size(PSO_error,2));
    lowerIdx = 1;
    upperIdx = numParticles;
    for j=1:size(PSO_error,2)
        filledInData(lowerIdx:upperIdx)=PSO_error(j);
        lowerIdx=upperIdx;
        upperIdx = upperIdx+numParticles;
    end
end

