function plotDiscs(funcString, lowbound, upbound, cylsCount, axisOri, axisVal, fullCircles, radiusMethod)
% Drawing of solids of revolution using disc method, with area under function
% argument funcString rotated perpendicularly around axis. Input are bounds of solid,
% number of discs to approximate the volume, axis orientation and axis value.

syms x
f(x) = str2sym(funcString);

diskWidth = (upbound-lowbound)/cylsCount; %<- Thickness of each disk
cylMargins = lowbound:diskWidth:upbound; %<- Difference between disks within bounds

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

% Area under/above curve rotated aroudn horizontal axis.
if (axisOri == "y")
    
    % If axis of rotation not equal to function's height at lower or
    % upperbound, use the washer method to rotate area under curve
    % around axis.
    if (axisVal >= f(lowbound) || axisVal <= f(upbound))
        disp("1")
        % Area is within negative bounds of x-axis, and is function f(x) =
        % x
        if (lowbound <= 0 && upbound <= 0 && funcString == "x")
            disp("2")
            % Axis of rotation BELOW area above curve in negative space, set outer radius to
            % aV and inner to |f(x) - aV|
            if(double(f(lowbound)) >= axisVal)
                disp("3")
                innerRadius = abs(f(xpoints) - axisVal);
                outerRadius = abs(axisVal*ones(1,length(xpoints)));
                
                % Axis of rotation ABOVE area under curve in negative space, outer radius is 
                % |aV - f(x)| within bounds and inner radius is
                % (function maxima within bounds) - aV.
            elseif (f(upbound) <= axisVal)
                disp("4")
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisVal <= 0)
                    disp("5")
                    innerRadius = zeros(1, length(xpoints));
%                     innerRadius = axisVal*ones(1,length(xpoints));
                else
                    disp("6")
%                     innerRadius = zeros(1, length(xpoints)) - axisVal;
                    innerRadius = axisVal*ones(1,length(xpoints));
                end
                
                outerRadius = abs(axisVal - f(xpoints));
            end
            % Otherwise, if area under/above curve not f(x) bounded by negative
            % numbers along x-axis.
        else
            disp("7")
            % Axis of rotation BELOW area under curve, set outer radius to
            % function line.
            if(double(f(lowbound)) >= axisVal)
                disp("8")
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisVal >= 0)
                    disp("9")
                    % innerArea = 0;
                    innerRadius = zeros(1,length(xpoints));
                else
                    disp("10")
                    innerRadius = zeros(1,length(xpoints)) - axisVal;
                    % innerArea = 0 - axisValue;
                end
                outerRadius = abs(double(axisVal - f(xpoints)));

                % Axis of rotation ABOVE area under curve, outer radius is axis
                % value minus minima of function within bounds.
            elseif (double(f(upbound)) <= axisVal)
                disp("11")
                innerRadius = abs(double(axisVal - f(xpoints)));
                outerRadius = abs(double(axisVal - f(lowbound)))*ones(1,length(xpoints));
            end
        end
        % Turns radius values into numbers of double precision.
        innerRadius = double(innerRadius);
        outerRadius = double(outerRadius);
        
        % Loop that draws the discs that look like shells. They change
        % in difference b/w outer and inner radius.
        for i=1:length(cylMargins)-1
            
            [x1, y1, z1] = cylinder(double(innerRadius(i)), length(theta)-1);
            [x2, y2, z2] = cylinder(double(outerRadius(i)), length(theta)-1);
           
            innerFace = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            outerFace = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            
            rotate(innerFace, [0 1 0], 90);
            rotate(outerFace, [0 1 0], 90);
            
            % Coordinate for axis-line. Used to determine radius and
            % displacement of cylinders in 3D coordinate system. Matrices
            % of Y and Z points that encompass points 
            
            inner_y = innerRadius(i)*cos(theta);
            outer_y = outerRadius(i)*cos(theta);
            inner_z = axisVal + innerRadius(i)*sin(theta);
            outer_z = axisVal + outerRadius(i)*sin(theta);
            
            inner_y = double(inner_y);
            outer_y = double(outer_y);
            inner_z = double(inner_z);
            outer_z = double(outer_z);
            
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
            
            % Patching faces on the left and the right faces of the
            % horizontally-facing cylinders.
            topFace = patch(cylMargins(i)*ones(1, 2*length(theta)), ...
                [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
            topFace.EdgeColor = 'none';
            bottomFace = patch(cylMargins(i+1)*ones(1, 2*length(theta)), ...
                [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
            bottomFace.EdgeColor = 'none';
            
            % Drawing rectangles to fill inside of disks as they're cut on
            % xy-plane. If axis perpendicular to y-axis, get inner radius,
            % rectangles which are equal to the diameters of the disks. 
            if (fullCircles == 0)
                xverts = [cylMargins(i); cylMargins(i);...
                    cylMargins(i+1); cylMargins(i+1)];
                
                % Rectangle for faces under and above the horizontal line.
                yverts_top = [axisVal+innerRadius(i); axisVal+outerRadius(i);...
                    axisVal+outerRadius(i); axisVal+innerRadius(i)];
                yverts_bottom = [axisVal - innerRadius(i); axisVal - outerRadius(i);...
                    axisVal - outerRadius(i); axisVal - innerRadius(i)];
               
                % Draws the top and bottom faces of the horizontally-facing
                % discs' cross sections along the xy-plane (or xz-plane in actual implementation).
                patch(xverts, zeros(size(xverts)), yverts_top, [0 0.902 0]);
                patch(xverts, zeros(size(xverts)), yverts_bottom, [0 0.902 0]);
            end
            
            %Drawing circles for edges of left and right sides of discs.
            plot3(cylMargins(i)*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
            plot3(cylMargins(i+1)*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
            plot3(cylMargins(i)*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
            plot3(cylMargins(i+1)*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
        end
    else % If no difference b/w a bound and axis of rotation, draw regular disks.
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
        % Drawing rectangles to fill faces of shells' as they're cut on
        % xy-plane. If axis parallel to x-axis, get heights of 
        % rectangles which are equal to the diameters of the disks. Else,
        % get radius of disks which are "lengths" of rectangles.
        if (fullCircles == 0)
          xverts = [cylMargins(1:end-1); cylMargins(1:end-1);...
            cylMargins(2:end); cylMargins(2:end)];

          yverts = [axisVal-diskRadii(1:end); axisVal+diskRadii(1:end);...
            axisVal+diskRadii(1:end); axisVal-diskRadii(1:end)];

          %Patching the rectangles to "fill" the inside of the discs.
            patch(xverts, zeros(size(xverts)), yverts, "b");
        end
    end
    
% Branch where the area is being rotated around a vertical axis.   
elseif (axisOri == "x")
    g(x) = finverse(f);
    
    % Axis of rotation must be outside bounds or at a bound point.
    if (axisVal <= g(lowbound) || axisVal >= g(upbound))
        
        % Axis of rotation to the left of area under curve, inner radius is
        % function line.
        if(axisVal <= g(lowbound))
            
            % Negative bounds, inner/outer radii evaluated differently
            if (g(lowbound) <= 0 && g(upbound) <= 0 )
                innerRadius = abs(double(axisVal - g(lowbound)))*ones(1,length(xpoints));
                outerRadius = abs(double(axisVal - g(xpoints))); 
            else
                innerRadius = abs(double(axisVal - g(xpoints)));
                outerRadius = abs(double(axisVal - g(upbound)))*ones(1,length(xpoints));
            end
            
        % Axis of rotation to right of area under curve, outer radius is axis
        % value minus minima of function within bounds.
        elseif (axisVal >= g(upbound))
            if (g(lowbound) <= 0 && g(upbound) <= 0 )
                outerRadius = abs(double(axisVal - g(lowbound)))*ones(1,length(xpoints));
                innerRadius = abs(double(axisVal - g(xpoints))); 
            else
                innerRadius = abs(double(axisVal - g(upbound)))*ones(1,length(xpoints));
                outerRadius = abs(double(axisVal - g(xpoints)));
            end
        end
        
        % Loop that draws the discs that look like shells. They change
        % in difference b/w outer and inner radius.
        for i=1:length(xpoints)
            [x1, y1, z1] = cylinder(innerRadius(i), length(theta)-1);
            [x2, y2, z2] = cylinder(outerRadius(i), length(theta)-1); 
            
            innerFace = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            outerFace = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            
            % Coordinate for axis-line. Used to determine radius and
            % displacement of cylinders in 3D coordinate system.=
            
            inner_x = axisVal + innerRadius(i)*cos(theta);
            outer_x = axisVal + outerRadius(i)*cos(theta);
            inner_y = innerRadius(i)*sin(theta);
            outer_y = outerRadius(i)*sin(theta);
            
            innerFace.XData(1, :)= inner_x;
            innerFace.XData(2, :)= inner_x;
            innerFace.YData(1, :)= inner_y;
            innerFace.YData(2, :)= inner_y;
            innerFace.ZData(1, :) = double(f(lowbound));
            innerFace.ZData(2, :) = cylMargins(i+1);
            
            outerFace.XData(1, :)= outer_x;
            outerFace.XData(2, :)= outer_x;
            outerFace.YData(1, :)= outer_y;
            outerFace.YData(2, :)= outer_y;
            outerFace.ZData(1, :) = cylMargins(i);
            outerFace.ZData(2, :) = cylMargins(i+1);
            
            %Drawing faces to fill top and bottom of discs.
            bottomFace = patch([outer_x,inner_x], ...
                [outer_y,inner_y], cylMargins(i)*ones(1, 2*length(theta)),[0 0.902 0]); 
            bottomFace.EdgeColor = 'none';
            topFace = patch([outer_x,inner_x], ...
                [outer_y,inner_y], cylMargins(i+1)*ones(1, 2*length(theta)),[0 0.902 0]);
            topFace.EdgeColor = 'none';
            
            if (fullCircles == 0)
                % Rectangle for faces under and above the horizontal line.
                xverts_left = [axisVal-outerRadius(i); axisVal-outerRadius(i);...
                    axisVal-innerRadius(i); axisVal-innerRadius(i)];
                xverts_right= [axisVal + innerRadius(i); axisVal + innerRadius(i);...
                    axisVal + outerRadius(i); axisVal + outerRadius(i)];
                
                yverts = [cylMargins(i); cylMargins(i+1);...
                    cylMargins(i+1); cylMargins(i)];
                patch(xverts_left, zeros(size(xverts_left)), yverts, [0 0.902 0]);
                patch(xverts_right, zeros(size(xverts_right)), yverts, [0 0.902 0]);
            end

            %Drawing circles for edges of left and right sides of discs.
            plot3(inner_x, inner_y, cylMargins(i)*ones(1, length(theta)), "black"), hold on
            plot3(inner_x, inner_y, cylMargins(i+1)*ones(1, length(theta)), "black"), hold on
            plot3(outer_x, outer_y, cylMargins(i)*ones(1, length(theta)), "black"), hold on
            plot3(outer_x, outer_y, cylMargins(i+1)*ones(1, length(theta)), "black"), hold on
        end
    else % If no difference b/w axis of rotation and a bound, plot discs without
         % inner radius to subtract from their areas.
        diskRadii = abs(double(g(xpoints)-axisVal)); % Vector storing radius of each disc.
        
        % Draw disks w/o area subtracted from within.
        for i = 1:length(diskRadii)
            [x, y, z] = cylinder(diskRadii(i), length(theta)-1); %The function at x (in this loop, i) is the radius of a cylinder
            cyl = surf(x, y, z);
            cyl.FaceColor = [0 0.902 0];
            hold on
            
            cyl.ZData(1, :) = cylMargins(i);
            cyl.ZData(2, :) = cylMargins(i+1);
            
            x_distance = diskRadii(i)*cos(theta);
            y_distance = axisVal + diskRadii(i)*sin(theta);
            
            % Setting Z and Y coords so the points of cylinder's edge are equal
            % distance from the axis of rotation.
            
            cyl.XData(1, :) = x_distance;
            cyl.XData(2, :) = x_distance;
            cyl.YData(1, :) = y_distance;
            cyl.YData(2, :) = y_distance;
            
            cir_z_1 = cylMargins(i)+zeros(size(theta));
            cir_z_2 = cylMargins(i+1)+zeros(size(theta));
            cir_x = x_distance;
            cir_y = y_distance;
            
            %Draws both front and back faces of each disc.
            patch(cir_x,cir_y,cir_z_1, [0 0.902 0]);
            patch(cir_x,cir_y,cir_z_2, [0 0.902 0]);
            set(cyl,'edgecolor','none')
        end
        
    % Drawing rectangles to fill faces of discs as they're cut along
    % xy-plane. If axis perpendicular to x-axis, get lengths of
    % rectangle.
    if (fullCircles == 0)
        xverts = [axisVal-diskRadii(1:end); axisVal-diskRadii(1:end);...
            axisVal + diskRadii(1:end); axisVal + diskRadii(1:end)];
        
        yverts = [cylMargins(1:end-1); cylMargins(2:end);...
            cylMargins(2:end); cylMargins(1:end-1)];
        patch(xverts, zeros(size(xverts)), yverts, [0 0.902 0]);
    end
end
end
end

