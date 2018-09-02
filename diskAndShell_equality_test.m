diskmethod1("x^2", 4, 9, "x", -2)
shellmethod1("x^2", 2, 3, "x", -2)

%%
diskmethod1("x^2", 4, 9, "x", 1)
shellmethod1("x^2", 2, 3, "x", 1)

%%
diskmethod1("x^2", 0, 1, "x", 1)
shellmethod1("x^2", -1, 0, "x", -1)

%%
diskmethod1("x^2", 25, 100, "x", 1)
shellmethod1("x^2", -10, -5, "x", -1)

%%
diskmethod1("x^2", 4, 9, "x", -2)
shellmethod1("x^2", -3, -2, "x", 2)

%%
diskmethod1("x^2", 0, 9, "x", 4)
shellmethod1("x^2", -3, 0, "x", -4)

%%
diskmethod1("x^2", 4, 9, "x", 1)
shellmethod1("x^2", -3, -2, "x", -1)

%%
diskmethod1("2^x", 2^(-3), 2^(-2), "x", 1)
shellmethod1("2^x", -3, -2, "x", 1)

%%
diskmethod1("2^x", 2^(0), 2^(1), "x", 2)
shellmethod1("2^x", 0, 1, "x", 2)

%%
diskmethod1("x", -1, 0, "y", 1)
shellmethod1("x", -1, 0, "y", 1)

%%
diskmethod1("x", 2, 3, "y", 1)
shellmethod1("x", 2, 3, "y", 1)

%%
diskmethod1("x", 0, 1, "y", 2)
shellmethod1("x", 0, 1, "y", 2)

%%
diskmethod1("x", 1, 2, "y", -1)
shellmethod1("x", 1, 2, "y", -1)

%%
diskmethod1("x", 1, 2, "y", 3)
shellmethod1("x", 1, 2, "y", 3)

%%
diskmethod1("x^2", 2, 3, "y", 1)
shellmethod1("x^2", 4, 9, "y", 1)

%%
diskmethod1("x", -3, -2, "y", -1)
shellmethod1("x", -3, -2, "y", -1)

%%
diskmethod1("x", -3, -2, "y", 0)
shellmethod1("x", -3, -2, "y", 0)

%%
diskmethod1("x", -1, 0, "y", 1)
shellmethod1("x", -1, 0, "y", 1)

%%
diskmethod1("x", -2, -1, "y", -3)
shellmethod1("x", -2, -1, "y", -3) 

%%
diskmethod1("x", 1, 2, "y", -1)
shellmethod1("x", 1, 2, "y", -1)

%%
diskmethod1("x", -2, -1, "y", -1)
shellmethod1("x", -2, -1, "y", -1)

%% Vertical axis and f(x) = x
diskmethod1("x", 0, 1, "x", 0)
shellmethod1("x", 0, 1, "x", 0)

%% 
diskmethod1("x", -1, 0, "x", 0)
shellmethod1("x", -1, 0, "x", 0)

%% 
diskmethod1("x", -3, -2, "x", -1)
shellmethod1("x", -3, -2, "x", -1)
diskmethod1("x", 2, 3, "x", 1)
shellmethod1("x", 2, 3, "x", 1)

%% 
diskmethod1("x", -3, -2, "x", -2)
shellmethod1("x", -3, -2, "x", -2)
diskmethod1("x", 2, 3, "x", 2)
shellmethod1("x", 2, 3, "x", 2)

%% 
diskmethod1("x", -3, -2, "x", -2)
shellmethod1("x", -3, -2, "x", -2)
diskmethod1("x", 2, 3, "x", 2)
shellmethod1("x", 2, 3, "x", 2)

%% 
diskmethod1("x", -3, -2, "x", -3)
shellmethod1("x", -3, -2, "x", -3)
diskmethod1("x", 2, 3, "x", 3)
shellmethod1("x", 2, 3, "x", 3)

%% TESTING x^2
diskmethod1("x^2", 0, 1, "y", 0)
shellmethod1("x^2", 0, 1, "y", 0)

%%
diskmethod1("x^2", 0, 1, "y", 1)
shellmethod1("x^2", 0, 1, "y", 1)

%%
diskmethod1("x^2", 2, 3, "y", 0) % 
shellmethod1("x^2", 4, 9, "y", 0)

%%
diskmethod1("x^2", 2, 3, "y", 9) % 225.5664
shellmethod1("x^2", 4, 9, "y", 9)

diskmethod1("x^2", 2, 3, "y", 4) % 23.6667
shellmethod1("x^2", 4, 9, "y", 4)

%%
diskmethod1("x^2", 2, 3, "y", 1) % 95.9233
shellmethod1("x^2", 4, 9, "y", 1)

%%
diskmethod1("x^2", 2, 3, "y", -1) % 172.3684
shellmethod1("x^2", 4, 9, "y", -1)

%% TESTING 2^x
diskmethod1("2^x", -3, 0, "y", 10) % Right
shellmethod1("2^x", 2^(-3), 2^(0), "y", 10)

%%
diskmethod1("2^x", -3, 0, "y", 0) % Should be 2.2308
shellmethod1("2^x", 2^(-3), 2^(0), "y", 0) 

%%
diskmethod1("2^x", -3, -1, "y", -1) % Should be 3.9304, equal
shellmethod1("2^x", 2^(-3), 2^(-1), "y", -1) % 

%%
diskmethod1("2^x", -2, 2, "y", 5) % Right, and equal
shellmethod1("2^x", 2^(-2), 4, "y", 5)

%%
diskmethod1("2^x", -2, 2, "y", 0)
shellmethod1("2^x", 2^(-2), 4, "y", 0)

%%
diskmethod1("2^x", -2, 2, "y", -1)
shellmethod1("2^x", 2^(-2), 4, "y", -1)

%%
diskmethod1("2^x", -10, -5, "y", 0)
shellmethod1("2^x", 2^(-10), 2^(-5), "y", 0)

%%
diskmethod1("2^x", -10, -5, "y", 1)
shellmethod1("2^x", 2^(-10), 2^(-5), "y", 1)

%%
diskmethod1("x", -1, 0, "y", -2)
shellmethod1("x", -1, 0, "y", -2)

%%
diskmethod1("2^x", -1, 1, "y", 0) %Right
diskmethod1("2^x", 1, 2, "y", 0) %Right
diskmethod1("2^x", 1, 2, "y", -1) %Right
diskmethod1("2^x", 1, 2, "y", 4) %Right

%% Vertical axis and 2^x
shellmethod1("2^x", 0, 1, "x", 0)
diskmethod1("2^x", 1, 2, "x", 0)

%% 
shellmethod1("2^x", 1, 2, "x", 0)
diskmethod1("2^x", 2, 4, "x", 0)

%% 
shellmethod1("2^x", -5, -3, "x", -5)
diskmethod1("2^x", 2^(-5), 0.1250, "x", -5)  % 1.0402

%% 
shellmethod1("2^x", -2, 2, "x", 3)
diskmethod1("2^x", 2^(-2), 4, "x", 3)  % 73.9697

%% 
shellmethod1("2^x", -3, 1, "x", -5)
diskmethod1("2^x", 2^(-3), 2^(1), "x", -5)  % 81.9899
