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
      
         if (lowerBound <= 0 && upperBound <= 0 && funcString == "x")
            
            % Axis of rotation BELOW area under curve in negative space, set outer radius to
            % f(upperbound) - aV and inner to f(x) - aV
            if(double(f(lowerBound)) >= axisValue)
                innerRadius = f(x) - axisValue;
                outerRadius = f(upperBound) - axisValue;

                % Axis of rotation ABOVE area under curve in negative space, outer radius is axis
                % value minus function within bounds and inner radius is
                % function maxima within bounds minus axis Value. 
            elseif (f(upperBound) <= axisValue)
                
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisValue <= 0)
                    innerRadius = 0;
                else
                    innerRadius = 0 - axisValue;
                end
                
                outerRadius = axisValue - f(x);
            end
         else
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
            if(double(f(lowerBound)) >= axisValue)

                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisValue >= 0)
                    innerRadius = 0;
                else
                    innerRadius = 0 - axisValue;
                end

                outerRadius = axisValue - f(x);

                % Axis of rotation ABOVE area under curve, outer radius is axis
                % value minus minima of function within bounds.
            elseif (double(f(upperBound)) <= axisValue)
                innerRadius = axisValue - f(x);
                outerRadius = axisValue - f(lowerBound);
            end
         end
        A(x) = pi*(outerRadius^2 - innerRadius^2);
    else
        A(x) = pi*((f(x) - axisValue))^2;
    end
    volume = double(int(A(x), lowerBound, upperBound));
    
    % Area under curve rotated around vertical line.
elseif (lower(axisOri) == 'x')
    g(x) = finverse(f);
    functionNotOnZero = 0;
    
    %If axis value outside of bounds or on a bound, use washer
    %method.
    if (axisValue <= g(lowerBound) || axisValue >= g(upperBound))
        
        % Axis of rotation to the left of area under curve, set outer radius to
        % function line, inner to the inverse function with lower bound.
        if(axisValue <= double(g(lowerBound)))
            
            % Area rotated within negative space.
            if (lowerBound <= 0 && upperBound <= 0)
                % Reflective Function
                if (f(g(lowerBound)) == f(-g(lowerBound)) && f(g(lowerBound)) == f(-g(lowerBound)))
                    
                    if (abs(lowerBound) > abs(upperBound))
                        newLower = abs(upperbound);
                        newUpper = abs(lowerbound);
                    else
                        newLower = abs(lowerbound);
                        newUpper = abs(upperbound);
                    end
                    
                    newLower = f(newLower);
                    newUpper = f(newUpper);
                    newAxisVal = abs(axisVal);
                    
                    if newAxisVal >= g(newUpper) % Axis to
                        innerRadius = newAxisVal - g(newUpper);
                        outerRadius = newAxisVal - g(x);
                    elseif newAxisVal <= g(newLower)
                        innerRadius = newAxisVal - g(x);
                        outerRadius = newAxisVal - g(newUpper);
                    end
                else
                    innerRadius = axisValue - g(lowerBound);
                    outerRadius = axisValue - g(x);
                    functionNotOnZero = 1;
                end
            else
                innerRadius = axisValue - g(x);
                outerRadius = axisValue - g(upperBound);
                
                if (f(lowerBound) > 0)
                    functionNotOnZero = 1;
                end
            end
            % Axis of rotation to the right area under curve, outer radius is axis
            % value minus minima of function within bounds.
        elseif (axisValue >= double(g(upperBound)))
            if (lowerBound <= 0 && upperBound <= 0)
                innerRadius = axisValue - g(x);
                outerRadius = axisValue - g(lowerBound);
                functionNotOnZero = 1;
            else
                innerRadius = axisValue - g(upperBound);
                outerRadius = axisValue - g(x);
                
                if (f(lowerBound) > 0)
                    functionNotOnZero = 1;
                end
            end
        end
        A(x) = pi*(outerRadius^2 - innerRadius^2);
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
end
% volume = double(int(A(x), lowerBound, upperBound));

