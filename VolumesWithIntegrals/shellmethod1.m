function volume = shellmethod1(funcString, lowerBound, upperBound, axisOri, axisValue)
%SHELLMETHOD1 Returns the , the volume under a function retrieved by rotating the
% area under the function around the axis perpendicular to the axis of revolution. 
% The volume approaches the approximate volume as the number of shells increases.
%   Input:
%       1. Function
%       2. Number of shells encompassing the volume.
%       3. Lower bound of input variable.
%       4. Upper bound of input variable.

%   Steps:
%       1. Convert function string to symbolic expression.
%       2. Integrate the function squared times the variable the integral
%          is done in respect to. Multiply the integral by 2*pi.
%       3. s

x = lowerBound:abs(upperBound-lowerBound)/1000:upperBound;
f = string2func(funcString, 0);
radius = x - axisValue; % Radius for each shell, in the circumference formula to determine length of 
                        % shell as "rectangular prism".

% If rotating around vertical line, 
if (lower(axisOri) == 'x')
     integrant = abs(radius.*f(x)); % |(x-axisValue)*f(x)|
end

% Final volume
volume = 2*pi*double(trapz(x, integrant));
end