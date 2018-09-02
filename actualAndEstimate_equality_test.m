diskmethod1("x^2", 4, 9, "x", -2)
diskmethod2("x^2", 50, 4, 9, "x", -2, "m")
shellmethod1("x^2", 2, 3, "x", -2)
shellmethod2("x^2", 50, 2, 3, "x", -2, "m")
%%
diskmethod1("x^2", 4, 9, "x", 1)
diskmethod2("x^2", 50, 4, 9, "x", 1, "m")
shellmethod1("x^2", 2, 3, "x", 1)
shellmethod2("x^2", 50, 2, 3, "x", 1, "m")

%%
diskmethod1("x^2", 0, 1, "x", 1)
shellmethod1("x^2", -1, 0, "x", -1)
diskmethod2("x^2", 50, 0, 1, "x", 1, "m")
shellmethod2("x^2", 50, 0, 0, "x", -1, "m")

%%
diskmethod1("x^2", 25, 100, "x", 1)
shellmethod1("x^2", -10, -5, "x", -1)

%%
diskmethod1("x^2", 4, 9, "x", -2)
shellmethod1("x^2", -3, -2, "x", 2)
diskmethod2("x^2", 50, 4, 9, "x", -2, "m")

%%
diskmethod1("x^2", 0, 9, "x", 4)
shellmethod1("x^2", -3, 0, "x", -4)
diskmethod2("x^2", 50, 0, 9, "x", 4, "m")
%%
diskmethod1("x^2", 4, 9, "x", 1)
shellmethod1("x^2", -3, -2, "x", -1)
diskmethod2("x^2", 50, 4, 9, "x", 1, "m")
%%
diskmethod1("2^x", 2^(-3), 2^(-2), "x", 1)
diskmethod2("2^x", 50, 2^(-3), 2^(-2), "x", 1, "m")
shellmethod1("2^x", -3, -2, "x", 1)
shellmethod2("2^x", 50, -3, -2, "x", 1, "m")

%%
diskmethod1("2^x", 2^(0), 2^(1), "x", 2)
diskmethod2("2^x", 50, 2^(0), 2^(1), "x", 2, "m")
shellmethod1("2^x", 0, 1, "x", 2)
shellmethod2("2^x", 50, 0, 1, "x", 2, "m")
%%
diskmethod1("x", -1, 0, "y", 1)
diskmethod2("x", 50, -1, 0, "y", 1, "m")
shellmethod1("x", -1, 0, "y", 1)
shellmethod2("x", 50, -1, 0, "y", 1, "m")

%%
diskmethod1("x", 2, 3, "y", 1)
diskmethod2("x", 50, 2, 3, "y", 1, "m")
shellmethod1("x", 2, 3, "y", 1)
shellmethod2("x", 50, 2, 3, "y", 1, "m")

%%
diskmethod1("x", 0, 1, "y", 2)
diskmethod2("x", 50, 0, 1, "y", 2, "m")
shellmethod1("x", 0, 1, "y", 2)
shellmethod2("x", 50, 0, 1, "y", 2, "m") 

%%
diskmethod1("x", 1, 2, "y", -1)
diskmethod2("x", 50, 1, 2, "y", -1, "m")
shellmethod1("x", 1, 2, "y", -1)
shellmethod2("x", 50, 1, 2, "y", -1, "m") 

%%
shellmethod1("x", 2, 3, "y", 1)
shellmethod2("x", 50, 2, 3, "y", 1, "m") 
%%
diskmethod1("x", 1, 2, "y", 3)
shellmethod1("x", 1, 2, "y", 3)
diskmethod2("x", 50, 1, 2, "y", 3, "m")
shellmethod2("x", 50, 1, 2, "y", 3, "m") % Not right

%%
diskmethod1("x", -3, -2, "y", -1)
shellmethod1("x", -3, -2, "y", -1)
diskmethod2("x", 50, -3, -2, "y", -1, "m")
shellmethod2("x", 50, -3, -2, "y", -1, "m")

%%
diskmethod1("x", -5, -2, "y", 0)
shellmethod1("x", -5, -2, "y", 0)
diskmethod2("x", 50, -5, -2, "y", 0, "m")
shellmethod2("x", 50, -5, -2, "y", 0, "m") 
%%
diskmethod1("x", -1, 0, "y", 1)
shellmethod1("x", -1, 0, "y", 1)
diskmethod2("x", 50, -1, 0, "y", 1, "m")
shellmethod2("x", 50, -1, 0, "y", 1, "m") 

%%
diskmethod1("x", -2, -1, "y", -3)
shellmethod1("x", -2, -1, "y", -3) 
diskmethod2("x", 50, -2, -1, "y", -3, "m")
shellmethod2("x", 50, -2, -1, "y", -3, "m") % Not right, less than 20.944

%%
diskmethod1("x", 1, 2, "y", -1)
diskmethod2("x", 50, 1, 2, "y", -1, "m")

%%
diskmethod1("x", -2, -1, "y", -1)
diskmethod2("x", 50, -2, -1, "y", -1, "m")

%%
diskmethod1("x", -2, -1, "y", 0)
diskmethod2("x", 50, -2, -1, "y", 0, "m")

%% f(x) = x around vertical axis.
diskmethod1("x", -2, -1, "x", 1) % 
shellmethod1("x", -2, -1, "x", 1)
diskmethod2("x", 50, -2, -1, "x", 1, "m")

%%
diskmethod1("x", -2, -1, "x", 0)
shellmethod1("x", -2, -1, "x", 0)
diskmethod2("x", 50, -2, -1, "x", 0, "m")

%%
diskmethod1("x", -4, -2, "x", -6) %108.909
shellmethod1("x", -4, -2, "x", -6)
diskmethod2("x", 50, -4, -2, "x", -6, "m")

%%
diskmethod1("x", 0, 1, "x", 2) %14.1888
shellmethod1("x", 0, 1, "x", 2)
diskmethod2("x", 50, 0, 1, "x", 2, "m")

%% TESTING x^2
diskmethod1("x^2", 0, 1, "x", 0)
shellmethod1("x^2", 0, 1, "x", 0)
diskmethod2("x^2", 50, 0, 1, "x", 0, "m")

%%
diskmethod1("x^2", 4, 9, "x", 1) % 62.3083
shellmethod1("x^2", 2, 3, "x", 1)
diskmethod2("x^2", 50, 4, 9, "x", 1, "m")

%%
diskmethod1("x^2", 4, 9, "y", 0) % 
shellmethod1("x^2", 2, 3, "y", 0)

%%
diskmethod1("x^2", 2, 3, "y", 9) % 225.5664
shellmethod1("x^2", 4, 9, "y", 9)
diskmethod2("x^2", 50, 2, 3, "y", 9, "m")

diskmethod1("x^2", 2, 3, "y", 4) % 23.6667
shellmethod1("x^2", 4, 9, "y", 4)
diskmethod2("x^2", 50, 2, 3, "y", 4, "m")

%%
diskmethod1("x^2", 5, 10, "y", 1)
shellmethod1("x^2", 25, 100, "y", 1)
diskmethod2("x^2", 50, 5, 10, "y", 1, "m")
shellmethod2("x^2", 50, 25, 100, "y", 1, "m") 

%%
diskmethod1("x^2", 2, 3, "y", -1) % 172.3684
shellmethod1("x^2", 4, 9, "y", -1)
diskmethod2("x^2", 100, 2, 3, "y", -1, "m")
shellmethod2("x^2", 50, 4, 9, "y", -1, "m")  

%%
diskmethod2("x^2", 50, 2, 3, "y", 9, "m")
diskmethod2("x^2", 50, 2, 3, "y", 1, "m")
diskmethod2("x^2", 50, 2, 3, "y", -1, "m")
%% TESTING 2^x
diskmethod1("2^x", -3, 0, "y", 10) % Right
shellmethod1("2^x", 2^(-3), 2^(0), "y", 10)
diskmethod2("2^x", 50, -3, 0, "y", 10, "m")
shellmethod2("2^x", 50, 2^(-3), 2^(0), "y", 10, "m")  

%%
diskmethod1("2^x", -3, 0, "y", 0) % Should be 2.2308
shellmethod1("2^x", 2^(-3), 2^(0), "y", 0)
diskmethod2("2^x", 50, -3, 0, "y", 0, "m")
shellmethod2("2^x", 50, 2^(-3), 2^(0), "y", 0, "m")

%%
diskmethod1("2^x", -3, -1, "y", -1) % Should be 3.9304, equal
shellmethod1("2^x", 2^(-3), 2^(-1), "y", -1) % 
diskmethod2("2^x", 50, -3, -1, "y", -1, "m")
shellmethod2("2^x", 50, 2^(-3), 2^(-1), "y", -1, "m")

%%
diskmethod1("2^x", -2, 2, "y", 5) % Right, and equal
shellmethod1("2^x", 2^(-2), 4, "y", 5)
diskmethod2("2^x", 50, -2, 2, "y", 5, "m")

%%
diskmethod1("2^x", -2, 2, "y", 0)
shellmethod1("2^x", 2^(-2), 4, "y", 0)

%%
diskmethod1("2^x", -2, 0, "y", -1) % 8.9231
shellmethod1("2^x", 2^(-2), 1, "y", -1)
diskmethod2("2^x", 50, -2, 0, "y", -1, "m")
%%
diskmethod1("2^x", -10, -5, "y", 0)
shellmethod1("2^x", 2^(-10), 2^(-5), "y", 0)
diskmethod2("2^x", 50, -10, -5, "y", 0, "m")

%%
diskmethod1("2^x", -10, -5, "y", 1)
shellmethod1("2^x", 2^(-10), 2^(-5), "y", 1)
diskmethod2("2^x", 50, -10, -5, "y", 1, "m")

%%
diskmethod1("2^x", 4, 32, "x", 2)
shellmethod1("2^x", 2, 5, "x", 2)
diskmethod2("2^x", 50, 4, 32, "x", 2, "m")

%%
diskmethod1("2^x", -1, 1, "y", 0) %Right
diskmethod1("2^x", 1, 2, "y", 0) %Right
diskmethod1("2^x", 1, 2, "y", -1) %Right
diskmethod1("2^x", 1, 2, "y", 4) %Right
