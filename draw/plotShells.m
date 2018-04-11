function drawShells(funcString, lowbound, upbound, subdivs, axisOri, axisVal)
%DRAWSHELLS Summary of this function goes here
%   Detailed explanation goes here
    clf
    syms x
    f(x) = str2sym(funcString);
    theta=0:pi/30:2*pi;

    delta= (upbound - lowbound)/subdivs;
    midpoints = lowbound+(delta/2):delta:upbound-(delta/2);     %<- Used for getting heights of rectangles
    shellWidthMargins = (lowbound:delta:upbound);   
    
    if(lower(axisOri) == "x")
      shellHeights = double(f(midpoints));
    
      for i=1:length(shellHeights)
          [x1, y1, z1] = cylinder(shellWidthMargins(i), length(theta)-1);
          [x2, y2, z2] = cylinder(shellWidthMargins(i+1), length(theta)-1);

          innerFace = surf(x1, y1, z1, "FaceColor", "g", "edgecolor", "none"); hold on
          outerFace = surf(x2, y2, z2, "FaceColor", "g", "edgecolor", "none"); hold on
          cylHeight = shellHeights(i);

          inner_x = shellWidthMargins(i)*cos(theta);
          outer_x = shellWidthMargins(i+1)*cos(theta);
          inner_y = shellWidthMargins(i)*sin(theta);
          outer_y = shellWidthMargins(i+1)*sin(theta);

          innerFace.XData(1, :)= inner_x;
          innerFace.XData(2, :)= inner_x;
          innerFace.YData(1, :)= inner_y;
          innerFace.YData(2, :)= inner_y;
          innerFace.ZData = [zeros(1, length(innerFace.ZData));
              cylHeight*ones(1, length(innerFace.ZData(2, :)))];

          outerFace.XData(1, :)= outer_x;
          outerFace.XData(2, :)= outer_x;
          outerFace.YData(2, :)= outer_y;
          outerFace.YData(2, :)= outer_y;
          outerFace.ZData = [zeros(1, length(outerFace.ZData));
              cylHeight*ones(1, length(outerFace.ZData(2, :)))];

          center = [0, 0];

          bottomRing = patch(center(1)+[outer_x,inner_x], ...
                 center(2)+[outer_y,inner_y], ...
                 zeros(1, 2*length(theta)),'g');
          topRing = patch(center(1)+[outer_x,inner_x], ...
                 center(2)+[outer_y,inner_y], ...
                 cylHeight*ones(1, 2*length(theta)),'g');
      end
    end
    
    %Plot function line too.
    plot3(shellWidthMargins, zeros(1, length(shellWidthMargins)), double(f(shellWidthMargins)))
end

