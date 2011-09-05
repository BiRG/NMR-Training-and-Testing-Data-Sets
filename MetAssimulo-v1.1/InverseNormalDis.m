function x = InverseNormalDis(prob,m,s)
% InverseNormalDis: Inverse of the normal cumulative distribution function (cdf).
%--------------------------------------------------------------------------
%   x = InverseNormalDis(prob,m,s) finds inverse of the normal cdf with
%   mean (m) and standard deviation (s).
%
%   The size of X is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    

x = zeros(size(prob));

x(find(prob == 0)) = -Inf;
x(find(prob == 1)) = Inf;

% Compute the inverse function for the intermediate values.
inv = find(prob > 0  &  prob < 1);
if inv
    x(inv) = sqrt(2) * s .* erfinv(2 * prob(inv) - 1) + m;
end
