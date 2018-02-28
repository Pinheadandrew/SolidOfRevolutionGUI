function volume = diskmethod1(funcString, lowerBound, upperBound, axisOri, axisValue)
%DISKMETHOD Function that returns volume of area under curve rotating
%around axis of revolution, evaluated using the integral version of the disk
%method for faster computation O(1).
%   Input:
%       1. A single-variable function in string form.
%       3. The lower bound
%       4. The upper bound
%       4. Axis orientation
%       5. Value of axis
%
%   Output:
%       The volume 

syms x
f(x) = str2sym(funcString);

if (lower(axisOri) == 'y')
    A(x) = pi*(f(x) - axisValue)^2;
elseif (lower(axisOri) == 'x')
    f_inverse(x) = finverse(f);
    A(x) = pi*(f_inverse(x) - axisValue)^2;
end
volume = double(int(A(x), lowerBound, upperBound));
end

