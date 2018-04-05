%% Cylinders with radii of points along f(x) = x, going upwards along z-axis. Also
% removed edge lines.
clf .

NumberOfPiles = 11; % Number of piles in cylinder
% Radius = 0; % Radius of cylinder
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:NumberOfPiles
    [x, y, z] = cylinder(i, NumberOfPoints); %i is the radius of a cylinder
    s = surf(x, y, z + i), hold on;
    set(s,'edgecolor','none')
end

%% Cylinders with radii of points along f(x) = x^2, going upwards parallel to z-axis.
clf
xpoints = 0:1:9;
ypoints = xpoints.^2;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)-1
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    surf(x + 1, y, z + i), hold on;
end

%% Garbage
clf
xpoints = 0:1:9;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)-1
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    x(2, :) = i + 1;
    surf(x, y, z), hold on;
end

%% Makes single cylinder of height 2 laying parallel to x-axis.
clf

[c1X,c1Y,c1Z] = cylinder;
cyl = surf(c1X, c1Y, 2*c1Z+1);   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90)                                                % <? ADD ?rotate? CALL

%% Making two disks of same thickness (cylinder height), one starting where the other one ends.
%  Make first one start at x=0, and second one at x=1, both laid down
%  parallel to x-axis.

clf
[c1X,c1Y,c1Z] = cylinder(4, 100);
cyl = surf(c1X+1.5, c1Y, c1Z+1), hold on;   % <? RETURN HANDLE
% rotate(cyl, [0 1 0], 90) % Rotates relative to the y-axis
xlabel('X')
ylabel('Y')
zlabel('Z')

[c1X,c1Y,c1Z] = cylinder(9, 100);
cyl2 = surf(c1X+2, c1Y+1, 2*c1Z+1), hold on;
% rotate(cyl2, [0 1 0], 90)
%% A simple cylinder, but shifted by 2 units of z-vertices downward.
clf

[c1X,c1Y,c1Z] = cylinder;
cyl = surf(c1X, c1Y, 2*c1Z), hold on;   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90)
xlabel('X')
ylabel('Y')
zlabel('Z')
cyl.ZData = cyl.ZData - 2;

%% Just a cylinder lying on its side, thanks to the rotate function
clf
[c2X,c2Y,c2Z] = cylinder(2, 50);
cyl2 = surf(2*c2X, c2Y, c2Z);   % <? RETURN HANDLE
rotate(cyl2, [0 1 0], 90) 
% rotate(cyl2, [0 0 1], 90) 
% rotate(cyl2, [1 0 0], 90) 


%% Experiment that didn't get what we want
clf
xpoints = 0:1:2;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    cyl = surf(x+i-.5, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

%% Some cylinders within each other, like Russian dolls.
clf
xpoints = 0:1:2;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    
    cyl = surf(x, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    
    cyl.XData(1, :) = 0;
    cyl.XData(2, :) = 1;
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

%% Sample of changing plot points of surf object.
clf

[X,Y,Z] = peaks(10);

surfObj = surf(X,Y,Z);
surfObj.XData = surfObj.XData+100;

%% Now testing modification of X-values to have anticipated X-coords of cylinder's face (cylinder 
% between x = 0 and x = 1). f(x) = x
clf
xpoints = 0:1:6;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    
    cyl = surf(x, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    
    cyl.XData(1, :) = i-1;
    cyl.XData(2, :) = i;
    
    % Also plotting a line parallel to z-axis to illustrate if z-placement
    % accurate, with length of each disk's radius
    plot3([i i], [0 0], [0 ypoints(i)]), hold on;
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

% Plotting function line f(x) = x in 3D.
threedYPoints = zeros(1, length(ypoints));
plot3(xpoints, threedYPoints, ypoints), hold on;

%Plotting axis of revolution, y = 0.

plot3(xpoints, zeros(1, length(ypoints)), zeros(1, length(ypoints)))

%% Anohter version of the above with f(x) = x^2.
clf

xpoints = 0:1:6;
ypoints = xpoints.^2;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    
    cyl = surf(x, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    
    cyl.XData(1, :) = i-1;
    cyl.XData(2, :) = i;
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    
    % Also plotting a line parallel to z-axis to illustrate if z-placement
    % accurate, with length of each disk's radius
    plot3([i i], [0 0], [0 ypoints(i)]), hold on;
end

% Plotting function line f(x) = x in 3D.
threedYPoints = zeros(1, length(ypoints));
plot3(xpoints, threedYPoints, ypoints), hold on;

%Plotting axis of revolution, y = 0.

plot3(xpoints, zeros(1, length(ypoints)), zeros(1, length(ypoints)))

%% Drawing a flat circle in the xyz environment, this one along the xy plane.
clf

C = [50,55, 60] ;   % center of circle 
R = 1. ;    % Radius of circle 
teta=0:0.01:2*pi ;
x=C(1)+R*cos(teta);
y=C(2)+R*sin(teta) ;
z = C(3)+zeros(size(x)) ;
patch(x,y,z,'k')
hold on
plot3(C(1),C(2),C(3),'*r')

%% Drawing a flat circle in the xyz environment, this one along the yz plane (as wanted in the samples above).
clf

C = [50,55, 60] ;   % center of circle 
R = 1. ;    % Radius of circle 
teta=0:0.01:2*pi ;
x=C(1)+R*cos(teta);
y=C(2)+zeros(size(x));
z = C(3)+ R*sin(teta);
patch(x,y,z,'k')
hold on
plot3(C(1),C(2),C(3),'*r')

xlabel('X')
ylabel('Y')
zlabel('Z')

%% Using code for circle and cylinder to draw a face on a rotated cylinder.
clf

[c1X,c1Y,c1Z] = cylinder(1, 50);
cyl = surf(c1X, c1Y, c1Z), hold on;   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90)

C = [-.5, 0, .5] ;   % center of circle, in sync with front face of cylinder
R = 1;    % Radius of circle 
teta=0:.01:2*pi;
x=C(1)+zeros(size(x));
y=C(2)+R*cos(teta); % Circle along yz plane, x-coords are all the same.
z = C(3)+ R*sin(teta);
patch(x,y,z,'b')
hold on

C = [.5, 0, .5] ;   % center of circle, in sync with back face of cylinder
R = 1;    % Radius of circle 
teta=0:.01:2*pi;
x=C(1)+zeros(size(x));
y=C(2)+R*cos(teta); % Circle along yz plane, x-coords are all the same.
z = C(3)+ R*sin(teta);
patch(x,y,z,'b')
hold on

xlabel('X')
ylabel('Y')
zlabel('Z')

%% Now using cylidners from f(x) = x with axis of y=1/2, draw a front face on them.
clf

clf
xpoints = 0:1:2;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    
    cyl = surf(x, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    
    cyl.XData(1, :) = i-1;
    cyl.XData(2, :) = i;
    
    C = [i, 0, .5] ;      % Center of circle, in sync with front face of cylinder
    R = ypoints(i);         % Radius of circle, which is the function's height.
    teta=0:.01:2*pi;
    cir_x = C(1)+zeros(size(teta));
    cir_y = C(2)+R*cos(teta);     % Circle along yz plane, x-coords are all the same.
    cir_z = C(3)+ R*sin(teta);
    patch(cir_x,cir_y,cir_z,'b')
    hold on
    
    % Also plotting a line parallel to z-axis to illustrate if z-placement
    % accurate, with length of each disk's radius
    plot3([i i], [0 0], [0 ypoints(i)]), hold on;
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

% Plotting function line f(x) = x in 3D.
threedYPoints = zeros(1, length(ypoints));
plot3(xpoints, threedYPoints, ypoints), hold on;

%Plotting axis of revolution, y = 0.

plot3(xpoints, zeros(1, length(ypoints)), zeros(1, length(ypoints)))

%% Same as above, now using midpoint to set disk radii.

clf
xpoints = 0:1:3;
step = 1;
radiiPoints = 0 + step/2:step:3 - step/2;
diskRadii = radiiPoints
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(diskRadii)
    [x, y, z] = cylinder(diskRadii(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    
    cyl = surf(x, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
    
    cyl.XData(1, :) = i-1;
    cyl.XData(2, :) = i;
    
    set(cyl,'edgecolor','none')
    
    C = [i, 0, .5] ;      % Center of circle, in sync with front face of cylinder
    R = diskRadii(i);         % Radius of circle, which is the function's height.
    teta=0:.01:2*pi;
    cir_x = C(1)+zeros(size(teta));
    cir_y = C(2)+R*cos(teta);     % Circle along yz plane, x-coords are all the same.
    cir_z = C(3)+ R*sin(teta);
    patch(cir_x,cir_y,cir_z,'b')
    hold on
    
    % Also plotting a line parallel to z-axis to illustrate if z-placement
    % accurate, with length of each disk's radius
    plot3([i i], [0 0], [0 diskRadii(i)]), hold on;
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

% Plotting function line f(x) = x in 3D.
threedYPoints = zeros(1, length(diskRadii));
plot3(xpoints, threedYPoints, diskRadii), hold on;

%Plotting axis of revolution, y = 0.

plot3(xpoints, zeros(1, length(diskRadii)), zeros(1, length(diskRadii)))

%% Ring so we can get an idea of how to make shells.

% Create a logical image of a ring with specified
% inner diameter, outer diameter center, and image size.
% First create the image.
imageSizeX = 640;
imageSizeY = 480;
[columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = 320;
centerY = 240;
innerRadius = 90;
outerRadius = 140;
array2D = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2;
ringPixels = array2D >= innerRadius.^2 & array2D <= outerRadius.^2;
% ringPixels is a 2D "logical" array.
% Now, display it.
image(ringPixels) ;
colormap([0 0 0; 1 1 1]);
title('Binary Image of a Ring', 'FontSize', 25);