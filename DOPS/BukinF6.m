function [ f ] = BukinF6( x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(nargin<2)
    y = [];
end

f = 100*sqrt(abs(x(2)-.01*x(1)^2))+.01*abs(x(1)+10);

end

