function y = rast300(x,y)
% 
% Rastrigin function
% Matlab Code by A. Hedar (Nov. 23, 2005).
% The number of variables n should be adjusted below.
% The default value of n = 2.
% 
%for using with DE from http://www1.icsi.berkeley.edu/~storn/code.html#matl
if(nargin<2)
    y = [];
end
    n = length(x); 
    s = 0;
    for j = 1:n
        s = s+(x(j)^2-10*cos(2*pi*x(j))); 
    end
    y = 10*n+s;
end