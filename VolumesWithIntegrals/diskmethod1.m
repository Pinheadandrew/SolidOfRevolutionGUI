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

% Rotating perpendicular to horizontal line.
if (lower(axisOri) == 'y')
    
    %If axis value not any bound and outside of the bounds, use washer
    %method.
    if (axisValue ~= lowerBound && axisValue ~= upperBound)
    
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        if(double(f(lowerBound)) > axisValue)
            innerArea = axisValue - f(lowerBound);
            outerArea = axisValue - f(x);
        % Axis of rotation ABOVE area under curve, outer radius is axis
        % value minus minima of function within bounds.
        elseif (double(f(upperBound)) < axisValue)
            innerArea = axisValue - f(x);
            outerArea = axisValue - f(lowerBound);
        end
        A(x) = pi*(outerArea^2 - innerArea^2);
    else   
        A(x) = pi*((f(x) - axisValue))^2;
    end
    
elseif (lower(axisOri) == 'x')
     g(x) = finverse(f);
%     A(x) = pi*(g(x) - axisValue)^2;

    %If axis value not any bound and outside of the bounds, use washer
    %method.
    if (axisValue ~= lowerBound && axisValue ~= upperBound)
    
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        if(double(g(lowerBound)) > axisValue)
            innerArea = axisValue - g(lowerBound);
            outerArea = axisValue - g(x);
        % Axis of rotation ABOVE area under curve, outer radius is axis
        % value minus minima of function within bounds.
        elseif (double(g(upperBound)) < axisValue)
            innerArea = axisValue - g(x);
            outerArea = axisValue - g(lowerBound);
        end
        A(x) = pi*(outerArea^2 - innerArea^2);
    else   
        A(x) = pi*((g(x) - axisValue))^2;
    end
end
volume = double(int(A(x), lowerBound, upperBound));
end

