function volume = diskmethod1(funcString, lowerbound, upperbound)
%DISKMETHOD Function that returns volume of area under curve rotating
%around axis of revolution, evaluated using the integral version of the disk
%method for faster computation O(1).
%   Input:
%       1. A single-variable function in string form.
%       3. The lower bound
%       4. The upper bound
%
%   Output:
%       The volume 

syms x
f(x) = str2sym(funcString);
A(x) = pi*(f(x))^2;
volume = double(int(A(x), lowerbound, upperbound));

end

