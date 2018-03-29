clf

NumberOfPiles = 11; % Number of piles in cylinder
% Radius = 0; % Radius of cylinder
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:NumberOfPiles
    [x, y, z] = cylinder(i, NumberOfPoints); %i is the radius of a cylinder
    s = surf(x, y, z + i), hold on;
    set(s,'edgecolor','none')
end

%%
clf
xpoints = 0:1:9;
ypoints = xpoints.^2;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)-1
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    surf(x + 1, y, z + i), hold on;
end

%%
clf
xpoints = 0:1:9;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)-1
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    x(2, :) = i + 1;
    surf(x, y, z), hold on;
end

%%
clf

[c1X,c1Y,c1Z] = cylinder;
cyl = surf(c1X+1, c1Y+1, 2*c1Z+1);   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90)                                                % <? ADD ?rotate? CALL

%% Making two disks of same thickness (cylinder height). 
clf
[c1X,c1Y,c1Z] = cylinder(4, 100);
cyl = surf(c1X, c1Y, 2*c1Z), hold on;   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90) % Rotates relative to the y-axis
xlabel('X')
ylabel('Y')
zlabel('Z')

[c1X,c1Y,c1Z] = cylinder(9, 100);
cyl = surf(c1X+2, c1Y+1, 2*c1Z), hold on;
%rotate(cyl, [0 1 0], 90)
%%
clf

[c1X,c1Y,c1Z] = cylinder;
cyl = surf(c1X+1, c1Y+1, 2*c1Z+1), hold on;   % <? RETURN HANDLE
rotate(cyl, [0 1 0], 90)                                                % <? ADD ?rotate? CALL
[c2X,c2Y,c2Z] = cylinder(2, 50);
cyl2 = surf(2*c2X, c2Y, c2Z);   % <? RETURN HANDLE
rotate(cyl2, [0 1 0], 90) 
% rotate(cyl2, [0 0 1], 90) 
% rotate(cyl2, [1 0 0], 90) 


%%
clf
xpoints = 0:1:9;
ypoints = xpoints;
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:length(ypoints)-1
    [x, y, z] = cylinder(ypoints(i), NumberOfPoints); %The function at x (in this loop, i) is the radius of a cylinder
    cyl = surf(x+i, y, z); hold on;
    rotate(cyl, [0 1 0], 90)
end