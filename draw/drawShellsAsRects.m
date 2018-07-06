 function [origRectSet, mirrorRectSet] = drawShellsAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal, radiusMethod)
% Test file that draws rectangles representing shells viewed from the side, 
% their heights are evaluations at the point of the point's function. Flexible for any arbitrary 
% value as x-axis to rotate area around.

syms x
f(x) = str2sym(funcString);

delta= (upbound - lowbound)/subdivs;
orig_shellBasePoints = (lowbound:delta:upbound);            %<- Base points for rectangles along static-changing axis.

%X-points separated by disk width, which determine radii of shells.
if (radiusMethod == "m")
    xpoints = lowbound+(delta/2):delta:upbound-(delta/2);
elseif (radiusMethod == "l")
    xpoints = lowbound:delta:upbound-delta;
elseif (radiusMethod == "r")
    xpoints = lowbound+delta:delta:upbound;
end

% Set the base points of the rectangles in the original area and the area reflected across the axis. 
if(axisVal <= lowbound)
  axis_bound_distance = abs(orig_shellBasePoints - axisVal);
  mirror_shellBasePoints = axisVal - axis_bound_distance;
elseif(axisVal >= upbound)
  axis_bound_distance = abs(axisVal - orig_shellBasePoints);
  % Below are x-vertices of rectangles flipped across the axis from the original bounds.
  mirror_shellBasePoints = axisVal + axis_bound_distance;
else
   return
end

if(axisOri =="x")  
    % In this case, y-verts are the same when flipped across the axis, but
    % x-vertices are different.
    
    if (f(upbound) > f(lowbound))
        volumeBaseLine = double(f(upbound));                    % "Top"/"Bottom" of solid
        shellHeights = volumeBaseLine - double(f(xpoints));     % Diff b/w function point and "top"
        shellBottomPoints = volumeBaseLine - shellHeights;      % 
    else
        volumeBaseLine = double(f(lowbound));
        shellHeights = volumeBaseLine - double(f(xpoints));
        shellBottomPoints = volumeBaseLine - shellHeights;
    end

    orig_xverts = [orig_shellBasePoints(1:end-1); orig_shellBasePoints(1:end-1);... 
        orig_shellBasePoints(2:end); orig_shellBasePoints(2:end)];
    
    yverts = [shellBottomPoints; volumeBaseLine*ones(1, length(shellHeights));...
                volumeBaseLine*ones(1, length(shellHeights)); shellBottomPoints];
              
    mirror_xverts = [mirror_shellBasePoints(1:end-1); mirror_shellBasePoints(1:end-1);... 
        mirror_shellBasePoints(2:end); mirror_shellBasePoints(2:end)];
                
    origRectSet = patch(orig_xverts, yverts, "b"); hold on
    mirrorRectSet = patch(mirror_xverts, yverts, "b"); hold on
    
    axis_bound_distance(1)
    % If difference b/w axis value and lower/upper bound, draw cross-section 
    % rectangle for inner cylinder rotated around vertical line.
    if (axis_bound_distance(1) ~= 0)
        % Radius of the filler cylinder determined.
        if(axisVal < lowbound)
            centerCylRadius = axis_bound_distance(1);
            innerCylHeight = shellHeights(1);
        elseif(axisVal > upbound)
            centerCylRadius = axis_bound_distance(end);
            innerCylHeight = shellHeights(end);
        end
        
        % Draw cross-section rectangle for center cylinder.
        centerCylRect_xverts = [axisVal - centerCylRadius; axisVal + centerCylRadius;...
            axisVal + centerCylRadius; axisVal - centerCylRadius];
        
        centerCylFill_yverts = [(volumeBaseLine-innerCylHeight); (volumeBaseLine-innerCylHeight); ...
            volumeBaseLine; volumeBaseLine];
        
        patch(centerCylRect_xverts, centerCylFill_yverts, "b"); hold on
    end
else
    % Rotating around horizontal line.  Shell lengths based on difference b/w 
    % "bottom"/"top" of volume and the point along the function's inverse.
    
    g(x) = finverse(f(x));
    
    % Determine whether the volume needs a "top" of a "bottom", then 
    if (f(upbound) > f(lowbound))
        volumeBaseLine = double(g(upbound));
        shellLengths = volumeBaseLine - double(g(xpoints));
        shellEndpoints = volumeBaseLine - shellLengths;
    else
        volumeBaseLine = double(g(lowbound));
        shellLengths = volumeBaseLine - double(g(xpoints));
        shellEndpoints = volumeBaseLine - shellLengths;
    end
    
    % In this case, x-verts are the same when flipped across the axis, but
    % y-vertices are different. Also, evaluate w/ inverse of original function.
    xverts = [shellEndpoints; volumeBaseLine*ones(1, length(shellLengths));...
                volumeBaseLine*ones(1, length(shellLengths)); shellEndpoints];
            
    yverts = [orig_shellBasePoints(1:end-1); orig_shellBasePoints(1:end-1);...
                          orig_shellBasePoints(2:end); orig_shellBasePoints(2:end)];
                      
    mirror_yverts = [mirror_shellBasePoints(1:end-1); mirror_shellBasePoints(1:end-1);... 
        mirror_shellBasePoints(2:end); mirror_shellBasePoints(2:end)];
    
    origRectSet = patch(xverts, yverts, "b"); hold on
    mirrorRectSet = patch(xverts, mirror_yverts, "b"); hold on
    
    axis_bound_distance(1)
    % If difference b/w axis value and lower/upper bound, draw cross-section 
    % rectangle for inner cylinder rotated around horizontal line.
    if (axis_bound_distance(1) ~= 0)
        if(axisVal < lowbound)
            centerCylRadius = axis_bound_distance(1);
            cylHeight = shellLengths(1);
        elseif(axisVal > upbound)
            centerCylRadius = axis_bound_distance(end);
            cylHeight = shellLengths(end);
        end
        
        centerCylRect_xverts = [(volumeBaseLine-cylHeight); volumeBaseLine;...
            volumeBaseLine; (volumeBaseLine-cylHeight)];
        
        centerCylFill_yverts = [axisVal - centerCylRadius; axisVal - centerCylRadius;...
            axisVal + centerCylRadius; axisVal + centerCylRadius;];
        
        patch(centerCylRect_xverts, centerCylFill_yverts, "b"); hold on
    end
end
end

