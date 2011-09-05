function prob = NormalDisCDF(x,m,s)
% NormalDisCDF: Normal distribution cdf
%--------------------------------------------------------------------------
%   prob = NormalDisCDF(x,m,s) 
%   m - mean 
%   s - standard deviation .
  
prob = 0.5 * erfc(-(x - m)./(s * sqrt(2)));

% Safeguarding that the probability is never greater than 1 
prob(find(prob > 1)) = 1;

