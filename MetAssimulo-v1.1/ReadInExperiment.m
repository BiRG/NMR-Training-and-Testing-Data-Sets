function [experiment_used] = ReadInExperiment(molecules_no, experiment_fileloc)
% ReadInExperiment: reads the experiment file to retrieve a list of experiments to use for each molecule.
%--------------------------------------------------------------------------
% Reads the experiment file to retrieve a list of experiments to use for
% each molecule.
%
% [experiment_used] = ReadInExperiment(molecules_no, experiment_fileloc)
%
% Input:
%  molecules_no         The names of the metabolites in the mixtures.
%  experiment_fileloc   Location of the experiments file.
%
% Output:
%   experiment_used     The experiment numbers for each metabolite.
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------

   
[molec_no exp_no] = textread(experiment_fileloc,'%q\t %f','commentstyle','matlab');     % Read in the experiments file.
total = length(molecules_no);   
total2 = length(molec_no);      
experiment_used = zeros(1,total);

for i = 1:total
    for j = 1:total2
        match = strcmp(molecules_no(i), molec_no(j)); 
            % Comparing the metabolite names in the mixture files with those in the list of experiment numbers.  
        if match == 1
            experiment_used(:,i) = exp_no(j); 
        end
    end
end
