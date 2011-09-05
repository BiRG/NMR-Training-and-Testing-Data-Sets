function [molecules_name, ind] = Converter(molec_name, local_names, synonyms)
% Converter: Calls the synonym converter then finds out which metabolite names are converted.
%--------------------------------------------------------------------------
% 
% 1. Calls the function SynonymConverter, which converts the input list of
%       molecule names (molec_name) to the metabolite spectra present in the
%       local database.
% 2. Finds the indeces of the cells containing converted metabolite names.
%     
% 
% Input:
%           molec_name      The input list of metabolite names.
%           local_names     Location of list containing metabolite names and
%                           their corresponding local database names.
%           synonyms        Location of the synonym list.
%
% Output:
%           molecules_name  List containing converted metabolite names (and empty spaces where there is no conversion).
%           ind             Indeces for which cells contain names that have been converted.
%
% e.g.
%   [molecules_name0, indeces] = Converter(molec_name, local_names, synonyms)
%
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------


molecules_name = SynonymConverter(molec_name, local_names, synonyms);

        % Converts the input metabolite names to those names in the local database. 
lenmol = length(molecules_name);
count1 =1;

        % Finds the number of cells containing metabolite names.
for a=1:lenmol
   present = iscellstr(molecules_name(a)); 
   if present == 1
       count1 = count1+1; 
   end
end


count2 =1;
indeces = zeros(1,lenmol);

        %Finding the indeces for the cells containing entries.

for b=1:lenmol
   present = iscellstr(molecules_name(b)); 
   if present == 1
       indeces(count2) = 1;
   end
   count2 = count2+1; 
end

ind = find(indeces==1);
