function [names_pKa, pKa, mmetabolites,mtype,mfull,metabolites,full,abmetabolites,...
    abfull] = PeakShiftInput(name1,name2,name3,name4)
% PeakShiftInput: Reads in the peak shift input files.
%--------------------------------------------------------------------------
% Input
% name1 = Location of file containing pKa information.
% name2 = Location of file containing multiplets information.
% name3 = Location of file containing metabolites peak information.
% name4 = Location of file containing acid base limit information.
%
% Output
% names_pKa         Metabolite names corresponding to pKa values.
% pKa               The pKa values for each metabolite.
% mmetabolites      Metabolite names corresponding to multiplet information.
% mtype             The type of multiplet e.g. 's' is singlet, 'd' is doublet.
% mfull             Contains the multiplet midpoint, along with the lower and upper boundaries of the multiplet.
% metabolites       Metabolite names corresponding to peak information.
% full              Contains peak position and the position of the multiplet center.
% abmetabolites     Metabolite names corresponding to acid/base information.
% abfull            Contains the center of the peak, the acid limit and the base limit.
%
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

[names_pKa pKa] = textread(name1,'%s %f', 'delimiter', '\t');    
 
[mmetabolites mtype mc ms me] = textread(name2,'%s %s %f %f %f', 'delimiter', '\t');    
 
[metabolites ppos mcen] = textread(name3,'%s %f %f', 'delimiter', '\t'); 

full = [ppos mcen];

mfull = [mc ms me];

[abmetabolites abcen acid base] = textread(name4,'%s %f %f %f', 'delimiter', '\t');

abfull = [abcen acid base];