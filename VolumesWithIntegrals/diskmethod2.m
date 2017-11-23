function approxVol = diskmethod2(funcString, diskcount, lowerbound, upperbound)
%DISKMETHOD This function 
%   Input:
%       1. A single-variable function in string form.
%       2. The number of disks to sum the volumes of.
%       3. The lower bound
%       4. The upper bound
%
%   Output:
%       The volume in double-precison, given the number of disks.

% Establish function, and collect given x-points that are separated by 
% delta-x to evaluate f(x) with them for their outputs. Get cross-section 
% areas of disks using pi * (y-point)^2 for each y-point. Then, multiply 
% it with delta-x, resulting in the volume of each disks, which is stored 
% as an element in a matrix for output.

delta = (upperbound-lowerbound)/diskcount;

xpoints = lowerbound+(delta/2):delta:upperbound-(delta/2);

syms x
f(x) = str2sym(funcString);
ypoints = double(f(xpoints));

diskVolumes = pi*(ypoints.^2)*delta;
approxVol = sum(diskVolumes);

end

