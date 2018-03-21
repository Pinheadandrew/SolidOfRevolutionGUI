% Script checking out plotting of function and its reflection across x or y
%-axis.

syms x
f(x) = x;

bounds = [0 2];

rotation = 1;

if(rotation == 0) % Reflect around y-axis
    g(x) = -f(x);
else % Reflect around x-axis
    g(x) = f(-x);
    bounds = [-bounds(2) bounds(2)];
end
    
fplot(f(x), bounds), hold on
fplot(g(x), bounds)