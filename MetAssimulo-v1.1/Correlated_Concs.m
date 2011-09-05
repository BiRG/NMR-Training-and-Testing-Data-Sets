function [ simconcs1,simconcs2,corr1,corr2,cov1,cov2 ] = Correlated_Concs(nc,metb_names,corr_metb,corr1,corr2,conc1,conc2,n,nreplcontrol,nreplcase,ratios,outputdir)
% Correlated_Concs= Simulates concentrations from normal distribution. For
% correlated metabolites, generates appropriate multivariate distribution
% and samples from that.

%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

simconcs1 = zeros(n,nreplcontrol);
simconcs2 = zeros(n,nreplcase);
c=nc(1);
x=zeros(n,1);%indicates correlated metabolites

corr_conc1=zeros(c,2);
corr_conc2=zeros(c,2);
unco_conc1=zeros(n-c,2);
unco_conc2=zeros(n-c,2);
k=0;
l=0;


for i = 1:n % Split the conc info into correlated and uncorrelated
    for j=1:c
        if strcmp(metb_names(i),corr_metb(j)) == 1
           k=k+1;
           x(i)=1;
           corr_conc1(k,:)=conc1(i,:);
           corr_conc2(k,:)=conc2(i,:);
        end;
    end;
end; 

for i=1:n
    if x(i)==0
       l=l+1;
       unco_conc1(l,:)=conc1(i,:); 
       unco_conc2(l,:)=conc2(i,:);
    end;
end;
        

% Simulate uncorrelated concentrations as usual
[unco_conc1,unco_conc2] = SimulationOfConcs(l,nreplcontrol,nreplcase,unco_conc1,unco_conc2,ratios);

% Simulate correlated concentrations   
[corr_conc1,corr_conc2,corr1,corr2,cov1,cov2] = Sim_Correlated(c,nreplcontrol,nreplcase,corr_conc1,corr_conc2,corr1,corr2,outputdir,corr_metb);

% Put simulated concentrations back into original positions in concs1 & 2
p=0;
q=0;

for i=1:n
    if x(i,1) == 1
        p=p+1;
        simconcs1(i,:)=corr_conc1(:,p);
        simconcs2(i,:)=corr_conc2(:,p);
    else
        q=q+1;
        simconcs1(i,:)=unco_conc1(q,:);
        simconcs2(i,:)=unco_conc2(q,:);
    end;
end;


end

