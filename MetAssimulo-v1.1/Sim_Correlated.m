function [ concs1,concs2,X1,X2,SIGMA1,SIGMA2] = Sim_Correlated(n,nreplcontrol,nreplcase,concN,concM,Corr1,Corr2,outputdir,corr_metb)
% Sim_Correlated: Simulate concentrations from multivariate normal for correlated
% metabolites

%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

% Corr = Correlation Matrix

%%% COMPUTE NEAREST CORRELATION MATRIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm from Higham N: 
% Computing the nearest correlation matrix - a problem from finance. 
% IMA JOURNAL OF NUMERICAL ANALYSIS 2002, 22(3):329–343.
    
function [B] = Spectral_Decomp(A)
%Spectral_Decomp: Computes Positive part of Spectral Decomposition of A
    [Q,D]=eig(A);
    n=size(A);
    for q = 1:n
        D(q,q) = max(D(q,q),0);
    end;
    B=Q*D*Q';
end
    
function [ Pu ] = Pu(A)
% Set diagonal to 1's
    n=size(A);
    for w=1:n
        A(w,w)=1;
    end;
    Pu=A;
end

S1=0;
X1=Corr1;
S2=0;
X2=Corr2;
m=10;
for k=1:m
    R1=X1-S1;
    R2=X2-S2;
    Z1=Spectral_Decomp(R1);
    Z2=Spectral_Decomp(R2);
    S1=Z1-R1;
    S2=Z2-R2;
    X1=Pu(Z1);
    X2=Pu(Z2);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% CONSTRUCT COVARIANCE MATRICES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[SIGMA1,sigma1]=Cov_Matrix(X1,concN(:,2));
[SIGMA2,sigma2]=Cov_Matrix(X2,concM(:,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concs1=mvnrnd(concN(:,1),SIGMA1,nreplcontrol);
concs2=mvnrnd(concM(:,1),SIGMA2,nreplcase);

%ensure no negative concentrations
neg1=1;
while neg1 ~=0
check=0;
for i=1:n
    if concs1(i) <0
        check=check+1;
    end;
end;
if check == 0
    neg1=0;
else
concs1=mvngen(concN(:,1),SIGMA1,nreplcontrol);
end;
end;

neg2=1;
while neg2 ~=0
check=0;
for i=1:n
    if concs2(i) <0
        check=check+1;
    end;
end;
if check == 0
    neg2=0;
else
    concs2=mvngen(concM(:,1),SIGMA2,nreplcase);
end;
end;

file=fopen(strcat(outputdir,'/Correlation_and_Covariances.txt'),'w');

fprintf(file, '\n%s\n\n','Correlated Metabolites');
for i=1:n
    fprintf(file,'%s',corr_metb{i});
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','User Correlation Input for Mixture 1');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',Corr1(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Adjusted Correlation Matrix for Mixture 1');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',X1(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Covariance Matrix for Mixture 1');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',sigma1(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Adjusted Covariance Matrix for Mixture 1');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',SIGMA1(i,j));
    end;
    fprintf(file,'\n');
end;

fprintf(file, '\n%s\n\n','User Correlation Input for Mixture 2');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',Corr2(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Adjusted Correlation Matrix for Mixture 2');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',X2(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Covariance Matrix for Mixture 2');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',sigma2(i,j));
    end;
    fprintf(file,'\n');
end;
fprintf(file, '\n%s\n\n','Adjusted Covariance Matrix for Mixture 2');
for i=1:n
    for j=1:n
        fprintf(file,'%g\t',SIGMA2(i,j));
    end;
    fprintf(file,'\n');
end;
fclose(file);
end

