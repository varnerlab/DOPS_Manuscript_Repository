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
%  ------------------------------------------------------------------------
%  ----------- 

%% Dynamically Dimensioned Search
function[best,x_best,dds_swarm_flag]=DOPS_DDS(optFunction,IC,MAXJ,MINJ,r,NI)

% DDS search parameters
N=length(MINJ);
x_best(:,1)=IC;          % Initialize the solution
x=IC;
J=1:N;                   % Specify initial dimensions being perturbed
F_best=fit(x,optFunction);           % Calculate initial best fitness
F=fit(x,optFunction);                % Calculate current fitness 

%%
for i=1:NI

	P_i=1-(log(i)/log(NI));                          % Calculate threshold perturbation probability
	randomnumber=rand(N,1);                          % Generate probability for each dimension to be selected drawn from an uniform distribution 
	J=find(randomnumber<P_i);                        % Find subset of dimensions being perturbed

	if(isempty(J))

		J=floor(1+length(IC)*rand);                  % Perturb at least one dimension if J=0
	end

	SIGMA=r.*(MAXJ-MINJ);
	x_new=x;
	x_new(J)=(x(J))+SIGMA(J).*randn(length(J),1);    % Perturb the current solution - this is user defined   
	x_new=bind(x_new,MINJ,MAXJ);                     % Ensure the perturbed solution is within bounds

	F_new=fit(x_new,optFunction);
    
    %make sure we haven't ended up with a NAN, if so repeat process until
    %we get a a real number
    
    NANcount = 0;
    while(isnan(F_new))
        SIGMA=r.*(MAXJ-MINJ);
        x_new=x;
        x_new(J)=(x(J))+SIGMA(J).*randn(length(J),1);    % Perturb the current solution - this is user defined   
        x_new=bind(x_new,MINJ,MAXJ);                     % Ensure the perturbed solution is within bounds

        F_new=fit(x_new,optFunction);
        NI = NI -1; %deduct the cost of finding a NA soltuion
        NANcount = NANcount +1;
        fprintf('In starting DDS found %d NAN parameter sets\n', NANcount);
    end

	%Greedy step - accept solution only if better than the previous
	%solution
    
	if(F_new<F)
	    x=x_new;
	    F=F_new;

		if(F_new<=F_best)
			F_best=F_new;
			x_best(:,i)=x_new;
        else
            if i>1
                x_best(:,i)=x_best(:,i-1);
            end
        end

    else
        if i>1
            x_best(:,i)=x_best(:,i-1);
        end
	end


best(i)=F_best;

fprintf('Best value is %20.10f and iteration is %d \n',best(i),i);          

end

dds_swarm_flag=1;                                                 
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


