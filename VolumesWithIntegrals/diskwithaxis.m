function volume = diskwithaxis(funcString, lowerBound, upperBound, axisOri, axisValue)
%DISKWITHAXIS 
%   Inputs:
%       1. Function to grab the area above/underneath.
%       2. Axis orientation(x or y)
%       3. Axis value (i.e y = 0 to rotate about x-axis) to rotate the area
%       around.
%       3. The lower bound
%       4. The upper bound
%
%   Output:
%       The volume 

syms x
assume(x >= lowerBound & x <= upperBound);
f(x) = str2sym(funcString);

if (lower(axisOri) == 'y')
    A(x) = (f(x) - axisValue)^2;
    volume = pi*double(int(A(x), lowerBound, upperBound));
elseif (lower(axisOri) == 'x')
    f_inverse(x) = finverse(f);
    A(x) = (f_inverse(x) - axisValue)^2;
    volume = pi*double(int(A(x), lowerBound, upperBound));
end
end

