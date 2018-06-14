function approxVol = diskmethod2(funcString, diskcount, lowerBound, upperBound, axisOri, axisValue, radiusMethod)
%DISKMETHOD2
%   Input:
%       1. A single-variable function in string form.
%       2. The number of disks to sum the volumes of.
%       3. The lower bound
%       4. The upper bound
%
%   Output:
%       The volume in double-precison, given the number of disks.

% Establish function, and collect given x-points that are separated by 
% delta-x to evaluate f(x) with them for their outputs. Get cross-section 
% areas of disks using pi * (y-point)^2 for each y-point. Then, multiply 
% it with delta-x, resulting in the volume of each disks, which is stored 
% as an element in a matrix for output.

delta = (upperBound-lowerBound)/diskcount;

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

% If axis running through x-axis, flip the function determining disk radii
% to be the inverse function of passed expression.
if (lower(axisOri) == 'x')
    f(x) = finverse(f);
end

ypoints = double(f(xpoints) - axisValue);

% Checks for any NaNs, as result of problems such as logarithm function of
% negative number.
for x = 1:length(ypoints)
    if (isnan(ypoints(x)) || ~isreal(ypoints(x)))
        ypoints(x) = 0;
    end
end

% Vector to hold volumes of each disk, then add them all up to return the
% volume for the solid.

diskVolumes = pi*(ypoints.^2)*delta;
approxVol = sum(diskVolumes);

end

