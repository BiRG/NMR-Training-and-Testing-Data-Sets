function [ Cov,cov ] = Cov_Matrix(A,v)
% Cov_Matrix: Constructs covariance matrix from metabolite
% concentration variances and correlations.
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

n=size(A);
Cov=zeros(n(1),n(1));
k=0;
scale=0;
for i= 1:n
    for j=1:n
        Cov(i,j)=A(i,j)*v(i)*v(j);
    end;
end;
cov=Cov;
[T,num] = chol(Cov);
p=0.05;
q=1;
s=1;
for i=1:n
    scale=scale+Cov(i,i);
end;
scale=scale/n(1);
while num ~= 0
   epsilon=p*scale;
   for i=1:n
    Cov(i,i) = epsilon+Cov(i,i);
   end;
   [T,num] = chol(Cov);
   k=k+1;
   if k == 1000*q
       p=p+0.05;
       q=q+1;
   end;
   if k == 5000
       num = 0;
       warning('UNABLE TO CONVERT VARIANCE MATRIX TO +VE DEFINITE')
   end;
end;
end

