function y = rosenbrock(x,y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Rosenbrock function

    if(nargin <2)
       y = []; 
    end
    n = length(x);
    sum = 0;
    for i = 2:floor(n/2)
        sum = 100*(x(2*i-1)-x(2*i)^2)^2+(x(2*i-1)-1)^2+sum;
    end
    y = sum;

end

