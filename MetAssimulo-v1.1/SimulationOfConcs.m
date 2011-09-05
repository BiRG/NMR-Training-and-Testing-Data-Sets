function [concs1,concs2] = SimulationOfConcs(n,nreplcontrol,nreplcase,concN,concM,ratios) 
% SimulationOfConcs: Simulation of metabolite concentrations.
%--------------------------------------------------------------------------
% For the number of metabolites and the number of replicates produces
% concentrations for the two mixture input files about a truncated normal
% distribution.
%
% [concs1,concs2] = SimulationOfConcs(n,nreplcontrol,nreplcase,concN,concM,ratios)
%
% Input:
%   n              The total number of metabolites in the mixtures.
%   nreplcontrol   Number of replicates of mixture 1.
%   nreplcase      Number of replicates of mixture 2.
%   concN          The mean and standard deviation of the metabolites in mixture 1.
%   concM          The mean and standard deviation of the metabolites in mixture 2.
%   ratios         1 if the case concentrations are ratios, 0 if they are not.
%
% Output:
%   concs1         Simulated concentrations of each metabolite in mixture 1 for a number of replicates.  
%   concs2         Simulated concentrations of each metabolite in mixture 1 for a number of replicates.  
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

concs1 = zeros(n,nreplcontrol);
concs2 = zeros(n,nreplcase);

for i = 1:nreplcontrol                                                                                         
     lowerProb = NormalDisCDF((0-concN(:,1))./concN(:,2),0,1);          % Creating truncated normal distribution. 
     test = isnan(lowerProb);
     lowerProb(test) =0;
     upperProb = 1;
     u = lowerProb+(upperProb-lowerProb).*rand(size(concN(:,1)));       % Taking a value from the truncated normal distribution. 
     concs1(:,i) = concN(:,1) + concN(:,2) .*InverseNormalDis(u,0,1);   % Simulating the metabolite concentration.                               
end
    
for i = 1:nreplcase 
     lowerProb = NormalDisCDF((0-concN(:,1))./concN(:,2),0,1);          % Creating truncated normal distribution. 
     upperProb = 1;
     u = lowerProb+(upperProb-lowerProb).*rand(size(concN(:,1)));       % Taking a value from the truncated normal distribution. 
     
     if ratios ==1                                                      % If the concentrations are ratios.
         concs2(:,i) = concN(:,1).*concM(:,1) + concN(:,2).*concM(:,2).*InverseNormalDis(u,0,1);  
                                                                        % Simulating the metabolite concentration.            
     end

     if ratios ==0                                                      % If the concentrations are absolute.
         for j=1:n
         if concN(j,1) ==0 || concN(j,2) ==0
             concs2(j,i)=0;
         else
         concs2(j,i) = concN(j,1)*(concM(j,1)/concN(j,1)) + concN(j,2)*(concM(j,2)/concN(j,2))*InverseNormalDis(u(j),0,1);  
         end
         end% Simulating the metabolite concentration.
    end
end
