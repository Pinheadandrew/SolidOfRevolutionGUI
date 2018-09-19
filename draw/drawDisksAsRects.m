function rectSet = drawDisksAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal, radiusMethod)
% Function to draw rectangles representing 2D perspective of disks
% comprising an approximate volume of a solid generated using integration,
% used by the disk method.
syms x
f(x) = str2sym(funcString);

steps = (upbound - lowbound)/subdivs;
rectBasePoints = lowbound:steps:upbound;

%X-points separated by disk width, which determine radii of shells.
if (radiusMethod == "m")
    xpoints = lowbound+(steps/2):steps:upbound-(steps/2);
elseif (radiusMethod == "l")
    xpoints = lowbound:steps:upbound-steps;
elseif (radiusMethod == "r")
    xpoints = lowbound+steps:steps:upbound;
end

if(axisOri =="y")
    specialCaseFor_quad = 0;
    
    %Special case when x^2 is function and bounds are non-positive.
    if (lowbound <= 0 && upbound <= 0 && funcString == "x^2")
        specialCaseFor_quad = 1;
    end
    % Area is within negative bounds of x-axis, and is function f(x) =
    % x
    if (lowbound <= 0 && upbound <= 0 && funcString == "x")
        % Axis of rotation BELOW area above curve in negative space, set outer radius to
        % aV and inner to |f(x) - aV|
        if(double(f(lowbound)) >= axisVal)
            innerRadius = abs(f(xpoints) - axisVal);
            outerRadius = abs(axisVal*ones(1,length(xpoints)));
            
            % Axis of rotation ABOVE area under curve in negative space, outer radius is
            % |aV - f(x)| within bounds and inner radius is
            % (function maxima within bounds) - aV.
        elseif (f(upbound) <= axisVal)
            % Add difference b/w axis value and f(lowbound) to inner radius
            if (axisVal <= 0)
                innerRadius = zeros(1, length(xpoints));
            else
                innerRadius = axisVal*ones(1,length(xpoints));
            end
            
            outerRadius = abs(axisVal - f(xpoints));
        end
        % Otherwise, if area under/above curve not f(x)=x bounded by negative
        % numbers along x-axis.
    else
        %Special case when x^2 is function and bounds are
        %non-positive.
        if (specialCaseFor_quad == 1)
            % Axis "above" the area of x^2 bound by negative x-bounds.
            if(double(f(lowbound)) <= axisVal)
                outerRadius = abs(axisVal*ones(1,length(xpoints)));
                innerRadius = abs(double(axisVal - f(xpoints)));
                
            % Axis "under" the area of x^2 bound by negative x-bounds.
            elseif(double(f(upbound)) >= axisVal)
                % Axis "between" f(lowbound) and y=0.
                if (axisVal >= 0)
                    innerRadius = zeros(1,length(xpoints));
                    % Axis "under" f(lowbound) and y=0.
                elseif (axisVal < 0)
                    innerRadius = zeros(1,length(xpoints)) - axisVal;
                end
                outerRadius = abs(double(axisVal - f(xpoints)));
            end
        else
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
            if(double(f(lowbound)) >= axisVal)
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisVal >= 0)
                    innerRadius = zeros(1,length(xpoints));
                else
                    innerRadius = zeros(1,length(xpoints)) - axisVal;
                    % innerArea = 0 - axisValue;
                end
                outerRadius = abs(double(axisVal - f(xpoints)));
                
                % Axis of rotation ABOVE area under curve, outer radius is axis
                % value minus minima of function within bounds.
            elseif (double(f(upbound)) <= axisVal)
                innerRadius = abs(axisVal - f(xpoints));
                outerRadius = abs(axisVal - f(lowbound))*ones(1,length(xpoints));
                outerRadius = outerRadius + f(lowbound); % <- Includes area "above" f(upperbound) in discs' radii.
            end
        end
    end
    % Turns radius values into numbers of double precision.
    innerRadius = double(innerRadius);
    outerRadius = double(outerRadius);

    xverts = [rectBasePoints(1:end-1); rectBasePoints(1:end-1);... 
        rectBasePoints(2:end); rectBasePoints(2:end)];
    
    % Rectangle for faces under and above the horizontal line.
    yverts_top = [axisVal+innerRadius; axisVal+outerRadius;...
        axisVal+outerRadius; axisVal+innerRadius];
    yverts_bottom = [axisVal - innerRadius; axisVal - outerRadius;...
        axisVal - outerRadius; axisVal - innerRadius];
    
    % Draws the top and bottom faces of the horizontally-facing
    % discs' cross sections along the xy-plane (or xz-plane in actual implementation).
%     patch(xverts, yverts_top, [0 0.902 0]);
%     patch(xverts, yverts_bottom, [0 0.902 0]);
else
   % If disk method along axis parallel to y-axis, get lengths of rectangles using
   % inverse of original function, perpendicular to the axis.
    g(x) = finverse(f(x));
    diskRadii = abs(double(g(xpoints)-axisVal));
    
    xverts = [axisVal-diskRadii; axisVal-diskRadii;...
                axisVal + diskRadii; axisVal + diskRadii];
            
    yverts = [rectBasePoints(1:end-1); rectBasePoints(2:end);...
                          rectBasePoints(2:end); rectBasePoints(1:end-1)];
end
% rectSet = patch(xverts, yverts, "b");
% hold on
patch(xverts, yverts_top, "b"); hold on
patch(xverts, yverts_bottom, "b"); hold on
end

