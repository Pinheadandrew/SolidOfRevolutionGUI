xverts = [0 0 -1 -1];
yvverts = [0 1 1 0];
syms x
fplot(x, [-2, 2])
patch(xverts, yvverts, "b")
yvverts = [0 -1 -1 0];
patch(xverts, yvverts, "b")
xverts3 = [0 -2 -2 0];
yverts3 = [-1 -1 -2 -2];
patch(xverts3, yverts3, "r")