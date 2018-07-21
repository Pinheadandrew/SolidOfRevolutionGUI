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
        % If axis of rotation not equal to function's height at lower or
        % upperbound, use the washer method to rotate area under curve
        % around axis.
        if (axisVal >= f(lowbound) || axisVal <= f(upbound))
            
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
            if(double(f(lowbound)) >= axisVal)
                innerRadius = abs(double(axisVal - f(lowbound)))*ones(1,length(xpoints));
                outerRadius = abs(double(axisVal - f(xpoints)));
                
                % Axis of rotation ABOVE area under curve, outer radius is axis
                % value minus minima of function within bounds.
            elseif (double(f(upbound)) <= axisVal)
                innerRadius = abs(double(axisVal - f(xpoints)));
                outerRadius = abs(double(axisVal - f(lowbound)))*ones(1,length(xpoints));
            end
            
            % Loop that draws the discs that look like shells. They change
            % in difference b/w outer and inner radius.
            for i=1:length(cylMargins)-1
                [x1, y1, z1] = cylinder(innerRadius(i), length(theta)-1);
                [x2, y2, z2] = cylinder(outerRadius(i), length(theta)-1);
                
                innerFace = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
                outerFace = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
                
                rotate(innerFace, [0 1 0], 90);
                rotate(outerFace, [0 1 0], 90);
                
                % Coordinate for axis-line. Used to determine radius and
                % displacement of cylinders in 3D coordinate system.=
                
                inner_y = innerRadius(i)*cos(theta);
                outer_y = outerRadius(i)*cos(theta);
%                 inner_y = axisVal + innerRadius(i)*cos(theta);
%                 outer_y = axisVal + outerRadius(i)*cos(theta);
                inner_z = axisVal + innerRadius(i)*sin(theta);
                outer_z = axisVal + outerRadius(i)*sin(theta);
                
                innerFace.YData(1, :)= inner_y;
                innerFace.YData(2, :)= inner_y;
                innerFace.ZData(1, :)= inner_z;
                innerFace.ZData(2, :)= inner_z;
                innerFace.XData(1, :) = cylMargins(i);
                innerFace.XData(2, :) = cylMargins(i+1);
                
                outerFace.YData(1, :)= outer_y;
                outerFace.YData(2, :)= outer_y;
                outerFace.ZData(1, :)= outer_z;
                outerFace.ZData(2, :)= outer_z;
                outerFace.XData(1, :) = cylMargins(i);
                outerFace.XData(2, :) = cylMargins(i+1);
                
                % Patching rings on the left and the right faces of the shells.
                leftRing = patch(cylMargins(i)*ones(1, 2*length(theta)), ...
                    [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
                leftRing.EdgeColor = 'none';
                rightRing = patch(cylMargins(i+1)*ones(1, 2*length(theta)), ...
                    [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
                rightRing.EdgeColor = 'none';
                
                %Drawing circles for edges of left and right sides of discs.
                plot3(cylMargins(i)*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
                plot3(cylMargins(i+1)*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
                plot3(cylMargins(i)*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
                plot3(cylMargins(i+1)*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
            end
            
        else
            diskRadii = abs(double(f(xpoints)-axisVal)); % Vector storing radius of each disc.
            
            % Draw disks w/o area subtracted from within.
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
        end
        diskRadii = abs(double(f(xpoints)-axisVal)); % Vector storing radius of each disc.
        
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

