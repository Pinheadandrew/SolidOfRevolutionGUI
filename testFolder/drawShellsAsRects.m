
function drawShellsAsRects(funcString, lowbound, upbound, subdivs, axisOri, axisVal)
% Test file that draws rectangles representing shells viewed from the side, 
% their heights are evaluations at the point of the point's function. Flexible for any arbitrary 
% value as x-axis to rotate area around. 
syms x
f(x) = str2sym(funcString);

delta= (upbound - lowbound)/subdivs;
midpoints = lowbound+(delta/2):delta:upbound-(delta/2);
orig_shellBasePoints = (lowbound:delta:upbound);

if(axisVal <= lowbound)
  axis_bound_distance = abs(lowbound - axisVal);
  mirror_shellBasePoints = axisVal - axis_bound_distance - orig_shellBasePoints;
  
elseif(axisVal >= upbound)
  axis_bound_distance = abs(axisVal - upbound);
  reverseBasePoints = orig_shellBasePoints(end):-delta:orig_shellBasePoints(1);
  mirror_shellBasePoints = reverseBasePoints + axisVal + axis_bound_distance;
else
   return
end

%FOR TESTING FUNCTION BY ITSELF:
if(axisOri =="x")
    shellHeights = abs(double(f(midpoints)));

    orig_xverts = [orig_shellBasePoints(1:end-1); orig_shellBasePoints(1:end-1);... 
        orig_shellBasePoints(2:end); orig_shellBasePoints(2:end)];
    yverts = [zeros(1,length(midpoints)); shellHeights(1:end);...
                shellHeights(1:end); zeros(1,length(midpoints))];
              
    mirror_xverts = [mirror_shellBasePoints(1:end-1); mirror_shellBasePoints(1:end-1);... 
        mirror_shellBasePoints(2:end); mirror_shellBasePoints(2:end)];
                
    patch(orig_xverts, yverts, "b");
    patch(mirror_xverts, yverts, "r");
else
   % Incomplete, in progress
    g(x) = finverse(f(x));
    diskRadii = abs(double(g(midpoints)-axisVal));
    xverts = [axisVal-diskRadii; axisVal-diskRadii;...
                axisVal + diskRadii; axisVal + diskRadii];
    yverts = [rectAxisPoints(1:end-1); rectAxisPoints(2:end);...
                          rectAxisPoints(2:end); rectAxisPoints(1:end-1)];
end
end

