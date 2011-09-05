function [ prob] = mvngen(mu,SIGMA,n)
% Multivariate Normal Sample 

[n,d] = size(mu);
[C,p] = chol(sigma);
prob = randn(n,size(C,1)) * C + mu;
end

