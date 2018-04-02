function drawDisksAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal)
% Function to draw rectangles representing 2D perspective of disks
% comprising an approximate volume of a solid generated using integration,
% used by the disk method.
syms x
f(x) = str2sym(funcString);

steps = (upbound - lowbound)/subdivs;
midpoints = lowbound+(steps/2):steps:upbound-(steps/2);
rectBasePoints = lowbound:steps:upbound;

if(axisOri =="y")
   % If disk method along axis parallel to x-axis, get heights of
   % rectangles which are equal to the diameters of the disks.
    diskRadii = abs(double(f(midpoints) - axisVal));

    xverts = [rectBasePoints(1:end-1); rectBasePoints(1:end-1);... 
        rectBasePoints(2:end); rectBasePoints(2:end)];
    
    yverts = [axisVal-diskRadii; axisVal + diskRadii;...
                axisVal + diskRadii; axisVal - diskRadii];
else
   % If disk method along axis parallel to y-axis, get lengths of rectangles using
   % inverse of original function, perpendicular to the axis.
    g(x) = finverse(f(x));
    diskRadii = abs(double(g(midpoints)-axisVal));
    
    xverts = [axisVal-diskRadii; axisVal-diskRadii;...
                axisVal + diskRadii; axisVal + diskRadii];
            
    yverts = [rectBasePoints(1:end-1); rectBasePoints(2:end);...
                          rectBasePoints(2:end); rectBasePoints(1:end-1)];
end
patch(xverts, yverts, "b");
end

