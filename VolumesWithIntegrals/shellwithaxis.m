function volume = shellwithaxis(funcString, lowerBound, upperBound, axisOri, axisValue)
%DISKWITHAXIS 
%   Inputs:
%       1. Function to grab the area above/underneath.
%       2. Axis orientation(x or y)
%       3. Axis value (i.e x = 0 to rotate about y-axis) to rotate the area
%       parallel to the axis.
%       3. The lower bound
%       4. The upper bound
%
%   Output:
%       The volume 

syms x
assume(x >= lowerBound & x <= upperBound);
f(x) = str2sym(funcString);

if (lower(axisOri) == 'x')
    A(x) = f(x);
    radius = x - axisValue;
    volume = 2*pi*double(int(abs(radius*A(x)), lowerBound, upperBound));
else
    A(x) = finverse(f(x));
    radius = x - axisValue;
    volume = 2*pi*double(int(abs(radius*A(x)), lowerBound, upperBound));
end
end