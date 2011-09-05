function [protons] = ReadInProtons(molec_name, protons_fileloc)
% ReadInProtons: reads the proton file to create a list of the number of protons per metabolite.
%--------------------------------------------------------------------------
% Reads the proton file to create a list of the number of protons per
% metabolite.
%
% [protons] = ReadInProtons(molec_name, protons_fileloc)
%
% Input:
%  molec_name           The names of the metabolites in the mixtures.
%  protons_fileloc      Location of the protons file.
%
% Output:
%   protons             The number of protons for each metabolite.
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------

[molec_no prot_no] = textread(protons_fileloc,'%q\t %f','commentstyle','matlab');    % Read the protons file.
total = length(molec_name);
total2 = length(molec_no);
protons = zeros(1,total);

for i = 1:total
    for j = 1:total2
        match = strcmp(molec_name(i), molec_no(j));
         % Comparing the metabolite names in the mixture files with those in the list of proton numbers.  
        if match == 1
            protons(:,i) = prot_no(j); 
        end
    end
end
for i=1:total
    if protons(i) == 0
        message=strcat('Proton number for :',molec_name{i},' not found');
        warning(message);
        protons(i)=1;
    end;
end;
