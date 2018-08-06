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

if (lower(axisOri) == 'y')
    if (axisValue <= lowerBound || axisValue >= upperBound)
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        if(double(f(lowerBound)) >= axisValue)
            innerDisks = axisValue - f(lowerBound); 
            outerDisks = axisValue - f(xpoints);
            
            % Axis of rotation ABOVE area under curve, outer radius is axis
            % value minus minima of function within bounds.
        elseif (double(f(upperBound)) <= axisValue)
            innerDisks = axisValue - f(xpoints);
            outerDisks = axisValue - f(lowerBound);
        end
        diskAreas = pi*(outerDisks.^2 - innerDisks.^2);
    else
        diskAreas = pi * (f(xpoints) - axisValue).^2;
    end
    % If axis running through x-axis, flip the function determining disk radii
    % to be the inverse function of passed expression.
elseif (lower(axisOri) == 'x')
    g(x) = finverse(f);
    
    if (axisValue <= g(lowerBound) || axisValue >= g(upperBound))
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        if(axisValue <= double(g(lowerBound)))
%             innerDisks = axisValue - g(lowerBound); 
%             outerDisks = axisValue - g(xpoints);
            innerDisks = axisValue - g(xpoints); 
            outerDisks = axisValue - g(upperBound);
            
            % Axis of rotation ABOVE area under curve, outer radius is axis
            % value minus minima of function within bounds.
        elseif (axisValue >= double(g(upperBound)))
%             innerDisks = axisValue - g(xpoints);
%             outerDisks = axisValue - g(lowerBound);
            innerDisks = axisValue - g(upperBound); 
            outerDisks = axisValue - g(xpoints);
        end
        diskAreas = pi*(outerDisks.^2 - innerDisks.^2);
    else
        diskAreas = pi * (g(xpoints) - axisValue).^2;
    end
end

% Checks for any NaNs, as result of problems such as logarithm function of
% negative number.
for i = 1:length(diskAreas)
    if (isnan(diskAreas(i)) || ~isreal(diskAreas(i)))
        diskAreas(i) = 0;
    end
end

diskVolumes = diskAreas*delta;
approxVol = double(sum(diskVolumes));

end

