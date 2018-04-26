function plotWithReflection(funcString, lowbound, upbound,  axisOri, axisValue, viewMode)
    syms x
    f(x) = str2sym(funcString);
    
    step = (upbound-lowbound)/100;
    xpoints = lowbound:step:upbound; 
    
    if (axisOri == "x") %% Reflect function plot across an axis parallel to y-axis.
        mirror_xpoints = axisValue - (xpoints - axisValue);
        
        if (viewMode == "3D")
          plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot3(mirror_xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "m"), hold on
          vertAxisBounds = zlim;
          plot3(axisValue*ones(1,2), zeros(1, 2), [vertAxisBounds(1)-1 vertAxisBounds(2)+1], "LineWidth", 5, "color", "b"), hold on
        else
          plot(xpoints, double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot(mirror_xpoints, double(f(xpoints)), "LineWidth", 5, "color", "m"), hold on
          vertAxisBounds = xlim;
          plot([vertAxisBounds(1)-1 vertAxisBounds(2)+1], axisValue*ones(1,2), "LineWidth", 5, "color", "b"), hold on
        end
    
    else %% Reflect across an axis parallel to x-axis.
        mirror_ypoints = axisValue - (double(f(xpoints)) - axisValue);
        
        if (viewMode == "3D")
          plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot3(xpoints, zeros(1, length(xpoints)),mirror_ypoints, "LineWidth", 5, "color", "m"), hold on
          horizAxisBounds = xlim;
          plot3([horizAxisBounds(1)-1 horizAxisBounds(2)+1], zeros(1, 2), axisValue*ones(1,2), "LineWidth", 5, "color", "b"), hold on
        else
          plot(xpoints, double(f(xpoints)), "LineWidth", 5, "color", "r"), hold on
          plot(xpoints, mirror_ypoints, "LineWidth", 5, "color", "m"), hold on
          horizAxisBounds = xlim;
          plot([horizAxisBounds(1)-1 horizAxisBounds(2)+1], axisValue*ones(1,2), "LineWidth", 5, "color", "b"), hold on
        end
    end
end

