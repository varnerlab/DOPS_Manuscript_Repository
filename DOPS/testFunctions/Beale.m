function [ f ] = Beale( x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(nargin<2)
    y = [];
end

f = (1.5-x(1)+x(1)*x(2))^2 + (2.25-x(1)+x(1)*x(2)^2)^2 +(2.625-x(1)+x(1)*x(2)^3)^2;

end
