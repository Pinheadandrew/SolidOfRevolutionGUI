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
functionNotOnZero = 0;
fillerVolume = 0;

if (lower(axisOri) == 'y')
    if (axisValue <= f(lowerBound) || axisValue >= f(upperBound))
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        
        if (lowerBound <= 0 && upperBound <= 0 && funcString == "x")
            
            % Axis of rotation BELOW area above curve in negative space, set outer radius to
            % aV and inner to f(x) - aV
            if(double(f(lowerBound)) >= axisValue)
                innerDisks = f(xpoints) - axisValue;
                outerDisks = axisValue;
                
                % Axis of rotation ABOVE area under curve in negative space, outer radius is axis
                % value minus function within bounds and inner radius is
                % function maxima within bounds minus axis Value.
            elseif (f(upperBound) <= axisValue)
                
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisValue <= 0)
                    innerDisks = zeros(1, length(xpoints));
                else
                    innerDisks = zeros(1, length(xpoints)) - axisValue;
                end
                
                outerDisks = axisValue - f(xpoints);
            end
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
        % Otherwise, if area under/above curve not f(x) bounded by negative
        % numbers along x-axis.
        else
            if(double(f(lowerBound)) >= axisValue)
                
                if (axisValue >= 0)
                    innerDisks = zeros(1, length(xpoints));
                else
                    innerDisks = zeros(1, length(xpoints)) - axisValue;
                end
                
                outerDisks = axisValue - f(xpoints);
                
                % Axis of rotation ABOVE area under curve, outer radius is axis
                % value minus minima of function within bounds.
            elseif (double(f(upperBound)) <= axisValue)
                innerDisks = axisValue - f(xpoints);
                outerDisks = axisValue*ones(1, length(xpoints));
            end
        end
    end
    diskAreas = pi*(outerDisks.^2 - innerDisks.^2);
    
    % If axis running through x-axis, flip the function determining disk radii
    % to be the inverse function of passed expression.
elseif (lower(axisOri) == 'x')
    g(x) = finverse(f);
    
    %If axis value outside of bounds or on a bound, use washer
    %method.
    if (axisValue <= double(g(lowerBound)) || axisValue >= double(g(upperBound)))
        
        % Axis of rotation to the left of area under curve, set outer radius to
        % function line, inner to the inverse function with lower bound.
        if(axisValue <= double(g(lowerBound)))
            if (lowerBound <= 0 && upperBound <= 0)
                innerDisks = axisValue - g(lowerBound);
                outerDisks = axisValue - g(xpoints);
                functionNotOnZero = 1;
            %  Bounds are actually homogenous signs, or both positive  
            else
                innerDisks = axisValue - g(xpoints);
                outerDisks = axisValue - g(upperBound);
                
                if (f(lowerBound) > 0)
                    functionNotOnZero = 1;
                end
            % Axis of rotation to the right area under curve, outer radius is axis
            % value minus minima of function within bounds.
            end
            elseif (axisValue >= double(g(upperBound)))
                if (lowerBound <= 0 && upperBound <= 0)
                    innerDisks = axisValue - g(xpoints);
                    outerDisks = axisValue - g(lowerBound);
                    functionNotOnZero = 1;
                else
                    innerDisks = axisValue - g(upperBound);
                    outerDisks = axisValue - g(xpoints);
                    
                    % Function at lower bound > 0, rotate area under it.
                    if (f(lowerBound) > 0)
                        functionNotOnZero = 1;
                    end
                end
            end
            diskAreas = pi*(outerDisks.^2 - innerDisks.^2);
        
            % If no gap b/w axis and bound, regular discs w/ no inner area to
        % subtract.
        else
            diskAreas = pi * (g(xpoints) - axisValue).^2;
    end
        
    % If rotating area, and part of area between function and axis cut out
    % (i.e. area above area where f(x) = x and -3<y<-1), add it.
    if (functionNotOnZero == 1)
        if (f(lowerBound) > 0)
            cylInnerRadius = g(lowerBound) - axisValue;
            cylOuterRadius = g(upperBound) - axisValue;
            cylIntegrant = abs(pi*(cylOuterRadius^2 - cylInnerRadius^2));
            fillerVolume = double(int(cylIntegrant, 0, lowerBound));
%             volume = volume + cylVolumeWithBaseZero;
        elseif (f(upperBound) < 0)
            cylInnerRadius = g(upperBound) - axisValue;
            cylOuterRadius = g(lowerBound) - axisValue;
            cylIntegrant = abs(pi*(cylOuterRadius^2 - cylInnerRadius^2));
            fillerVolume = double(int(cylIntegrant, upperBound, 0));
%             volume = volume + cylVolumeWithBaseZero;
        end
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
    approxVol = double(sum(diskVolumes)) + fillerVolume;
end

