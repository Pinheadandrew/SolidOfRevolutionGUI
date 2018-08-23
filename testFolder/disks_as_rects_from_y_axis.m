lowerbound = 5;
upperbound = 30;
axis = 0;
subdivisions = 67;


step = (upperbound - lowerbound)/subdivisions;
yPoints = lowerbound + (step/2):step:upperbound - (step/2);
ything = lowerbound:step:upperbound;
syms x
f(x) = x/3;
g(x) = finverse(f(x)); % Inverse function of one that's plotted, becomes function in terms of y

rectLengths = double(g(yPoints));

origFuncLine = fplot(f, [double(g(lowerbound)) double(g(upperbound))]);
origFuncLine.LineWidth = 1;
hold on

xverts = [zeros(1,length(yPoints)); rectLengths(1:end); rectLengths(1:end);...
                    zeros(1,length(yPoints))];
yverts = [ything(1:end-1); ything(1:end-1);...
                      ything(2:end); ything(2:end)];

patch(xverts, yverts, "b")
patch(-xverts, yverts, "b")
% flipFuncLine = fplot(f(-x), -[double(g(upperbound)) double(g(lowerbound))]);
% hold on

% xL = xlim;
% yL = ylim;
% line([0 0], yL);  %x-axis
% line(xL, [0 0]);  %y-axis
uistack(origFuncLine, 'top');
%uistack(flipFuncLine, 'top');

%% Shells
clf
clear
lowerbound = 0;
upperbound = 5;
axis = 0;
subdivisions = 10;


step = (upperbound - lowerbound)/subdivisions;
yPoints = lowerbound + (step/2):step:upperbound - (step/2);
ything = lowerbound:step:upperbound;
syms x
f(x) = x/3;
g(x) = finverse(f(x)); % Inverse function of one that's plotted, becomes function in terms of y

rectLengths = double(g(yPoints));

origFuncLine = fplot(f, [double(g(lowerbound)) double(g(upperbound))]);
origFuncLine.LineWidth = 1;
hold on

xverts = [zeros(1,length(yPoints)); rectLengths(1:end); rectLengths(1:end);...
                    zeros(1,length(yPoints))];
yverts = [ything(1:end-1); ything(1:end-1);...
                      ything(2:end); ything(2:end)];

patch(xverts, yverts, "b")
patch(-xverts, yverts, "b")
% flipFuncLine = fplot(f(-x), -[double(g(upperbound)) double(g(lowerbound))]);
% hold on

% xL = xlim;
% yL = ylim;
% line([0 0], yL);  %x-axis
% line(xL, [0 0]);  %y-axis
uistack(origFuncLine, 'top');
%uistack(flipFuncLine, 'top');
