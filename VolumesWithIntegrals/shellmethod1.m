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
%       3. 

syms x
assume(x >= lowerBound & x <= upperBound);
f(x) = str2sym(funcString);
g(x) = finverse(f);
radius = x - axisValue;

% If rotating around vertical line, 
if (lower(axisOri) == 'x')
    integrant = abs(radius*(double(f(upperBound))-f(x)));
    volume = 2*pi*double(int(integrant, lowerBound, upperBound));
else % If rotation done paralell to a vertical line, integrate function's inverse.
    integrant = abs(radius*(g(upperBound) - g(x)));
    volume = 2*pi*double(int(integrant, lowerBound, upperBound));
end

% Included filler cylinder between lower/upper bound and axis of rotation.
% Conditions b/w the lower bound being greater than axis value, upper
% bound being lesser than axis value, or if a bound matches the axis value.
if (lowerBound > axisValue)
    inner_radius = abs(lowerBound - axisValue);
    
    if (lower(axisOri) == 'y') % Horizontal inner cylinder
        inner_cyl_height = double(g(upperBound) - g(lowerBound));
    else % Vertical Line
        inner_cyl_height = double(f(upperBound) - f(lowerBound));
    end
    inner_cyl_vol = pi*(inner_radius^2)*inner_cyl_height;
    
elseif (upperBound < axisValue)
   inner_radius = abs(axisValue - upperBound);
   
    if (lower(axisOri) == 'y') % Horizontal inner cylinder, or vertical.
        inner_cyl_height = double(upperBound - g(upperBound));
    else %
        inner_cyl_height = double(upperBound - f(upperBound));
    end
    inner_cyl_vol = pi*(inner_radius^2)*inner_cyl_height;
    
else
    inner_cyl_vol = 0;
end

volume = volume + inner_cyl_vol;
end

