function volume = shellmethod1(funcString, lowerBound, upperBound, axisOri, axisValue)
%SHELLMETHOD1 Returns the , the volume under a function retrieved by rotating the
% area under the function around the axis perpendicular to the axis of revolution. 
% The volume approaches the approximate volume as the number of shells increases.
%   Input:
%       1. Function
%       2. Number of shells encompassing the volume.
%       3. Lower bound of input variable.
%       4. Upper bound of input variable.

%   Steps:
%       1. Convert function string to symbolic expression.
%       2. Integrate the function squared times the variable the integral
%          is done in respect to. Multiply the integral by 2*pi.
%       3. 

syms x
assume(x >= lowerBound & x <= upperBound);
f(x) = str2sym(funcString);
radius = x - axisValue;

if (lower(axisOri) == 'x')
    A(x) = f(x);
else
    A(x) = finverse(f(x));
end
    
volume = 2*pi*double(int(abs(radius*A(x)), lowerBound, upperBound));
end