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
x = lowerBound:abs(upperBound - lowerBound)/1000: upperBound;
f = string2func(funcString, 0);

% Rotating perpendicular to horizontal line.
if (lower(axisOri) == 'y')
    
    %If axis value not any bound and outside of the bounds, use washer
    %method.
    if (axisValue <= f(lowerBound) || axisValue >= f(upperBound))
        
        % Axis of rotation BELOW area under curve in negative space, set outer radius to
        % f(upperbound) - aV and inner to f(x) - aV
        if (lowerBound <= 0 && upperBound <= 0 && funcString == "x")
            
            if(double(f(lowerBound)) >= axisValue)
                innerRadius = @(x) f(x) - axisValue;
                outerRadius = @(x) axisValue;
                % Axis of rotation ABOVE area under curve in negative space, outer radius is axis
                % value minus function within bounds and inner radius is
                % function maxima within bounds minus axis Value.
            elseif (f(upperBound) <= axisValue)
                
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisValue <= 0)
                    innerRadius = @(x) 0;
                else
                    innerRadius = @(x) 0 - axisValue;
                end
                
                outerRadius = @(x) axisValue - f(x);
            end
        % Otherwise, if area under/above curve not f(x) bounded by negative
        % numbers along x-axis.
        else
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
            if(double(f(lowerBound)) >= axisValue)
                
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisValue >= 0)
                    innerRadius = @(x) 0;
                else
                    innerRadius = @(x) 0 - axisValue;
                end
                
                outerRadius = @(x) axisValue -f(x);
                
            % Axis of rotation ABOVE area under curve, outer radius is axis
            % value minus minima of function within bounds.
            elseif (double(f(upperBound)) <= axisValue)
                innerRadius = @(x) axisValue -f(x);
                outerRadius = @(x) axisValue;
            end
        end
        integrand1 = @(x) (outerRadius(x)).^2;
        integrand2 = @(x) (innerRadius(x)).^2;
%         A(x) = pi*(outerRadius^2 - innerRadius^2);
        A = @(x) (integrand1(x)) - (integrand2(x));
    else
        A = @(x) (f(x) - axisValue)^2;
    end
    
    volume = pi*double(trapz(x,A(x)));
end
end
% volume = double(int(A(x), lowerBound, upperBound));
