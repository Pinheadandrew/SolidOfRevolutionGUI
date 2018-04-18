function plotDiscs2(funcString, lowbound, upbound, cylsCount, y_axis)
%Testing drawing of solids of revolution using disc method, with area under/above specified 
% symbolic expression of x rotated around x=0. Input bounds of solid, along with number of
% discs to approximate the volume.
    clf
    syms x
    f(x) = finverse(str2sym(funcString));
    theta=0:pi/30:2*pi;
    
    diskWidth = (upbound-lowbound)/cylsCount; %<- Thickness of each disk
    cylMargins = lowbound:diskWidth:upbound;
    midpoints = lowbound+(diskWidth/2):diskWidth:upbound-(diskWidth/2);
    % Using midpoint rule of each subinterval along axis to get radius of
    % disc using height of function at the midpoint.
    
    diskRadii = double(f(midpoints)); % Vector storing radius of each disc.
    
    for i = 1:length(diskRadii)
      [x, y, z] = cylinder(diskRadii(i), length(theta)-1); %The function at x (in this loop, i) is the radius of a cylinder
      cyl = surf(x, y, z); 
      hold on

      cyl.ZData(1, :) = cylMargins(i);
      cyl.ZData(2, :) = cylMargins(i+1);
      
      x_distance = diskRadii(i)*cos(theta);
      y_distance = diskRadii(i)*sin(theta);
      
      % Setting Z and Y coords so the points of cylinder's edge are equal
      % distance from the axis of rotation.

       cyl.YData(1, :) = y_distance;
       cyl.YData(2, :) = y_distance;
       cyl.XData(1, :) = x_distance;
       cyl.XData(2, :) = x_distance;
       
       cir_z_1 = cylMargins(i)+zeros(size(theta));
       cir_z_2 = cylMargins(i+1)+zeros(size(theta));
       cir_x = x_distance;
       cir_y = y_distance;
       
       %Draws both front and back faces of each disc.
       patch(cir_x,cir_y,cir_z_1,	[0.4660, 0.6740, 0.1880])
       patch(cir_x,cir_y,cir_z_2,	[0.4660, 0.6740, 0.1880])
       set(cyl,'edgecolor','none')
    end
    
    %plot3(midpoints, zeros(1, length(midpoints)), diskRadii, "LineWidth", 2, "Color", "r") 
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end
