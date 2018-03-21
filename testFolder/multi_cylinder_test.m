NumberOfPiles = 11; % Number of piles in cylinder
% Radius = 0; % Radius of cylinder
NumberOfPoints = 100; % Number of points to control smoothness of sylinder curve, more points better smoothness
for i = 1:NumberOfPiles
    [x, y, z] = cylinder(i, NumberOfPoints); %i is the radius of a cylinder
    surf(x, y, z + i), hold on
end