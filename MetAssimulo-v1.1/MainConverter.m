function [molecules_name,conc_control,conc_case,no_after_con] = MainConverter(molec_name, local_names, synonyms, conc_control0, conc_case0,outname)
% MainConverter: Converters metabolite names to those of local database. Also prints out the list of metabolites not included.
%--------------------------------------------------------------------------
% 
% Input
% molec_name      = Name of the metabolite 
% local_names     = Location of the file containing the list of metabolite names from the local database.  
% synonyms        = Location of the file containing the synonym list.
% conc_control0   = The concentration information for metabolites in mixture 1. Contains
%                   mean and standard deviation.
% conc_case0      = The concentration information for metabolites in mixture 2. Contains
%                   mean and standard deviation.
% outname         = Location of the file that is written by this function
%                   to identify which metabolites are not present in the
%                   local database.
%
% Output
% molecules_name  = The converted names for the metabolites with spectra present in the local database. 
% conc_control    = 
% conc_case       = 
% no_after_con    = The number of total metabolite spectra present in the final simulation. 
%
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------


[molecules_name0, indeces] = Converter(molec_name, local_names, synonyms);

molecules_name = molecules_name0(indeces);
conc_control_mean0 = conc_control0(:,1);
conc_control_stddev0 = conc_control0(:,2);

conc_control_mean = conc_control_mean0(indeces);
conc_control_stddev = conc_control_stddev0(indeces);

conc_control = [conc_control_mean, conc_control_stddev];

conc_case_mean0 = conc_case0(:,1);
conc_case_stddev0 = conc_case0(:,2);

conc_case_mean = conc_case_mean0(indeces);
conc_case_stddev = conc_case_stddev0(indeces);

conc_case = [conc_case_mean, conc_case_stddev];

[no_after_con b]= size(conc_control);



% Prints out a list of the metabolites not included
m = molec_name;
m(indeces) = [];
mlen = length(m);

outname1 = fopen(strtrim(outname),'w');         
for i = 1:mlen
    fprintf(outname1, '%s\n', m{i});
end
fclose(outname1);