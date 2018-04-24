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
   % If disk method along axis parallel to x-axis, get heights of
   % rectangles which are equal to the diameters of the disks.
    diskRadii = abs(double(f(xpoints) - axisVal));

    xverts = [rectBasePoints(1:end-1); rectBasePoints(1:end-1);... 
        rectBasePoints(2:end); rectBasePoints(2:end)];
    
    yverts = [axisVal-diskRadii; axisVal + diskRadii;...
                axisVal + diskRadii; axisVal - diskRadii];
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
rectSet = patch(xverts, yverts, "b");
end

