function plotWithReflection(funcString, lowbound, upbound,  axisOri, axisValue, viewMode)
    syms x
    f(x) = str2sym(funcString);
    
    step = (upbound-lowbound)/100;
    xpoints = lowbound:step:upbound; 
    
    if (axisOri == "x")
        mirror_xpoints = axisValue - (xpoints - axisValue);
        
        if (viewMode == "3D")
          plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot3(mirror_xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 2, "color", "m"), hold on
        else
          plot(xpoints, double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot(mirror_xpoints, double(f(xpoints)), "LineWidth", 5, "color", "m"), hold on
        end
    
    else %% Reflect across an axis parallel to y-axis.
        mirror_ypoints = axisValue - (double(f(xpoints)) - axisValue);
        
        if (viewMode == "3D")
          plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot3(xpoints, zeros(1, length(xpoints)),mirror_ypoints, "LineWidth", 5, "color", "m"), hold on
        else
          plot(xpoints, double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot(xpoints, mirror_ypoints, "LineWidth", 5, "color", "m"), hold on
        end
    end
end

