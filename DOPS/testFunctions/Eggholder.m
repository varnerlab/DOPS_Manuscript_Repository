function [ f ] = Eggholder( x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(nargin<2)
    y = [];
end

f = -(x(2)+47)*sin(sqrt(abs(x(1)/2+(x(2)+47))))-x(1)*sin(sqrt(abs(x(1)-(x(2)+47))));

end
