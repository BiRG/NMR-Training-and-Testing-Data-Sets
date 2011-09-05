function [] = AddNewSpectra()
%--------------------------------------------------------------------------
% Creates METAssimulo Input files from Local Database and HMDB
%
%                    Harriet Muncey (2010)
%--------------------------------------------------------------------------

close(gcbf);
[metabolites,expno]=GUIAddSpectra;
close(gcbf);
[Sex,Age,BIOFLUID]=GUIHMDBScan();
close(gcbf);
if isempty(metabolites)==0


csf=0;
if strcmpi(BIOFLUID,'CSF')
    csf=1;
end;

if Sex == 1
    sex = 'female';
elseif Sex == 2
    sex = 'male';
elseif Sex == 3
    sex = 0;
end;
age=cell(7,1);
a=0;
if Age(1) == 1
    a=a+1;
    age{a} = 'newborn';
end;
if Age(2) ==1
    a=a+1;
    age{a} = 'infant';
end;
if Age(3) ==1
    a=a+1;
    age{a} = 'children';
end;
if Age(4) == 1
    a=a+1;
    age{a} ='adolescent';
end;
if Age(5) == 1
    a=a+1;
    age{a} ='adult';
end;
if Age(6) == 1
    a=a+1;
    age{a} = 'elderly';
end;
if Age(7) == 1
    age = 0;
end;

disp('********************************');
disp('* Please Load Metabocards File *');
disp('********************************');
disp('');
[mtb_name,mtb_location] = uigetfile('*.txt','Please Load Metabocards File');
filepath=fullfile(mtb_location,mtb_name);
file = fopen(filepath,'r');
disp('********************************************');
disp('* Please Specify Location of NMR Peaklists *');
disp('********************************************');
disp('');
pk_location = uigetdir('','Specify Location of NMR Peaklists');
mult_data = dir(pk_location);
disp('******************************************');
disp('* Please Specify Location of Input Files *');
disp('******************************************');
disp('');
input_loc = uigetdir('','Specify Location of Input Files');
disp('********************************************')
disp('* Searching............................... *')
disp('********************************************')
disp('');

% Create output Files

if exist(fullfile(input_loc,'synonym_converter.txt'),'file') == 0
   synfile=fopen(fullfile(input_loc,'synonym_converter.txt'),'w');
else
   synfile=fopen(fullfile(input_loc,'synonym_converter.txt'),'a'); 
end;

if exist(fullfile(input_loc,'raw_uM_concentrations.txt'),'file') == 0
    concfile1=fopen(fullfile(input_loc,'raw_uM_concentrations.txt'),'w');
    fprintf(concfile1,'%s\t%s\t%s\n','NMR STANDARDS','MEAN','ST DEV');
else
    concfile1=fopen(fullfile(input_loc,'raw_uM_concentrations.txt'),'a');
end;

if exist(fullfile(input_loc,'raw_mmolcr_concentrations.txt'),'file') == 0
    concfile2=fopen(fullfile(input_loc,'raw_mmolcr_concentrations.txt'),'w');
    fprintf(concfile2,'%s\t%s\t%s\n','NMR STANDARDS','MEAN','ST DEV');
else
    concfile2=fopen(fullfile(input_loc,'raw_mmolcr_concentrations.txt'),'a');
end;

if exist(fullfile(input_loc,'peak_shift','peaks.txt'),'file') ==0
    output=fopen(fullfile(input_loc,'peak_shift','peaks.txt'),'w');
else
    output=fopen(fullfile(input_loc,'peak_shift','peaks.txt'),'a');
end;

rmv=zeros(max(length(metabolites)),1);
if exist(fullfile(input_loc,'local_names.txt'),'file') ==0
    molfile=fopen(fullfile(input_loc,'local_names.txt'),'w');
else
    molfile=fopen(fullfile(input_loc,'local_names.txt'),'r');
    while ~feof(molfile) 
        tline=fgetl(molfile);
        name=textscan(tline,'%s','delimiter','\t');
        for j=1:max(length(metabolites))
            if sum(strcmp(name{1,1},metabolites{j})) ~= 0 % If we have a metabolite already in the input
                rmv(j)=GUICheck(metabolites(j)); % Check user still wishes to add it.
                close(gcbf);    
            end;
        end;
    end;
    fclose(molfile);
    molfile=fopen(fullfile(input_loc,'local_names.txt'),'a');
end;

if exist(fullfile(input_loc,'experiments.txt'),'file') ==0
    expfile=fopen(fullfile(input_loc,'experiments.txt'),'w');
else
    expfile=fopen(fullfile(input_loc,'experiments.txt'),'a');
end;

if exist(fullfile(input_loc,'peak_shift','multiplets.txt'),'file') ==0
    mult=fopen(fullfile(input_loc,'peak_shift','multiplets.txt'),'w');
else
    mult=fopen(fullfile(input_loc,'peak_shift','multiplets.txt'),'a');
end;



z=0;
Local_Names=cell(1,max(length(metabolites))-sum(rmv));
if max(length(metabolites))~=sum(rmv)
    
for i=1:max(length(metabolites))
    if rmv(i) == 0
        z=z+1;
        Local_Names{z}=metabolites{i};
    end;
end;

for i=1:length(Local_Names)
    experiment=num2str(expno{1,i});
    fprintf(expfile,'"%s"\t%s\n',Local_Names{i},experiment);
end;
fclose(expfile);

Mult_Data=cell(1,max(length(mult_data))-2);
for i=3:max(length(mult_data))
    Mult_Data{i-2}=mult_data(i).name;
end;

hmdb_names={};
count=0;
countnames=0;
total=0;
namecheck=zeros(1,length(Local_Names));

%--------------------------------------------------------------------------
% Search metabocards_all.txt for required data.
%--------------------------------------------------------------------------

while ~feof(file) || tline ~= -1 || count == max(length(Local_Names))
    tline=fgets(file); 
    k=tline;
     
    % Find start of metabocard
    if strncmpi('#BEGIN',k,6) == 1 
        
        % Initialise Variables
        syn = 0;
        name = 0;
        skip=0;
        fluid=0;
        id=0;
        noconc=0;
        checksum=0;
        wrongbiofluid=0;
        
        % Find metabolite Biofluid list
        while fluid ~= 1 
            tline=fgetl(file);
            fluid=strncmpi('# biofluid_location',tline,18);
            if strncmp('#END',tline,4) == 1
                fluid = 1;
                skip=1;
            end;
        end;
        tline=fgetl(file);
        fluidlist=tline;
       
        % Read HMDB_ID
        
        while id ~= 1 && skip ==0
            tline=fgetl(file);
            id=strncmp('# hmdb_id',tline,9);
        end;
        tline=fgetl(file);
        hmdb_id=tline;
         
        % Find metabolite name
        while name ~= 1 && skip==0
            tline=fgetl(file);
            name=strncmp('# name',tline,6);
            if strncmp('#END',tline,4) == 1
                name = 1;
                skip=1;
            end;
        end;
        tline=fgetl(file);
        name=tline;
                
        % Find synonyms
        while syn ~= 1 && skip ==0
            tline=fgetl(file);
            syn = strncmpi('# syn',tline,5);
            if strncmpi('#END',tline,4) == 1
                syn =1;
                skip=1;
            end;
        end;
        
        tline=fgetl(file);
        temp=regexp(tline, '\; ', 'split');
        n=length(temp);
        synonyms{1}=name;
        for i=2:n+1
            synonyms{i}=temp{i-1};
        end;
        s=length(synonyms);
        
        if skip ==0
            % Find Local Database Name
            namematch{1}='';
            namematch{2}='';
            namematch{3}='';
            synonymmatch{1}='';
            synonymmatch{2}='';
            synonymmatch{3}='';
            matched=0;
            for i = 1:s  
                for j=1:length(Local_Names)                          
                    match=0;
                    namematch{1}=regexprep(Local_Names{j},'\_','\ ');
                    namematch{2}=regexprep(Local_Names{j},'\,','\ ');
                    namematch{3}=regexprep(Local_Names{j},'\-','\ ');
                    synonymmatch{1}=regexprep(synonyms{i},'\_','\ ');
                    synonymmatch{2}=regexprep(synonyms{i},'\,','\ ');
                    synonymmatch{3}=regexprep(synonyms{i},'\-','\ ');
                    for k=1:3
                        match=match+sum(strcmpi(namematch{k},synonymmatch));
                    end;
                    if match ~=0
                         count=count+1;
                         hmdb_names{count}=Local_Names{j};
                         fprintf(molfile,'%s\t%s\n',Local_Names{j},name);
                         namecheck(j)=1;
                         matched=1;
                    end;
                end;
            end;
            
            if matched == 0
                skip=1;
            end;
       
            % Check metabolite appears in urine
            fluids=regexp(fluidlist, '\;', 'split');
            check=strcmpi(fluids,BIOFLUID);
            if csf == 1 && sum(check)==0
                 check=strcmpi(fluids,'Cerebrospinal Fluid');
            end;
            checksum=sum(check);
            if checksum ==0
                fluids=regexp(fluidlist, '\;\ ', 'split');
                check=strcmpi(fluids,BIOFLUID);
                if csf == 1 && sum(check)==0
                    check=strcmpi(fluids,'Cerebrospinal Fluid');
                end;      
                checksum=sum(check); 
                if checksum ==0 && skip ==0
                    skip=1;
                    disp('');
                    if exist(fullfile(input_loc,'could_not_find_data.txt'),'file') ==0
                        leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'w');
                    else
                        leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'a');
                    end;
                    warn=strcat('### ',name,' does not appear in ',BIOFLUID,' samples ###');
                    disp(warn);
                    fprintf(leftout,'%s\t%s\t%s\t%s\t%s\n',hmdb_id,'Does not appear in ',BIOFLUID,' samples',name);
                    wrongbiofluid=1;
                    fclose(leftout);
                end;
            end;
            
            if skip ==0              
            % Print synonyms to file
            for i = 1:s
                fprintf(synfile,'"%s"\t"%s"\n',name,synonyms{i}); 
            end;
            end;
        end;
               
        concheck = 0;
        % Loop through if sample biofluid isn't urine AND normal...
        sample=1;
        while skip == 0
            skipsample=0;
            
            % Check for end of metabocard
            if strncmp('#END',tline,4) == 1
              skip=1;
              skipsample=1;
            end;
            
            % Initialise sample variables
            
            concentration_biofluid = strcat('# concentration_',num2str(sample),'_biofluid:');
            concentration_age = strcat('# concentration_',num2str(sample),'_age:');
            concentration_sex = strcat('# concentration_',num2str(sample),'_sex:');
            concentration_units = strcat('# concentration_',num2str(sample),'_units:');
            concentration =strcat('# concentration_',num2str(sample),'_concentration');
            patient_status=strcat('# concentration_',num2str(sample),'_patient_status');
            fluid_field=0;
            correct_age=0;
            correct_sex=0;
            correct_units=0;
            units=0;
            data=0;
            noconc=0;
            status =0;
            mean='';
            sd=0;
            
            % Find age field if needed and check age
            if age ~= 0 && skipsample == 0
                while correct_age ~= 1
                  tline=fgetl(file);
                  correct_age=strncmpi(concentration_age,tline,21);
                  if strncmpi('#END',tline,4) == 1
                     skipsample=1;
                     skip=1;
                  end;
                end;
                tline=fgetl(file);
                if sum(strncmpi(tline,age,5)) == 0
                    skipsample=1;
                end; 
            end;
              
            % Find biofluid field and check
            if skipsample ==0
            while fluid_field~=1
                tline=fgetl(file);
                fluid_field=strncmpi(concentration_biofluid,tline,25);  
                if strncmpi('#END',tline,4) == 1
                    skip=1;
                    skipsample=1;
                    fluid_field=1;
                end;
            end;
            tline=fgetl(file);           
            if strncmpi(BIOFLUID,tline,5) ~= 1 
                skipsample =1;
            end;
            end;
            
            % Find the concentration                   
            if skipsample ==0
            while data ~=1 
                tline=fgetl(file);
                data=strncmpi(concentration,tline,28);
                if strncmpi('#END',tline,4) == 1
                    skipsample=1;
                    skip=1;
                    data=1;
                end;
            end;
            tline=fgetl(file);
            conc=tline;
            end;
            
            % Check patient is 'normal'
            if skipsample ==0
            while status ~=1
                tline=fgetl(file);
                status=strncmpi(patient_status,tline,28);
                if strncmpi('#END',tline,4) == 1
                   skipsample=1;
                   skip=1;
                   status=1;
                end;       
            end;     
            tline=fgetl(file);
            if strncmpi('normal',tline,6)~=1
                skipsample =1;
            end;
            end;
            
            %If needed, check correct sex
            if sex ~= 0 && skipsample ==0
                while correct_sex ~= 1
                    tline=fgetl(file);
                    correct_sex=strncmpi(concentration_sex,tline,21);
                     if strncmpi('#END',tline,4) == 1
                         skip = 1;
                         skipsample=1;
                         correct_sex=1;
                     end;
                end;
                tline=fgetl(file);
                if strncmpi(sex,tline,4) ~=1 && strncmpi('both',tline,4) ~=1
                     skipsample = 1;
                end;   
            end;
            
            % Check correct units
            if skipsample ==0
                while correct_units ~= 1
                    tline=fgetl(file);
                    correct_units=strncmpi(concentration_units,tline,22);
                    if strncmpi('#END',tline,4) == 1
                        skipsample = 1;
                        skip=1;
                        correct_units=1;
                    end;
                end;
                tline=fgetl(file);
                if strncmpi('umol/mmol creatinine',tline,4) ==1
                    units=2;
                elseif strncmpi('uM',tline,2) == 1
                    units =1;
                else skipsample = 1;
                end;  
            end;
            
            
            if skipsample == 0 % If sample is suitable...
                                                        
                 % Detect format of concentration data
                 if length(sscanf(conc,'%f')) == 1
                    mean = sscanf(conc,'%f');
                    sd=mean*0.1;
                 end;
                 % FORMAT : '<3'
                 if length(sscanf(conc,'<%f')) == 1
                    mean = [];
                    sd=[];
                 end;
                       
                 % FORMAT : '>3'
                 if length(sscanf(conc,'>%f')) == 1
                    mean = [];
                    sd=[];
                 end; 
                       
                 % FORMAT : '< 3'
                 if length(sscanf(conc,'< %f')) == 1
                    mean = [];
                    sd=[];
                 end;
                       
                 % FORMAT : '> 3'
                 if length(sscanf(conc,'> %f')) == 1
                     mean = [];
                     sd=[];
                 end;
                       
                 % FORMAT : '3(0.1-0.4)'
                 if length(sscanf(conc,'%f (%f-%f)')) == 3
                    split = sscanf(conc,'%f (%f-%f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'%f ( %f-%f)')) == 3
                    split = sscanf(conc,'%f ( %f-%f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'%f ( %f -%f)')) == 3
                    split = sscanf(conc,'%f ( %f -%f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);    
                            
                 elseif length(sscanf(conc,'%f ( %f - %f)')) == 3
                    split = sscanf(conc,'%f ( %f - %f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);   
                            
                 elseif length(sscanf(conc,'%f( %f - %f)')) == 3
                    split = sscanf(conc,'%f( %f - %f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'%f (%f - %f)')) == 3
                    split = sscanf(conc,'%f (%f - %f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);  
                            
                 elseif length(sscanf(conc,'%f(%f - %f)')) == 3
                    split = sscanf(conc,'%f(%f - %f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96); 
                            
                 elseif length(sscanf(conc,'%f (%f- %f)')) == 3
                    split = sscanf(conc,'%f (%f- %f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);  
                            
                 elseif length(sscanf(conc,'%f(%f-%f)')) == 3
                    split = sscanf(conc,'%f(%f-%f)');
                    mean= split(1);
                    a=split(2);
                    b=split(3);
                    sd=(b-a)/(2*1.96);
                                                        
                 % FORMAT : '(3.1-3.4)'     
                 elseif length(sscanf(conc,'(%f-%f)')) == 2
                    split = sscanf(conc,'(%f-%f)');
                    a=split(1);
                    b=split(1);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'( %f-%f)')) == 2    
                    split = sscanf(conc,'( %f-%f)');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'(%f -%f)')) == 2
                    split = sscanf(conc,'(%f -%f)');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'(%f- %f)')) == 2
                    split = sscanf(conc,'(%f- %f)');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'(%f-%f )')) == 2
                    split = sscanf(conc,'(%f-%f )');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                                                                                 
                 % FORMAT : '3.1-3.4'    
                 elseif length(sscanf(conc,'%f-%f')) == 2
                    split = sscanf(conc,'%f-%f');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96);
                            
                 elseif length(sscanf(conc,'%f -%f')) == 2
                    split = sscanf(conc,'%f -%f');
                    a=split(1);
                    b=split(2);
                    mean=(b-a)/2;
                    sd=(b-a)/(2*1.96); 
                            
                 elseif length(sscanf(conc,'%f- %f')) == 2
                     split = sscanf(conc,'%f- %f');
                     a=split(1);
                     b=split(2);
                     mean=(b-a)/2;
                     sd=(b-a)/(2*1.96);    
                            
                 elseif length(sscanf(conc,'%f - %f')) == 2
                     split = sscanf(conc,'%f - %f');
                     a=split(1);
                     b=split(2);
                     mean=(b-a)/2;
                     sd=(b-a)/(2*1.96);   
                 end;
                       
                 % FORMAT : '3.25 +/- 0.15'
                 if length(sscanf(conc,'%f+/-%f')) == 2
                     split = sscanf(conc,'%f+/-%f');       
                     mean=split(1);
                     sd=split(2)/1.96;
                          
                 elseif length(sscanf(conc,'%f +/-%f')) == 2
                     split = sscanf(conc,'%f +/-%f');       
                     mean=split(1);
                     sd=split(2)/1.96;
                        
                 elseif length(sscanf(conc,'%f +/- %f')) == 2
                     split = sscanf(conc,'%f +/- %f');       
                     mean=split(1);
                     sd=split(2)/1.96;
                          
                 elseif length(sscanf(conc,'%f+/- %f')) == 2
                     split = sscanf(conc,'%f+/- %f');       
                     mean=split(1);
                     sd=split(2)/1.96; 
                 end;
                                   
                 % Check sd > 0
                 if sd < 0
                    sd = -sd; 
                 elseif sd == 0
                    sd=0.1*mean; 
                 end;
                                                                    
                 % Check sd and mean are numbers
                 if isnan(mean) == 0
                    mean=num2str(mean);
                    sd=num2str(sd);
                    total = total + 1;             
                    % Write concentration to file
                    if units ==1 && matched ==1
                          fprintf(concfile1,'"%s"\t%s\t%s\n',name,mean,sd);
                          skip=1;
                          concheck=1;
                    elseif units==2 && matched ==1
                          fprintf(concfile2,'"%s"\t%s\t%s\n',name,mean,sd);
                          skip=1;
                          concheck=1;
                    else
                          noconc=1;    
                    end;
                 else
                    skip=0;                          
                 end;% End processing of concentration data

             end; 
             % If sample isn't suitable look again...
             sample=sample+1; % index next sample
        end;
                 
        % If concentration data obtained, find corresponding
        % multiplet information for metabolite with matching HMDB_ID
        multcheck=0;
        if concheck==1+noconc==1
             check=[];
             check=strncmp(Mult_Data,hmdb_id,9);
             if sum(check) ~=0
                   multcheck=MpltScan(name,hmdb_id,pk_location,mult,output);
                   if multcheck ==1 && matched ==1
                       disp('');
                       warn=strcat('### Unable to read multiplet data for ',name,' ###');
                       disp(warn);
                       if exist(fullfile(input_loc,'could_not_find_data.txt'),'file') ==0
                            leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'w');
                       else
                            leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'a');
                       end;
                       fprintf(leftout,'%s\t%s\t%s\n',hmdb_id,'Unable to read multiplet data for ',name);
                       fclose(leftout);
                   end;
             end;
        elseif wrongbiofluid==0 && matched ==1 && noconc==1
            % If metabolite doesn't have appropriate concentration data
            % then skip to next metabolite
            disp('');
            warn=strcat('### Unable to find concentration for ',name,' ###');
            disp(warn);
            if exist(fullfile(input_loc,'could_not_find_data.txt'),'file') ==0
               leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'w');
            else
               leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'a');
            end;
            fprintf(leftout,'%s\t%s\t%s\n',hmdb_id,'Unable to find concentration for ',name);
            fclose(leftout);
        end;
     end;  
end;  % Go to next metabocard

for i=1:length(Local_Names)
    if namecheck(i) == 0
        if exist(fullfile(input_loc,'could_not_find_data.txt'),'file') ==0
            leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'w');
        else
            leftout=fopen(fullfile(input_loc,'could_not_find_data.txt'),'a');
        end;
        fprintf(leftout,'%s\t%s\n',Local_Names{i},'No Matching HMDB Name');
        disp('');
        warn=strcat('### No Matching HMDB name for ',Local_Names{i},' ###');
        disp(warn);
        fclose(leftout);
    end;
end;
disp('');
disp('****************************');
disp('* Database Update Complete *');
disp('****************************');
else
disp('');
disp('*************************');
disp('* No New Spectra to Add *');
disp('*************************');
end;
end;
fclose('all');
close all force;
