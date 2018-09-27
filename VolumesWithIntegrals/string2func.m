function f = string2func(funcString, inverse)

if inverse == 0
  if funcString == "x"
    f = @(x) x;
  elseif funcString == "x^2"
    f = @(x) x.^2;
  elseif funcString == "2^x"
    f = @(x) 2.^x;
  end
else
  if funcString == "x"
    f = @(x) x;
  elseif funcString == "x^2"
    f = @(x) x.^(1/2);
  elseif funcString == "2^x"
    f = @(x) log2(x);
  end
end
end