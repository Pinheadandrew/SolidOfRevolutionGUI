function plotDiscs(funcString, lowbound, upbound, cylsCount, y_axis_val)
%Testing drawing of solids of revolution using disc method, with area under function
% f(x) = x rotated around y=0. Input bounds of solid, along with number of
% discs to approximate the volume.
    
    syms x
    f(x) = str2sym(funcString);
    theta=0:pi/30:2*pi;
    
    diskWidth = (upbound-lowbound)/cylsCount; %<- Thickness of each disk
    cylMargins = lowbound:diskWidth:upbound;
    midpoints = lowbound+(diskWidth/2):diskWidth:upbound-(diskWidth/2);
    % Using midpoint rule of each subinterval along axis to get radius of
    % disc using height of function at the midpoint.
    
    diskRadii = abs(double(f(midpoints)-y_axis_val)); % Vector storing radius of each disc.
    
    for i = 1:length(diskRadii)
      [x, y, z] = cylinder(diskRadii(i), length(theta)-1); %The function at x (in this loop, i) is the radius of a cylinder
      cyl = surf(x, y, z); 
      hold on
      rotate(cyl, [0 1 0], 90)
      
      cyl.XData(1, :) = cylMargins(i);
      cyl.XData(2, :) = cylMargins(i+1);
      
      z_distance = y_axis_val + diskRadii(i)*sin(theta);
      y_distance = diskRadii(i)*cos(theta);
      
      % Setting Z and Y coords so the points of cylinder's edge are equal
      % distance from the axis of rotation.

       cyl.YData(1, :) = y_distance;
       cyl.YData(2, :) = y_distance;
       cyl.ZData(1, :) = z_distance;
       cyl.ZData(2, :) = z_distance;
       
       cir_x_1 = cylMargins(i)+zeros(size(theta));
       cir_x_2 = cylMargins(i+1)+zeros(size(theta));
       cir_y = y_distance;
       cir_z = z_distance;
       
       %Draws both front and back faces of each disc.
       patch(cir_x_1,cir_y,cir_z,	[0.4660, 0.6740, 0.1880]);
       patch(cir_x_2,cir_y,cir_z,	[0.4660, 0.6740, 0.1880]);
       set(cyl,'edgecolor','none')
    end
    
%     plot3(cylMargins, zeros(1, length(cylMargins)), double(f(cylMargins)), ...
%       "LineWidth", 2, "Color", "r");
    % Draws axis of rotation
    axisLims = [cylMargins(1)-1 cylMargins(end)+1];
    plot3(axisLims, zeros(1, length(axisLims)), y_axis_val*ones(1, length(axisLims)),...
      "LineWidth", 2, "Color", "b")
    xlim(axisLims);
    xlabel('X')
    ylabel('Z')
    zlabel('f(X)')
end

