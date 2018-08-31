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

syms x
f(x) = str2sym(funcString);
g(x) = finverse(f);
radius = x - axisValue; % Radius for each shell, in the circumference formula to determine length of 
                        % shell as "rectangular prism".

% If rotating around vertical line, 
if (lower(axisOri) == 'x')
     integrant = abs(radius*f(x)); % |(x-radius)*f(x)|
     
% If rotation done paralell to a horizontal line, integrate function's inverse.
elseif  (lower(axisOri) == 'y')
    
    % Area is bounded in area which is in negative-negative quadrant.
    if (g(lowerBound) <= 0 && g(upperBound) <= 0)
        integrant = abs(radius*(g(lowerBound) - g(x)));
    % Otherwise, bound one end of each shell's length by constant,
    % g(upperBound)
    else
        integrant = abs(radius*(g(upperBound) - g(x)));
    end
end

volume = 2*pi*double(int(integrant, lowerBound, upperBound));

if (lower(axisOri) == 'y')
    % If there is gap b/w inverse lower boudn and axis, add that inner
    % volume to the total volume. 
    innerShellLength = g(lowerBound) - g(upperBound);
%     innerShellRadius = (x-axisValue);
    
  % The lower bound along y-axis is greater than the horizontal a
  if (lowerBound >= axisValue)
    % Horizontal axis lower than lowerbound on y-axis, but greater than
    % y=0, rotate area b/w lowerbound and axis value, in which diff b/w
    % both is width and diff b/w counterparts of lower and upper bounds
    % along x-axis is the length (shell height) of the shell.
    disp("LOWB >= AXISVALUE")
    if (lowerBound >= 0 && upperBound >= 0)
      if (axisValue >= 0)
        fillerShellVolume = double(int(abs(radius*innerShellLength), axisValue, lowerBound));
      else
        fillerShellVolume = double(int(abs(radius*innerShellLength), 0, lowerBound));
      end
      
    elseif (lowerBound <= 0 && upperBound <= 0)
        disp("BOUNDS NEGATIVE")
        fillerShellVolume = double(int(abs(radius*innerShellLength), upperBound, 0))
    end
  elseif (upperBound <= axisValue)
    % Volume is negative
    if (upperBound <= 0)
      if (axisValue <= 0)
        fillerShellVolume = double(int(abs(radius*innerShellLength), upperBound, axisValue));
      else
        fillerShellVolume = double(int(abs(radius*innerShellLength), upperBound, 0));
      end
%     end
    % The area is positive, so rotate it
    elseif (upperBound > 0)
        fillerShellVolume = double(int(abs(radius*innerShellLength), 0, lowerBound));
    end
  end
  volume = volume + 2*pi*fillerShellVolume;
end
end