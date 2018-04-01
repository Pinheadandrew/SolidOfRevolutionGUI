function boundVector = inverseFunctionBounds(origFunctionText, lowBound, upBound)
syms x 
g(x) = finverse(str2sym(origFunctionText));

boundVector = double([g(lowBound) g(upBound)]);
end