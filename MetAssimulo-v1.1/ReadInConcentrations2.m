function [concN,concM,nmolecules] = ReadInConcentrations2(file_control,file_case) 
% ReadInConcentrations: reads in the concentrations from the two input files.
%--------------------------------------------------------------------------
% Reads in the concentration data from the two input files. It loops
% through and matches the molecule names in each file, so they are not
% required to be in the same order.
% It accounts for if there are molecules only present in one input file.
% Also warns you about repetition within the files.
%
% [file_control, file_case, nocase] = ReadInConcentrations(concN, concM, molecules, n)
%
% Input:
%   file_control   File location of mixture 1 concentration information.
%   file_case      File location of mixture 2 concentration information.
%   nocase         1 if the concentration file for mixture 2 is not present.  
%
% Output:
%   concN          The mean and standard deviation of the metabolites in mixture 1.
%   concM          The mean and standard deviation of the metabolites in mixture 2.
%   molecules      The names of the metabolites in the mixtures.
%     
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

    
[molecules1, mean_conc, stdev_conc] = textread(file_control,'%q\t %f %f',...
    'headerlines',1,'commentstyle','matlab');           % Read control concentrations from tab-delimited file.
[molecules2, mean_conc_ratio, stdev_conc_ratio] = textread(file_case,'%q\t %f %f',...
    'headerlines',1,'commentstyle','matlab');  % Read case concentrations from tab-delimited file. 

molecule1=lower(molecules1);
molecule2=lower(molecules2);
list1=[mean_conc,stdev_conc];
list2=[mean_conc_ratio,stdev_conc_ratio];
i=1;
j=0;
molecules=cell(0);
data1=[];
data2=[];
while i<=length(molecule1) && ~isempty(list2)
    match1=strmatch(molecule1(i),molecule2,'exact');
    if ~isempty(molecules) && ~isempty(strmatch(molecule1(i),molecules,'exact'))
        % Check for repeat in Mix 1
        warning(strcat(molecule1{i},'is repeated in mixture 1 concentration file.'));
        molecule1(i)=[];
        list1(i,:)=[];
    elseif length(match1)==1 % Metabolite in both
        j=j+1;
        molecules(j)=molecule1(i);
        data1(j,:)=list1(i,:);
        data2(j,:)=list2(match1,:);
        molecule1(i)=[];
        molecule2(match1)=[];
        list1(i,:)=[];
        list2(match1,:)=[];    
    elseif isempty(match1) % Metabolite in Mix1 only
        i=i+1;
    else % Metabolite in both and repeated in Mix2
        j=j+1;
        molecules(j)=molecule1(i);
        data1(j,:)=list1(i,:);
        data2(j,:)=list2(match1(1),:);
        molecule1(i)=[];
        molecule2(match1)=[];
        list1(i,:)=[];
        list2(match1,:)=[];
        warning(strcat(molecules{j},' is repeated in mixture 2 concentration file.'));
    end;
    
end;
i=1;
while i<=length(molecule1) && ~isempty(molecules) &&~isempty(molecule1)
        match2=[strmatch(molecule1(i),molecule1,'exact'),strmatch(molecule1(i),molecules,'exact')];
        if length(match2)>1
            warning(strcat(molecule1{i,1},' is repeated in mixture 1 concentration file.'));
            list1(i,:)=[];
            molecule1(i)=[];
        else
            i=i+1;
        end;
end;
i=1;
while i<=length(molecule2) && ~isempty(molecule2) && ~isempty(molecules)
        match3=[strmatch(molecule2(i),molecule2,'exact');strmatch(molecule2(i),molecules,'exact')];
        if length(match3)>1
            warning(strcat(molecule2{i,1},' is repeated in mixture 2 concentration file.'));
            list2(i,:)=[];
            molecule2(i)=[];
        else
            i=i+1;
        end;
end;

N1=length(molecule1);
N2=length(molecule2);
nmolecules = [molecules; molecule1; molecule2];  % The metabolite names to be used as directory names.
concN = [data1;list1;zeros(N2,2)];                     % Will contain the mean concentration and standard deviation concentration for the first mixture molecules.
concM = [data2;zeros(N1,2);list2];            % Will contain the mean concentration ratio and standard deviation concentration ratio for the second mixture molecules.
                




