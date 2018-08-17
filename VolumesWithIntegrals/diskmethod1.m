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
    if (axisValue <= f(lowerBound) || axisValue >= f(upperBound))
    
        % Axis of rotation BELOW area under curve, set outer radius to
        % function line.
        if(double(f(lowerBound)) >= axisValue)
            
            % Add difference b/w axis value and f(lowbound) to inner radius
            if (axisValue >= 0)
                innerArea = 0;
            else
                innerArea = 0 - axisValue;
            end
            
            outerArea = axisValue - f(x);
            
        % Axis of rotation ABOVE area under curve, outer radius is axis
        % value minus minima of function within bounds.
        elseif (double(f(upperBound)) <= axisValue) 
            innerArea = axisValue - f(x);
            outerArea = axisValue - f(lowerBound);
        end
        A(x) = pi*(outerArea^2 - innerArea^2);
    else   
        A(x) = pi*((f(x) - axisValue))^2;
    end
   volume = double(int(A(x), lowerBound, upperBound)); 
   
% Area under curve rotated around vertical line.
elseif (lower(axisOri) == 'x')
     g(x) = finverse(f);
     functionNotOnZero = 0;
    %If axis value not any bound and outside of the bounds, use washer
    %method.
    if (axisValue <= g(lowerBound) || axisValue >= g(upperBound))
    
        % Axis of rotation to the left of area under curve, set outer radius to
        % function line, inner to the inverse function with lower bound.
        if(axisValue <= double(g(lowerBound))) 
            
            % Volume within the -x, -y quadrant, 
            if (lowerBound <= 0 && upperBound <= 0)
                innerArea = axisValue - g(lowerBound);
                outerArea = axisValue - g(x);
                functionNotOnZero = 1;
            else
                innerArea = axisValue - g(x);
                outerArea = axisValue - g(upperBound);
                
                if (f(lowerBound) > 0)
                    functionNotOnZero = 1;
                end
            end
        % Axis of rotation to the right area under curve, outer radius is axis
        % value minus minima of function within bounds.
        elseif (axisValue >= double(g(upperBound))) 
            if (lowerBound <= 0 && upperBound <= 0)
                innerArea = axisValue - g(x);
                outerArea = axisValue - g(lowerBound);
                functionNotOnZero = 1;
            else
                innerArea = axisValue - g(upperBound);
                outerArea = axisValue - g(x); 
                
                if (f(lowerBound) > 0)
                    functionNotOnZero = 1;
                end
            end
        end
        A(x) = pi*(outerArea^2 - innerArea^2);
    else  
    % If no gap b/w axis and bound, regular discs w/ no inner area to
    % subtract.
        A(x) = pi*((g(x) - axisValue))^2;
    end
    volume = double(int(A(x), lowerBound, upperBound));
    
    if (functionNotOnZero == 1)
        if (f(lowerBound) > 0)
            cylInnerRadius = g(lowerBound) - axisValue;
            cylOuterRadius = g(upperBound) - axisValue;
            cylIntegrant = abs(pi*(cylOuterRadius^2 - cylInnerRadius^2));
            cylVolumeWithBaseZero = double(int(cylIntegrant, 0, lowerBound));
            
            volume = volume + cylVolumeWithBaseZero;
        elseif (f(upperBound) < 0)
            cylInnerRadius = g(upperBound) - axisValue;
            cylOuterRadius = g(lowerBound) - axisValue;
            cylIntegrant = abs(pi*(cylOuterRadius^2 - cylInnerRadius^2));
            cylVolumeWithBaseZero = double(int(cylIntegrant, upperBound, 0));
            
            volume = volume + cylVolumeWithBaseZero;
        end
    end
end
% volume = double(int(A(x), lowerBound, upperBound));
end

