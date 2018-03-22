function drawDisksAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal)
% THIS WORKS IN REFLECTING AROUND AXIS PARALLEL TO X-AXIS
% Test file that draws rectangles representing disks viewed from the side, 
% their heights are the diameters of the disks. Flexible for any arbitrary 
% value as y-axis to rotate area around. Only works with 
syms x
f(x) = str2sym(funcString);

steps = (upbound - lowbound)/subdivs;
midpoints = lowbound+(steps/2):steps:upbound-(steps/2);
rectAxisPoints = lowbound:steps:upbound;

%FOR TESTING FUNCTION BY ITSELF:
if(axisOri =="y")
    diskRadii = abs(double(f(midpoints) - axisVal));

    xverts = [rectAxisPoints(1:end-1); rectAxisPoints(1:end-1);... 
        rectAxisPoints(2:end); rectAxisPoints(2:end)];
    yverts = [axisVal-diskRadii; axisVal + diskRadii;...
                axisVal + diskRadii; axisVal - diskRadii];
%     fplot(axisVal, [lowbound upbound], "g");
else
    g(x) = finverse(f(x));
    diskRadii = abs(double(g(midpoints)-axisVal));
%     fplot(f(x), [double(g(lowbound)), double(g(upbound))], "r"), hold on;
    xverts = [axisVal-diskRadii; axisVal-diskRadii;...
                axisVal + diskRadii; axisVal + diskRadii];
    yverts = [rectAxisPoints(1:end-1); rectAxisPoints(2:end);...
                          rectAxisPoints(2:end); rectAxisPoints(1:end-1)];
end
patch(xverts, yverts, "b");
end

