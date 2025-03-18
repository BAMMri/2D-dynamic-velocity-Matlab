function y = sigm_fit(params, x)
  a = params(1);
  b = params(2);
  x0 = params(3);
  dx = params(4);
  y = b + (a-b)./(1+exp(-(x-x0)./dx));