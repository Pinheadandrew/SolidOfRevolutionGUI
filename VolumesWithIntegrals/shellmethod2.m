function sumShellVols = shellmethod2(funcString, shellcount, lowerBound, upperBound, axisOri, axisValue)
%SHELLMETHOD2 Returns the , the volume under a function retrieved by rotating the
% area under the function around the axis perpendicular to the axis of revolution. 
% The volume approaches the approximate volume as the number of shells increases.
%   Input:
%       1. Function rotated around y-axis.
%       2. Number of shells encompassing the volume.
%       3. Lower bound of input variable, axis that function revolves
%       around.
%       4. Upper bound of input variable.

%   General steps:
%       1. Determine the delta based on bounds and number of shells, use
%       delta for thickness of each shell and difference b/w x-points.
%       2. Generate shell heights(height of shell) using function evaluated 
%       by x-points and radii(x in surface area of shell, 2*pi*x)
%       3. Generate each shell volume by multiplying shell heights, their 
%       radii and delta.
%       3. Add them together, multiply their sum by 2*pi.

delta = (upperBound-lowerBound)/shellcount;
xpoints = lowerBound+delta/2:delta:upperBound-delta/2;

syms x
f(x) = str2sym(funcString);

if (lower(axisOri) == 'y')
    f(x) = finverse(f);
end

shellHeights = double(f(xpoints));
shellVols = shellHeights.*(xpoints-axisValue)*delta;
sumShellVols = 2*pi*sum(shellVols);

end

