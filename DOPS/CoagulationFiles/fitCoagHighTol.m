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

%This returns the fitness value for the coagulation model.
function fitness = fitCoagHighTol(x,y) %for DE, need 2 inputs
    if(nargin<2)
       y = []; 
    end
	DF=DataFile(0,0,0,[]); %Loads the coagulation data structure
	DFIN=DF;
	DFIN.RATE_CONSTANT_VECTOR=x; %Assigns the rate constant vector as the current solution
  fitness=(1/2)*ObjFunctionFig2E1HighTol(DFIN)+(1/2)*ObjFunctionFig2E5HighTol(DFIN); %Calculates the fitness values by passing the rate constant vector to the objectives E1 and E5
end
