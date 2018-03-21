function areaUnderCurve = riemann(Y,rectcount, lowbound, upbound, xlocation)
%RIEMANN Returns the Riemann's integral of a function between two bounds on the 
% x-axis, approximating it depending on the rectangles entered and the
% method (left-point, right-point, midpoint).
syms x
f(x) = str2sym(Y);

% This is delta, referring to delta term in Riemman's sum definition. Delta
% multiplied by each Riemann's point, each x-point separated by
% delta-length.
delta = (upbound-lowbound)/rectcount;

if (xlocation == "l")
    
    riemannsPoints = lowbound:delta:upbound-delta;
    
    elseif (xlocation == "m")
 
        riemannsPoints = lowbound+(delta/2):delta:upbound-(delta/2);
    
    elseif (xlocation == "r")
        riemannsPoints = lowbound+delta:delta:upbound;
end

rectHeights = f(riemannsPoints);

rectAreas = rectHeights*delta;
areaUnderCurve = double(sum(rectAreas));
end

