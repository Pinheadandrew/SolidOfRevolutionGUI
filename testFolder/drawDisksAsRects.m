function drawDisksAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal)
%DRAWDISKSASRECTS Summary of this function goes here
%   Detailed explanation goes here
% THIS WORKS IN REFLECTING AROUND AXIS PARALLEL TO X-AXIS
% Test file that draws rectangles representing disks viewed from the side, 
% their heights are the diameters of the disks. Flexible for any arbitrary 
% value as y-axis to rotate area around. Only works with 

% Supposed user inputs
axisOri = "y";

syms x
f(x) = str2sym(funcString);

steps = (upbound - lowbound)/subdivs;
midpoints = lowbound+(steps/2):steps:upbound-(steps/2);
xthings = lowbound:steps:upbound;

% Get heights of rectangles b/w axis and function line. Will use as disk
% radii, stretch the diameter to make area reflect across axis to simulate
% perpendicular rotation.
diskRadii = abs(double(f(midpoints) - axisVal));

axisLine = fplot(axisVal), hold on;
line = fplot(f(x)), hold on;
xlim([lowbound upbound]);

xverts = [xthings(1:end-1); xthings(1:end-1); xthings(2:end); xthings(2:end)];
% Use yverts to derive of way to get full height.
yverts = [axisVal-diskRadii; axisVal + diskRadii;...
            axisVal + diskRadii; axisVal - diskRadii];

patch(xverts, yverts, "b");
uistack(line, "top");
uistack(axisLine, "top");
end

