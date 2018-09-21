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
g(x) = finverse(f);

% Bounds along x-axis, use inverse with upperbound as "limit" of volume
% minus the function along to collect the shell's lengths (shells are
% horizontal)
if (lower(axisOri) == 'x')
    shellHeights = f(xpoints);
    
% Bounds along y-axis, use inverse with upperbound as "limit" of volume.
elseif (lower(axisOri) == 'y')
    if (g(lowerBound) <= 0 && g(upperBound) <= 0)
        if (funcString == "x")
            shellHeights = g(lowerBound) - g(xpoints);
        else
            shellHeights = g(upperBound) - g(xpoints);
        end
    % Otherwise, bound one end of each shell's length by constant,
    % g(upperBound)
    else
        shellHeights = g(upperBound) - g(xpoints);
    end
end

% Checks for any NaNs, as result of problems such as logarithm function of
% negative number.
for x = 1:length(shellHeights)
    if (isnan(shellHeights(x)))
        shellHeights(x) = 0;
    end
end

shellVols = abs(shellHeights.*(xpoints-axisValue))*delta;
sumShellVols = 2*pi*sum(shellVols);
sumShellVols = double(sumShellVols);

% If there is gap b/w inverse lower boudn and axis, add that inner
% volume to the total volume.
if (lower(axisOri) == 'y') 
    fillerShellVolume = 0;
    innerShellLength = g(upperBound) - g(lowerBound);
    
    % Horizontal axis lower than lowerbound on y-axis, but greater than
    % y=0, rotate area b/w lowerbound and axis value, in which diff b/w
    % both is width and diff b/w counterparts of lower and upper bounds
    % along x-axis is the length (shell height) of the shell.
  if (lowerBound >= axisValue)
    if (lowerBound >= 0 && upperBound >= 0)
      % Axis between 0 and lower bound along y-axis, add up 
      if (axisValue >= 0)
          % The filler shell is like a basic cylinder, with radius of (lowerBound - axisValue)
          fillerShellVolume = pi*(lowerBound - axisValue)^2*innerShellLength; 
      else
        % The filler shell, with radius of (lowerBound - axisValue)
          fillerShellVolume = pi*(lowerBound - axisValue)^2*innerShellLength; 
          fillerShellVolume = fillerShellVolume - (pi*(0 - axisValue)^2*innerShellLength);
      end
      
    elseif (lowerBound <= 0 && upperBound <= 0)
        fillerShellVolume = pi*(axisValue)^2*innerShellLength;
        fillerShellVolume = fillerShellVolume - pi*(axisValue - upperBound)^2*innerShellLength;
    end
  % Horizontal axis of rotation higher than upper bound along y-axis.
  elseif (upperBound <= axisValue)
    % Area rotated is within negative space
    if (upperBound <= 0)
      if (axisValue <= 0)
          fillerShellVolume = pi*(upperBound - axisValue)^2*innerShellLength; 
      else
          fillerShellVolume = pi*(axisValue - upperBound)^2*innerShellLength; 
          fillerShellVolume = fillerShellVolume - (pi*(axisValue - 0)^2*innerShellLength);
      end
    % The area is positive, so rotate it
    elseif (lowerBound >= 0)
        fillerShellVolume = pi*(axisValue)^2*innerShellLength;
        fillerShellVolume = fillerShellVolume - pi*(axisValue - lowerBound)^2*innerShellLength;
    end
  end
  sumShellVols = sumShellVols + double(fillerShellVolume);
end
end