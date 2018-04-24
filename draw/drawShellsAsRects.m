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
    shellHeights = double(f(xpoints));

    orig_xverts = [orig_shellBasePoints(1:end-1); orig_shellBasePoints(1:end-1);... 
        orig_shellBasePoints(2:end); orig_shellBasePoints(2:end)];
    
    yverts = [zeros(1,length(xpoints)); shellHeights(1:end);...
                shellHeights(1:end); zeros(1,length(xpoints))];
              
    mirror_xverts = [mirror_shellBasePoints(1:end-1); mirror_shellBasePoints(1:end-1);... 
        mirror_shellBasePoints(2:end); mirror_shellBasePoints(2:end)];
                
    origRectSet = patch(orig_xverts, yverts, "b");
    mirrorRectSet = patch(mirror_xverts, yverts, "b");
else
    g(x) = finverse(f(x));
    shellLengths = double(g(xpoints));
    
    % In this case, x-verts are the same when flipped across the axis, but
    % y-vertices are different. Also, evaluate w/ inverse of original function.
    xverts = [zeros(1, length(shellLengths)); shellLengths(1:end);...
                shellLengths(1:end); zeros(1, length(shellLengths))];
            
    yverts = [orig_shellBasePoints(1:end-1); orig_shellBasePoints(1:end-1);...
                          orig_shellBasePoints(2:end); orig_shellBasePoints(2:end)];
                      
    mirror_yverts = [mirror_shellBasePoints(1:end-1); mirror_shellBasePoints(1:end-1);... 
        mirror_shellBasePoints(2:end); mirror_shellBasePoints(2:end)];
    
    origRectSet = patch(xverts, yverts, "b");
    mirrorRectSet = patch(xverts, mirror_yverts, "b");
end
end

