function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls,correctedAllData]=run_DOPSBasic(numFEvals,optFunction,MINJ,MAXJ,seed)
    %runs DOPS without saving results to disk
    %clear all;
    more off;
    warning('off','all');

    %% PARAMETERS FOR SWARM SEARCH AND DYNAMICALLY DIMENSIONED SEARCH

    NP=40;    %default 40                 %Number of particles in the swarm
    NI=numFEvals;                    %Number of iterations
    NS=5;              %default 5        %Number of sub swarms
    G=10;                      %Number of iterations after which swarms are redistributed
    r=0.2;                     %Perturbation parameter for DDS
    %NUMBER_TRIALS=25;          %The total number of trials 
    %%

    for i=1:1
        if(i ==4)
           rng(805,'twister'); 
        else
            rng(seed, 'twister'); %for repeatability
        end
        fprintf('On trial %d', i);
        tstart=tic();          % 
      %  [g_best_solution(i,:),bestparticle(:,:,i),particle(:,:,:,i),fitness(:,:,i)]=DOPS_PSO(MAXJ,MINJ,NP,NI,NS,G,r);
      [g_best_solution,bestparticle,particle,fitness, bestval_dds_swarm, best_particle_dds_swarm,best_particles_ls]=DOPS_PSO(str2func(optFunction),MAXJ,MINJ,NP,NI,NS,G,r);
        timeDOPS=toc(tstart);
        fprintf("Time for trial %d is %f\n", i, timeDOPS);
        PSO_error = g_best_solution;
        DDS_error = bestval_dds_swarm;
        corrected_PSO_error = fillInPSO(NP,PSO_error);
        correctedAllData = cat(2,corrected_PSO_error,DDS_error);
        correctedAllData = correctedAllData(1:NI);

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
