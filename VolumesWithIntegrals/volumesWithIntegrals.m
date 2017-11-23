% Practice using Disk method to find volumes of shapes model by solids of
% revolutions

syms x
f(x) = pi*(x)^2;
g(x) = int(f(x));
g(3) - g(0)

%% A(x) = pi*(f(x))^2
%  V(x) = int(A(x), 0, x))
syms x

f(x) = x;
A(x) = pi*(f(x))^2;
V(x) = int(A(x));
V(4);
double(V(8));
double(V(4))
f(x) = (1/2)*x;
A(x) = pi*(f(x))^2;
V(x) = int(A(x), 0, x);
double(V(8));

%% Calculating the volume of a solid rotated around the x-axis of
%  f = x from x = 1 to 5, using the Riemann's approach. The volume gets 
%  more accurate with a larger "diskcount" value.

diskcount = 100;

delta = (5-1)/diskcount;

xpoints = 0:delta:5-delta;

% Establish function, and collect given x-points
% that are separated by delta to generate their corresponding y-points.
syms x
f(x) = x;
ypoints = double(f(xpoints));

% Get cross-section areas of disks using pi * (y-point)^2 for each y-point. 
% Then, multiply it with delta, resulting in the volume of each disks, 
% which is stored as an element in a matrix fir output.

diskVolumes = (pi*ypoints.^2)*delta;
sum(diskVolumes)

%% Calculate volume of solid rotated around axis perpendicular to axis of revolution, 
% aka using the shell method. Return sum of shells to obtain approximate volume. 

shellcount = 10;

delta = (pi-pi/2)/shellcount;

xpoints = 0:delta:pi-delta;

syms x
f(x) = sin(x);
V(x) = 2*pi*int(x*(f(x)));