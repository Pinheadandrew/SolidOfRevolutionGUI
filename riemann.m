function areaUnderCurve = riemann(Y,rectcount, lowbound, upbound, xlocation)
%RIEMANN Summary of this function goes here
%   Detailed explanation goes here
syms x
f(x) = str2sym(Y);

% This is delta, referring to delta term in Riemman's sum definition. Delta
% multiplied by each left Riemann's point, each x-point separated by
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

