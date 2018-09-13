function plotWithReflection(funcString, lowbound, upbound, axisOri, axisValue, viewMode, domain)
    syms x
    f(x) = str2sym(funcString);
    
    %Points along domain that plot is result of.  If domain is y, use
    %inverse function of f(x) to determine new bounds of the plot, along
    %with points along domain 
    if (domain == "x")
        step = (upbound-lowbound)/100;
        xpoints = lowbound:step:upbound;
    else
        g(x) = finverse(f);
        
        if(isnan(double(g(lowbound))))
            lowbound = .0000001;
        end
        
        lowbound = g(lowbound);
        upbound = g(upbound);
        step = (upbound-lowbound)/100;
        xpoints = lowbound:step:upbound;
    end
    
    if (axisOri == "x") %% Reflect function plot across an axis parallel to y-axis.
        mirror_xpoints = axisValue - (xpoints - axisValue);
        
        if (viewMode == "3D")
          origPlot = plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"); hold on
          mirrorPlot = plot3(mirror_xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "m"); hold on
          vertAxisBounds = zlim;
          axis = plot3(axisValue*ones(1,2), zeros(1, 2), [vertAxisBounds(1) vertAxisBounds(2)], "LineWidth", 5,...
              "color", "b", "LineStyle", "--"); hold on
        else
          origPlot = plot(xpoints, double(f(xpoints)), "LineWidth", 2, "color", "r"); hold on
          mirrorPlot = plot(mirror_xpoints, double(f(xpoints)), "LineWidth", 2, "color", "m"); hold on
          vertAxisBounds = ylim;
          axis = plot(axisValue*ones(1,2), vertAxisBounds, "LineWidth", 2, "color", "g");
          hold on
          axis.LineStyle = '-.';
        end
    
    else %% Reflect across an axis parallel to x-axis.
        mirror_ypoints = axisValue - (double(f(xpoints)) - axisValue);
        
        if (viewMode == "3D")
          origPlot = plot3(xpoints, zeros(1, length(xpoints)), double(f(xpoints)), "LineWidth", 5, "color", "r"); hold on
          mirrorPlot = plot3(xpoints, zeros(1, length(xpoints)),mirror_ypoints, "LineWidth", 5, "color", "m"); hold on
          horizAxisBounds = xlim;
          axis = plot3([horizAxisBounds(1) horizAxisBounds(2)], zeros(1, 2), axisValue*ones(1,2), "LineWidth", 5,...
              "color", "b", "LineStyle", "--"); hold on
        else
          origPlot = plot(xpoints, double(f(xpoints)), "LineWidth", 2, "color", "r"); hold on
          mirrorPlot = plot(xpoints, mirror_ypoints, "LineWidth", 2, "color", "m"); hold on
          horizAxisBounds = xlim;
          axis = plot(horizAxisBounds, axisValue*ones(1,2), "LineWidth", 2, "color", "g"); hold on
          axis.LineStyle = '-.';
        end
    end
     leg = legend([origPlot, mirrorPlot, axis], "f(x) = " + funcString, "f(x) mirrored", "Axis of rotation", 'location', 'northeast');
     leg.FontSize = 12;
     uistack(leg,"top")
     
     if (viewMode == "3D")
         origXLims = xlim;
         origYLims = zlim;
         xAxis = plot3(origXLims, zeros(1, 2), zeros(1, 2), "LineWidth", 3, "color", [0 0 0]); hold on
         yAxis = plot3(zeros(1, 2), zeros(1, 2), origYLims, "LineWidth", 3, "color", [0 0 0]); hold on
         xlim(origXLims)
         zlim(origYLims)
     elseif (viewMode == "2D")
         origXLims = xlim;
         origYLims = ylim;
         xAxis = plot(origXLims, zeros(1, 2), "LineWidth", 2, "color", [0 0 0]); hold on
         yAxis = plot(zeros(1, 2), origYLims, "LineWidth", 2, "color", [0 0 0]); hold on
         xlim(origXLims)
         ylim(origYLims)
     end
end

