function plotDiscs(funcString, lowbound, upbound, cylsCount, axisOri, axisVal, fullCircles, radiusMethod)
% Drawing of solids of revolution using disc method, with area under function
% argument funcString rotated perpendicularly around axis. Input are bounds of solid,
% number of discs to approximate the volume, axis orientation and axis value.

f = string2func(funcString, 0);

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
    specialCaseFor_quad = 0;
    
    %Special case when x^2 is function and bounds are non-positive.
    if (lowbound <= 0 && upbound <= 0 && funcString == "x^2")
        specialCaseFor_quad = 1;
    end
    
    % If axis of rotation not equal to function's height at lower or
    % upperbound, use the washer method to rotate area under curve
    % around axis.
    if (axisVal >= f(lowbound) || axisVal <= f(upbound))
        % Area is within negative bounds of x-axis, and is function f(x) =
        % x
        if (lowbound <= 0 && upbound <= 0 && funcString == "x")
            % Axis of rotation BELOW area above curve in negative space, set outer radius to
            % aV and inner to |f(x) - aV|
            if(double(f(lowbound)) >= axisVal)
                innerRadius = abs(f(xpoints) - axisVal);
                outerRadius = abs(axisVal*ones(1,length(xpoints)));
                
                % Axis of rotation ABOVE area under curve in negative space, outer radius is
                % |aV - f(x)| within bounds and inner radius is
                % (function maxima within bounds) - aV.
            elseif (f(upbound) <= axisVal)
                % Add difference b/w axis value and f(lowbound) to inner radius
                if (axisVal <= 0)
                    innerRadius = zeros(1, length(xpoints));
                else
                    innerRadius = axisVal*ones(1,length(xpoints));
                end
                
                outerRadius = abs(axisVal - f(xpoints));
            end
            % Otherwise, if area under/above curve not f(x)=x bounded by negative
            % numbers along x-axis.
        else
            %Special case when x^2 is function and bounds are
            %non-positive.
            if (specialCaseFor_quad == 1)
                
                % Axis "above" the area of x^2 bound by negative x-bounds.
                if(double(f(lowbound)) <= axisVal)
                    outerRadius = abs(axisVal*ones(1,length(xpoints)));
                    innerRadius = abs(double(axisVal - f(xpoints)));
                       
                % Axis "under" the area of x^2 bound by negative x-bounds.
                elseif(double(f(upbound)) >= axisVal)
                    % Axis "between" f(lowbound) and y=0.
                    if (axisVal >= 0)
                        innerRadius = zeros(1,length(xpoints));
                    % Axis "under" f(lowbound) and y=0.
                    elseif (axisVal < 0)
                        innerRadius = zeros(1,length(xpoints)) - axisVal;
                    end
                    outerRadius = abs(double(axisVal - f(xpoints)));
                end
            else
                % Axis of rotation BELOW area under curve, set outer radius to
                % function line.
                if(double(f(lowbound)) >= axisVal)
                    % Add difference b/w axis value and f(lowbound) to inner radius
                    if (axisVal >= 0)
                        innerRadius = zeros(1,length(xpoints));
                    else
                        innerRadius = zeros(1,length(xpoints)) - axisVal;
                    end
                    outerRadius = abs(double(axisVal - f(xpoints)));
                    
                    % Axis of rotation ABOVE area under curve, outer radius is axis
                    % value minus minima of function within bounds.
                elseif (double(f(upbound)) <= axisVal)
                    innerRadius = abs(axisVal - f(xpoints));
                    outerRadius = abs(axisVal - f(lowbound))*ones(1,length(xpoints));
                    outerRadius = outerRadius + f(lowbound); % <- Includes area "under" f(lowerbound) in discs' radii.
                end
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
            
            innerCyl = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            outerCy = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
            
            rotate(innerCyl, [0 1 0], 90);
            rotate(outerCy, [0 1 0], 90);
            
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
            
            innerCyl.YData(1, :)= inner_y;
            innerCyl.YData(2, :)= inner_y;
            innerCyl.ZData(1, :)= inner_z;
            innerCyl.ZData(2, :)= inner_z;
            innerCyl.XData(1, :) = cylMargins(i);
            innerCyl.XData(2, :) = cylMargins(i+1);
            
            outerCy.YData(1, :)= outer_y;
            outerCy.YData(2, :)= outer_y;
            outerCy.ZData(1, :)= outer_z;
            outerCy.ZData(2, :)= outer_z;
            outerCy.XData(1, :) = cylMargins(i);
            outerCy.XData(2, :) = cylMargins(i+1);
            
            % Patching faces on the left and the right faces of the
            % horizontally-facing cylinders, for non-zero disc areas.
            if (outerRadius(i) ~= innerRadius(i))
                topFace = patch(cylMargins(i)*ones(1, 2*length(theta)), ...
                    [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
                topFace.EdgeColor = 'none';
                bottomFace = patch(cylMargins(i+1)*ones(1, 2*length(theta)), ...
                    [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
                bottomFace.EdgeColor = 'none';
            end
            
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
end
end

