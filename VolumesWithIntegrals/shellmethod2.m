function sumShellVols = shellmethod2(funcString, shellcount, lowerBound, upperBound, axisOri, axisValue, radiusMethod)
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

%X-points separated by disk width, which determine radii of shells.
if (radiusMethod == "m")
    xpoints = lowerBound+(delta/2):delta:upperBound-(delta/2);
elseif (radiusMethod == "l")
    xpoints = lowerBound:delta:upperBound-delta;
elseif (radiusMethod == "r")
    xpoints = lowerBound+delta:delta:upperBound;
end

syms x
f(x) = str2sym(funcString);

if (lower(axisOri) == 'y') % Bounds along y-axis, use inverse with upperbound as "limit" of volume.
    g(x) = finverse(f);
    shellHeights = abs(double(g(upperBound) - g(xpoints)));
% Bounds along x-axis, use inverse with upperbound as "limit" of volume
% minus the function along to collect the shell's lengths (shells are
% horizontal)
else
    shellHeights = abs(double(f(upperBound) - f(xpoints)));
end

% Checks for any NaNs, as result of problems such as logarithm function of
% negative number.
for x = 1:length(shellHeights)
    if (isnan(shellHeights(x)))
        shellHeights(x) = 0;
    end
end

shellVols = shellHeights.*abs(xpoints-axisValue)*delta;
sumShellVols = 2*pi*sum(shellVols);

% Included filler cylinder between axis of rotation and first/last shell.
if (lowerBound > axisValue)
    inner_radius = abs(lowerBound - axisValue);
    inner_cyl_vol = pi*(inner_radius^2)*shellHeights(1);
    
elseif (upperBound < axisValue)
   inner_radius = abs(axisValue - upperBound);
   inner_cyl_vol = pi*(inner_radius^2)*shellHeights(end);
    
else
    inner_cyl_vol = 0;
end

sumShellVols = sumShellVols + inner_cyl_vol;
end

