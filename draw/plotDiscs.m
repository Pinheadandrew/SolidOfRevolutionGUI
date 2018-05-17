function plotDiscs(funcString, lowbound, upbound, cylsCount, axisOri, axisVal, fullCircles, radiusMethod)
% Drawing of solids of revolution using disc method, with area under function
% argument funcString rotated perpendicularly around axis. Input are bounds of solid, 
% number of discs to approximate the volume, axis orientation and axis value.

    syms x
    f(x) = str2sym(funcString);
    
    diskWidth = (upbound-lowbound)/cylsCount; %<- Thickness of each disk
    cylMargins = lowbound:diskWidth:upbound;
    
    %X-points separated by disk width, which determine radii of shells.
    if (radiusMethod == "m")
        xpoints = lowbound+(diskWidth/2):diskWidth:upbound-(diskWidth/2);
    elseif (radiusMethod == "l")
        xpoints = lowbound:diskWidth:upbound-diskWidth;
    elseif (radiusMethod == "r")
        xpoints = lowbound+diskWidth:diskWidth:upbound;
    end
    
    % Based on option for a full or half solid, determine the points of
    % the disc's edges, based on axis orientation to rotate around.
    if (fullCircles == 1)
      theta=0:pi/30:2*pi;
    else
      if (axisOri == "x")
        theta=0:pi/60:pi;
      else
        theta = -pi/2:pi/60:pi/2;
      end
    end
    
    if (axisOri == "y")
        diskRadii = abs(double(f(xpoints)-axisVal)); % Vector storing radius of each disc.
        
        for i = 1:length(diskRadii)
            [x, y, z] = cylinder(diskRadii(i), length(theta)-1); %The function at x (in this loop, i) is the radius of a cylinder
            cyl = surf(x, y, z);
            cyl.FaceColor = [0 0.902 0];
            hold on
            rotate(cyl, [0 1 0], 90)
            
            cyl.XData(1, :) = cylMargins(i);
            cyl.XData(2, :) = cylMargins(i+1);
            
            y_distance = diskRadii(i)*cos(theta);
            z_distance = axisVal + diskRadii(i)*sin(theta);
            
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
            patch(cir_x_1,cir_y,cir_z, [0 0.902 0]);
            patch(cir_x_2,cir_y,cir_z, [0 0.902 0]);
            set(cyl,'edgecolor','none')
        end
    else
        g(x) = finverse(f);
        diskRadii = double(g(xpoints)-axisVal); % Vector storing radius of each disc.
        
        for i = 1:length(diskRadii)
            [x, y, z] = cylinder(diskRadii(i), length(theta)-1); %The function at x (in this loop, i) is the radius of a cylinder
            cyl = surf(x, y, z);
            cyl.FaceColor = [0 0.902 0];
            hold on
            
            cyl.ZData(1, :) = cylMargins(i);
            cyl.ZData(2, :) = cylMargins(i+1);
            
            x_distance = axisVal + diskRadii(i)*cos(theta);
            y_distance = diskRadii(i)*sin(theta);
            
            % Setting X and Y coords so the points of cylinder's edge are equal
            % distance from the axis of rotation. Z points don't change
            % throughout each cylinder face.
            
            cyl.YData(1, :) = y_distance;
            cyl.YData(2, :) = y_distance;
            cyl.XData(1, :) = x_distance;
            cyl.XData(2, :) = x_distance;
            
            cir_z_1 = cylMargins(i)+zeros(size(theta));
            cir_z_2 = cylMargins(i+1)+zeros(size(theta));
            cir_x = x_distance;
            cir_y = y_distance;
            
            %Draws both front and back faces of each disc.
            patch(cir_x,cir_y,cir_z_1, [0 0.902 0])
            patch(cir_x,cir_y,cir_z_2,	[0 0.902 0])
            set(cyl,'edgecolor','none')
        end
    end
      % Drawing rectangles to fill faces of shells' as they're cut on
      % xy-plane. If axis parallel to x-axis, get heights of 
      % rectangles which are equal to the diameters of the disks. Else,
      % get radius of disks which are "lengths" of rectangles.
      if (fullCircles == 0)
        if (axisOri == "y")
          xverts = [cylMargins(1:end-1); cylMargins(1:end-1);...
            cylMargins(2:end); cylMargins(2:end)];

          yverts = [axisVal-diskRadii(1:end); axisVal+diskRadii(1:end);...
            axisVal+diskRadii(1:end); axisVal-diskRadii(1:end)];

          %Patching the rectangles to "fill" the inside of the shells.
        else
          xverts = [axisVal-diskRadii(1:end); axisVal-diskRadii(1:end);...
                axisVal + diskRadii(1:end); axisVal + diskRadii(1:end)];
            
          yverts = [cylMargins(1:end-1); cylMargins(2:end);...
                cylMargins(2:end); cylMargins(1:end-1)];
        end
        patch(xverts, zeros(size(xverts)), yverts, [0 0.902 0]);
      end
end

