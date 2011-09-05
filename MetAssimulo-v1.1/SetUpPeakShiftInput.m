function SetUpPeakShiftInput(pka_file,local_names,synonyms,just_multiplets,name1,name2,multiplets,name3,acidbase,name4)
% SetUpPeakShiftInput: Sets up the peak shift information and converts to names from the local database.
%--------------------------------------------------------------------------
% Produces files for the peak shift input. Converts the metabolite names
% in the pKa and multiplet files into the local metabolite names.
%
% Input
% pka_file          = Location of pKa information file.
% local_names       = Location of the local names for the converter.
% synonyms          = Location of the synonym list.
% just_multiplets   = Location of multiplet information file.
% name1             = pKa output file.
% name2             = Multiplet output file.
%
% Please note the output will be the two files generated with the names as
% of name1 and name2.
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

%%% Get pKa Info
[namespKa, pKa_values] = textread(pka_file,'%s\t %f','delimiter','\t','commentstyle','matlab');
%[names_pKa,pKa,n] = ShiftInfoConverter(namespKa, pKa, local_names, synonyms);
%[molecules_name,pKa_values,n] = ShiftInfoConverter(names_pKa,pKa, local_names, synonyms)
[molecules_name, indices] = Converter(namespKa, local_names, synonyms);
names_pKa = molecules_name(indices);
pKa=pKa_values(indices);

len1=length(names_pKa);
fid = fopen(name1,'wt');
for i = 1:len1
    fprintf(fid, '%s\t', names_pKa{i});
    fprintf(fid,'%g\n', pKa(i));    
end
fclose(fid);

%%% Get Multiplet Positions
[mmetabolites,mtype,mfull1,mfull2,mfull3] = textread(just_multiplets,'%s\t%s\t%f\t%f\t%f\t','delimiter','\t','commentstyle','matlab');
mfull=[mfull1 mfull2 mfull3];
[mmetabolites, indices] = Converter(mmetabolites, local_names, synonyms);
mmetabolites = mmetabolites(indices);
mtype=mtype(indices);
mfull=mfull(indices,:);

len2 = length(mmetabolites);
fid2 = fopen(name2,'wt');
for i = 1:len2
    fprintf(fid2, '%s\t', mmetabolites{i});
    fprintf(fid2, '%s\t', mtype{i});
    fprintf(fid2,'%g\t%g\t%g\n', mfull(i,:));  
end
fclose(fid2);


 %%% Get Multiplet Peaks   
[metabolites,full1,full2,dummy1,dummy2,dummy3,dummy4] = textread(multiplets,...
    '%s\t %f\t %f\t %s\t %f\t %f\t %f\t','headerlines',1,'delimiter','\t');
full=[full1 full2];
[metabolites, indices] = Converter(metabolites, local_names, synonyms);
metabolites = metabolites(indices);
full=full(indices,:);
len3 = length(metabolites);
fid3 = fopen(name3,'wt');
for i = 1:len3
    fprintf(fid3, '%s\t', metabolites{i});
    fprintf(fid3,'%g\t%g\n', full(i,:));  
end
fclose(fid3);

%%% Read Acid/Base Limits
[abmets,abfull1,abfull2,abfull3] = textread(acidbase,'%s\t %f\t %f\t %f\t','delimiter','\t','commentstyle','matlab');
abfull=[abfull1 abfull2 abfull3];
[abmets, indices] = Converter(abmets, local_names, synonyms);
abmetabolites = abmets(indices); 
abfull=abfull(indices,:);
len4 = length(abmetabolites);
fid4 = fopen(name4,'wt');
for i = 1:len4
    fprintf(fid4, '%s\t', abmetabolites{i});
    fprintf(fid4, '%g\t%g\t%g\n', abfull(i,:));
end
fclose(fid4);
end




