function valid = axisOutsideBounds(funcChoice, methChoice, lowBound, upBound, axisOrient, axisVal)
% Cases
valid = 1;

syms x
f(x) = str2sym(funcChoice);
g(x) = finverse(f);

if (axisOrient == "y") % Constraints for a horizontal line
    if (methChoice == "Shell")
        if (axisVal > lowBound && axisVal < upBound)
            valid = 0;
        end
    elseif (methChoice == "Disk")
        if (axisVal < f(upBound) && axisVal > f(lowBound))
            valid = 0;
        end
    end
    
    % Vertical axis, parallel to y-axis.
elseif (axisOrient == "x")
    if (methChoice == "Shell")
        if (axisVal < upBound && axisVal > lowBound)
            valid = 0;
        end
        
    elseif (methChoice == "Disk")
        if (axisVal < g(upBound) && axisVal > g(lowBound))
            valid = 0;
        end
    end
end
end
