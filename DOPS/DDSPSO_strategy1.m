%Particle swarm optimization that implements dynamically dimensioned search

function[g_best_solution,bestparticle,particle,fitness,bestval_dds_swarm,best_particle_dds_swarm,best_particles_ls]=DDSPSO_strategy1(MAXJ,MINJ,NP,NI,NS,G,r)


%se=load('randnseed.txt');
%randn('seed',se);
%rand('seed',se);

init=0;
Max_Inertia_weight=0.9;
Min_Inertia_weight=0.4;
C1=1.5;C2=1.5;
beta=3.3;
N=length(MINJ);
SUB_SWARM_SIZE=round(NP/NS);
failure_counter=0;
success_counter=0;

success_counter_threshold=4;
failure_counter_threshold=4;
rho(:,1)=ones(length(MINJ),1);
dds_swarm_flag=0;
%FR=0.4; %Fraction of iterations in DDSMLSPSO

%Initializing the position of the particles within the swarms


for i=1:NP
    %Restricting the perturbation to be amongst the bounds specified
    Z(:,i)=MINJ+(MAXJ-MINJ).*rand(N,1);
    [Z(:,i)]=bind(Z(:,i),MINJ,MAXJ);
    %Calculating the cost
    particle(:,1,i)=Z(:,i);
    fitness(i,1)=fit7(particle(:,1,i));

end


%Columns of S matrix have the indices of the particles in each swarm - NS*SUB_SWARM_SIZE matrix
[S]=newswarms(NP,NS,SUB_SWARM_SIZE);
velocity=0.729*particle;

%Finding particle best and global best after initialization within each sub
%swarm
for j=1:NS
    index_particle=S(:,j);

    [ls_pbest_solution(j,:),ls_ITER(j,:)]=particlebest(fitness(index_particle,:));
    [ls_gbest_solution(j),temp_particlenumber]=globalbest(ls_pbest_solution(j,:));
    particlenumber(j)=index_particle(temp_particlenumber);
end

%Finding the best solution among all the swarms
[g_best_solution(1),swarmnumber]=globalbest(ls_gbest_solution);
bestparticle(:,1)=particle(:,ls_ITER(swarmnumber(1),S(:,swarmnumber(1))==particlenumber(swarmnumber(1))),particlenumber(swarmnumber(1)));
bestparticle_index(1)=find(S(:,swarmnumber(1))==particlenumber(swarmnumber(1)));
fprintf('Global best is %f and iteration is %d \n',g_best_solution(1),1);



%Particle update
%for j=2:(FR)*NI
for j=2:NI

w(j)=((NI - j)*(Max_Inertia_weight - Min_Inertia_weight))/(NI-1) + Min_Inertia_weight;
%w(j)=1;
%Consider if particles need to reassigned to other swarms
    if(~mod(j,G))
        [S]=newswarms(NP,NS,SUB_SWARM_SIZE);
        for k=1:NS
            index_particle=S(:,k);

            %Finding particle best and global best after initialization
            %within each sub swarm
            [ls_pbest_solution(k,:),ls_ITER(k,:)]=particlebest(fitness(index_particle,:));
            [ls_gbest_solution(k),temp_particlenumber]=globalbest(ls_pbest_solution(k,:));
            particlenumber(k)=index_particle(temp_particlenumber);
        end

    end

    %Particle update in each swarm
    for k=1:NS
        index_particle=S(:,k);
        P_i=1-(log(j)/(beta*log(NI)));
        randomnumber=rand(N,1);
        J=find(randomnumber<P_i);

        if(isempty(J))
            J=floor(1+length(MINJ)*rand);
        end

        J=1:N;

        for i=1:length(index_particle)

            temp=particle(:,j-1,index_particle(i));
            a1=particle(:,j-1,index_particle(i));
            a2=particle(:,ls_ITER(k,i),index_particle(i));
            a4=particle(:,ls_ITER(k,index_particle==particlenumber(k)),particlenumber(k));


            k1=C1.*rand(length(a1),1);
            k2=C2.*rand(length(a1),1);

            temp(J)=w(j)*a1(J)+(C1.*rand).*(a2(J)-a1(J))+(C2.*rand).*(a4(J)-a1(J));
            %temp(J)=w(j)*a1(J)+k1(J).*(a2(J)-a1(J))+k2(J).*(a4(J)-a1(J));

            %tempv1=velocity(:,j-1,index_particle(i));
            %v1=velocity(:,j-1,index_particle(i));
            %tempv1(J)=w(j)*v1(J)+(C1.*rand).*(a2(J)-a1(J))+(C2.*rand).*(a4(J)-a1(J));
            %tempv1(J)=w(j)*v1(J)+k1(J).*(a2(J)-a1(J))+k2(J).*(a4(J)-a1(J));
            %velocity(:,j,index_particle(i))=tempv1;
            %temp(J)=a1(J)+tempv1(J);

            temp=bind(temp,MINJ,MAXJ);
            tempfitness=fit7(temp);

            %Greedy step
           %if(tempfitness<fitness(index_particle(i),j-1))
           %     particle(:,j,index_particle(i))=temp;
           %else
           %     particle(:,j,index_particle(i))=particle(:,j-1,index_particle(i));
           %end

            particle(:,j,index_particle(i))=temp;
            fitness(index_particle(i),j)=fit7(temp);

            [ls_pbest_solution(k,:),ls_ITER(k,:)]=particlebest(fitness(index_particle,:));
            [ls_gbest_solution(k),temp_particlenumber]=globalbest(ls_pbest_solution(k,:));
            particlenumber(k)=index_particle(temp_particlenumber);

        end
    end
    %Here I find the best particles from each swarm and pass it on to
    %DDS forswarms

    for k=1:NS
        best_particles_ls(:,k)=particle(:,ls_ITER(k,(S(:,k)==particlenumber(k))),particlenumber(k));
    end
    %Finding the best solution among all the swarms-keeping a track of
    %swarmnumber here and the index of the particle in the swarm. This
    %helps in calculation of failure counter and success counter

    [g_best_solution(j),swarmnumber(j)]=globalbest(ls_gbest_solution);
    bestparticle(:,j)=particle(:,ls_ITER(swarmnumber(j),S(:,swarmnumber(j))==particlenumber(swarmnumber(j))),particlenumber(swarmnumber(j)));
    bestparticle_index(j)=find(S(:,swarmnumber(j))==particlenumber(swarmnumber(j)));
    fprintf('Global best is %f and iteration is %d \n',g_best_solution(j),j);

    %Checking if my global best is not changing

    if((g_best_solution(j)==g_best_solution(j-1))||(g_best_solution(j)>(0.99*g_best_solution(j-1))))
      failure_counter=failure_counter+1;
    else
      failure_counter=0;
    end
    
    if(((NI-j)>0)&&(failure_counter>failure_counter_threshold))
        [bestval_dds_swarm,best_particle_dds_swarm,dds_swarm_flag]=DDSFORSWARM_7(bestparticle(:,j-1),MAXJ,MINJ,r,NP*(NI-j));
        break;
    end
    
     if(dds_swarm_flag==0)
            bestval_dds_swarm=g_best_solution;
            best_particle_dds_swarm=bestparticle;
     end
       

    

end

end


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



%Find particle best and global best - particle best is the best fitness found by the particle in all iterations and global best is the best fitness found by all particles in all iterations

function[pbest_solution,ITER]=particlebest(fitn)
[pbest_solution,ITER]=min(fitn,[],2);
end

function[gbest_solution,particlenumber]=globalbest(par)
[gbest_solution,particlenumber]=min(par);
end

function [S]=newswarms(NP,NS,SUB_SWARM_SIZE)
K=randperm(NP);
S(:,1)=K(1:SUB_SWARM_SIZE);
    for i=2:NS
        diff=setdiff(K,S(:,i-1));
        idx=randperm(length(diff));
        diffperm=diff(idx);
        S(:,i)=diffperm(1:SUB_SWARM_SIZE);
        K=diff;
    end
end
