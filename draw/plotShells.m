function plotShells(funcString, lowbound, upbound, subdivs, axisOri, axisVal, fullCircles, radiusMethod)
% Function that plots solid of revolution as hollow 3D cylinders rotated
% parallel to the axis specified. Choice of whether to show the whole solid
% or cut half of it across the x-z plane.
f = string2func(funcString, 0);

delta= (upbound - lowbound)/subdivs;
shellWidthMargins = (lowbound:delta:upbound);

%X-points separated by disk width, which determine radii of shells.
if (radiusMethod == "m")
    xpoints = lowbound+(delta/2):delta:upbound-(delta/2);
elseif (radiusMethod == "l")
    xpoints = lowbound:delta:upbound-delta;
elseif (radiusMethod == "r")
    xpoints = lowbound+delta:delta:upbound;
end

if (fullCircles == 1)
    theta=0:pi/30:2*pi;
else
    % For patching rectangles for the shells' insides as cut by the
    % xy-plane, determine points for both the original area and the
    % mirrored area.
    if (axisOri == "y")
        theta=-pi/2:pi/60:pi/2;
    else
        theta=0:pi/60:pi;
    end
end

% Get the points perpendicular to the axis that. Two sets of points,
% one on each side of the axis.
if(axisVal <= lowbound)
    axis_bound_distance = abs(shellWidthMargins - axisVal);
    mirror_shellWidthMargins = axisVal - axis_bound_distance;
elseif(axisVal >= upbound)
    axis_bound_distance = abs(axisVal - shellWidthMargins);
    mirror_shellWidthMargins = axisVal + axis_bound_distance;
else
    return
end

% First condition for axes parallel to the y-axis that the broken-up
% subintervals of the area under/above the function are rotated around,
% parallel to the axis of rotation.
if(lower(axisOri) == "x")
    shellHeights = double(f(xpoints));
    
      for i=1:length(shellHeights)
        [x1, y1, z1] = cylinder(shellWidthMargins(i), length(theta)-1);
        [x2, y2, z2] = cylinder(shellWidthMargins(i+1), length(theta)-1);
        
        innerFace = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
        outerFace = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
        cylHeight = shellHeights(i);
        
        % Coordinate for axis-line. Used to determine radius and
        % displacement of cylinders in 3D coordinate system.
        shellInnerRadius = abs(shellWidthMargins(i)-axisVal);
        shellOuterRadius = abs(shellWidthMargins(i+1)-axisVal);
        inner_x = axisVal + shellInnerRadius*cos(theta);
        outer_x = axisVal + shellOuterRadius*cos(theta);
        inner_y = shellInnerRadius*sin(theta);
        outer_y = shellOuterRadius*sin(theta);
        
        innerFace.XData(1, :)= inner_x;
        innerFace.XData(2, :)= inner_x;
        innerFace.YData(1, :)= inner_y;
        innerFace.YData(2, :)= inner_y;
        innerFace.ZData = [zeros(1, length(innerFace.ZData));
          cylHeight*ones(1, length(innerFace.ZData(2, :)))];
        
        outerFace.XData(1, :)= outer_x;
        outerFace.XData(2, :)= outer_x;
        outerFace.YData(1, :)= outer_y;
        outerFace.YData(2, :)= outer_y;
        outerFace.ZData = [zeros(1, length(outerFace.ZData));
          cylHeight*ones(1, length(outerFace.ZData(2, :)))];
        
        %Drawing rings to fill top and bottom of shells.
        bottomRing = patch([outer_x,inner_x], ...
          [outer_y,inner_y], zeros(1, 2*length(theta)),[0 0.902 0]);
        bottomRing.EdgeColor = 'none';
        topRing = patch([outer_x,inner_x], ...
        [outer_y,inner_y], cylHeight*ones(1, 2*length(theta)),[0 0.902 0]);
        topRing.EdgeColor = 'none';
        
        plot3(inner_x, inner_y, cylHeight*ones(1, length(theta)), "black"), hold on
        plot3(outer_x, outer_y, cylHeight*ones(1, length(theta)), "black"), hold on
        plot3(inner_x, inner_y, zeros(1, length(theta)), "black"), hold on
        plot3(outer_x, outer_y, zeros(1, length(theta)), "black"), hold on
      end
    
    %Drawing rectangles to fill faces of shells' as they're cut on
      %xy-plane.
      if (fullCircles == 0)
        orig_xverts = [shellWidthMargins(1:end-1); shellWidthMargins(1:end-1);...
          shellWidthMargins(2:end); shellWidthMargins(2:end)];
        
        yverts = [zeros(1,length(xpoints)); shellHeights(1:end);...
          shellHeights(1:end); zeros(1,length(xpoints))];
        
        mirror_xverts = [mirror_shellWidthMargins(1:end-1); mirror_shellWidthMargins(1:end-1);...
          mirror_shellWidthMargins(2:end); mirror_shellWidthMargins(2:end)];
        %Patching the rectangles to "fill" the inside of the shells.
        patch(orig_xverts, zeros(size(orig_xverts)), yverts, [0 0.902 0]);
        patch(mirror_xverts, zeros(size(orig_xverts)), yverts, [0 0.902 0]);
      end
% When axis is horizontal line, draw shells parallel to this line, bounds along y-axis.
elseif (lower(axisOri) == "y")
    g(x) = finverse(f);
    
    % The bounds produce an output through the inverse function that are
    % negative.
    if (g(lowbound) <= 0 && g(upbound) <= 0)
        % Function is "x", special case for area to be rotated.
        if (funcString == "x")
            volumeBaseLine = double(g(lowbound));
            shellLengths = volumeBaseLine - double(g(xpoints));
            shellEndpoints = volumeBaseLine - shellLengths;
        else
            volumeBaseLine = double(g(upbound));
            shellLengths = double(volumeBaseLine - g(xpoints));
            shellEndpoints = volumeBaseLine - shellLengths;
        end
    % Otherwise, bound one end of each shell's length by constant,
    % g(upbound)
    else
        % If lower bound's value of f(y) higher than axis value, make solid's
        % "base" at g(upper bound), which is higher bound along x-axis.

%         belowCurve = double(lowbound) >= axisVal
%         aboveCurve = double(upbound) <= axisVal

        if (double(lowbound) >= axisVal)
            volumeBaseLine = double(g(upbound));
            shellLengths = volumeBaseLine - double(g(xpoints));
            shellEndpoints = volumeBaseLine - shellLengths;
        % Else, make "base" at at g(upper bound), which is upper bound along x-axis.
%         elseif (double(g(upbound)) <= axisVal)
        elseif (double(upbound) <= axisVal)
            volumeBaseLine = double(g(upbound));
            shellLengths = volumeBaseLine - double(g(xpoints));
            shellEndpoints = volumeBaseLine - shellLengths;
        end
    end
    
    for i=1:length(shellLengths)
        [x1, y1, z1] = cylinder(shellWidthMargins(i), length(theta)-1);
        [x2, y2, z2] = cylinder(shellWidthMargins(i+1), length(theta)-1);
        
        innerFace = surf(x1, y1, z1, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
        rotate(innerFace, [0 1 0], 90);
        outerFace = surf(x2, y2, z2, "FaceColor", [0 0.902 0], "EdgeColor", "none"); hold on
        rotate(outerFace, [0 1 0], 90);
        cylLength = shellLengths(i); % <- Current cylinder's height/length.
        
        % Coordinate for axis-line. Used to determine radius and
        % displacement of inner and outer cylinder that comprise shell.
        shellInnerRadius = abs(shellWidthMargins(i)-axisVal);
        shellOuterRadius = abs(shellWidthMargins(i+1)-axisVal);
        
        % When rotated to axis parallel to x-axis, vertices of cylinder edges
        % change by y and z-points. X points static among the two faces
        % of shell. Get the Y and Z coordinates comprising both inner and
        % outer cylinder.
        inner_y = shellInnerRadius*cos(theta);
        outer_y = shellOuterRadius*cos(theta);
        inner_z = axisVal + shellInnerRadius*sin(theta);
        outer_z = axisVal + shellOuterRadius*sin(theta);
        
        inner_y = double(inner_y);
        outer_y = double(outer_y);
        inner_z = double(inner_z);
        outer_z = double(outer_z);
        
        innerFace.YData(1, :)= inner_y;
        innerFace.YData(2, :)= inner_y;
        innerFace.ZData(1, :)= inner_z;
        innerFace.ZData(2, :)= inner_z;
        innerFace.XData = [volumeBaseLine*ones(1, length(innerFace.ZData)); % This 2-row matrix
            (volumeBaseLine-cylLength)*ones(1, length(innerFace.ZData(2, :)))];
        
        % Setting vertices of outside edge of the cylinder.
        outerFace.YData(1, :)= outer_y;
        outerFace.YData(2, :)= outer_y;
        outerFace.ZData(1, :)= outer_z;
        outerFace.ZData(2, :)= outer_z;
        outerFace.XData = [volumeBaseLine*ones(1, length(outerFace.ZData));
            (volumeBaseLine-cylLength)*ones(1, length(outerFace.ZData(2, :)))];
        
        % Patching rings on the left and the right faces of the shells.
        leftRing = patch(double(volumeBaseLine-cylLength)*ones(1, 2*length(theta)), ...
            [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
        leftRing.EdgeColor = 'none';
        rightRing = patch(volumeBaseLine*ones(1, 2*length(theta)), ...
            [outer_y,inner_y], [outer_z,inner_z], [0 0.902 0]);
        rightRing.EdgeColor = 'none';
        
        % Drawing circles for edges of left and right ring
        plot3(volumeBaseLine*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
        plot3((volumeBaseLine-cylLength)*ones(1, length(theta)), inner_y, inner_z, "black"), hold on
        plot3(volumeBaseLine*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
        plot3((volumeBaseLine-cylLength)*ones(1, length(theta)), outer_y, outer_z, "black"), hold on
    end
    
    %Patching the rectangles to "fill" the inside of the shells, after
    %looping of drawn shells.
    if(fullCircles == 0)
        xverts = [shellEndpoints; volumeBaseLine*ones(1, length(shellEndpoints));...
            volumeBaseLine*ones(1, length(shellEndpoints)); shellEndpoints];
        
        yverts = [shellWidthMargins(1:end-1); shellWidthMargins(1:end-1);...
            shellWidthMargins(2:end); shellWidthMargins(2:end)];
        
        mirror_yverts = [mirror_shellWidthMargins(1:end-1); mirror_shellWidthMargins(1:end-1);...
            mirror_shellWidthMargins(2:end); mirror_shellWidthMargins(2:end)];
        
        patch(xverts, zeros(size(xverts)), yverts, [0 0.902 0]); hold on
        patch(xverts, zeros(size(xverts)), mirror_yverts, [0 0.902 0]); hold on
    end
end
end
