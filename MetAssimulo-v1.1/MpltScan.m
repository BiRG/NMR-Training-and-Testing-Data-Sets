function [skip] = MpltScan(name, hmdb_id,pk_location,mult,output)
% Reads in multiplet data from the HMDB NMR Spectra Peak Lists
% 
filename=strcat(pk_location,'/',hmdb_id,'_NMR_peaklist.txt');
pklist=fopen(filename,'r');
table1=0;
table2=0;
tline=fgetl(pklist);
skip=0;
Centre=[];
Type=[];
Start=[];
Endp=[];
data=[];
peakinfo=[];
range=[];

m=0;
PPM=[];
Intensity=[];

% Find Table of Peaks and read in data
while strncmpi('Able of Peaks',tline,12) ~= 1 && strncmpi('Table of Peaks',tline,12) ~= 1 && strncmpi('No.	(ppm)	Height',tline,10) ~= 1  && strncmpi('No. 	(ppm) 	(Hz) 	Height',tline,10) ~= 1 && feof(pklist) ~=1
  tline=fgetl(pklist) ; 
end  

if strncmpi('Able of Peaks',tline,12) == 1 ||strncmpi('Table of Peaks',tline,12) == 1 || strncmpi('No.	(ppm)	Height',tline,10) == 1 || strncmpi('No. 	(ppm) 	(Hz) 	Height',tline,10) == 1
    table1=1;
end;

while strncmp('1',tline,1)~=1 && strncmp('2',tline,1)~=1 && feof(pklist)~=1
    tline=fgetl(pklist);
end;

%if Table of Peaks exists, read in data
if table1 ==1 
while strcmp('',tline) ~= 1 && feof(pklist)~=1
    data=[];
    m=m+1;
    [data]=regexp(tline, '\t', 'split');
    
    % Check there are no empty fields
    k=0;
    for i=1:length(data)
        if strcmp(data{i},'') ~= 1
            k=k+1;
            Data{k}=data{i};
        end;
    end;
    
    % Read in data according to table format
    if length(Data) == 4
        PPM{m}=Data{2};
        Intensity{m}=Data{4};
    elseif length(Data) == 3
            PPM{m}=Data{2};
            Intensity{m}=Data{3}; 
    else
            skip = 1;
    end;
    tline=fgetl(pklist);
end;
end;
if skip ~=1
% Find Multiplets table and read data
while strncmpi('Table of Mutiplets',tline,19) ~= 1 && strncmpi('Table of Mutliplets',tline,19) ~= 1 && strncmpi('Table of Multiplets',tline,19) ~= 1 && strncmpi('No.	Shift1 (ppm)	H`s	Type	Atom1		Multiplet1	 (ppm)',tline,19) ~= 1 && strncmpi('No. 	Shift1 (ppm) 	H`s 	Type 	J (Hz) 	Atom1 	Multiplet1 	 (ppm)',tline,19) ~= 1 && feof(pklist) ~=1
  tline=fgetl(pklist); 
end  

% Check if Table of Multiplets was BEFORE Table of Peaks, go back to start of file
if feof(pklist) ==1
    fclose(pklist);
    pklist=fopen(filename,'r');
    tline=fgetl(pklist);
    while strncmpi('Table of Mutiplets',tline,19) ~= 1 && strncmpi('Table of Mutliplets',tline,19) ~= 1 && strncmpi('Table of Multiplets',tline,19) ~= 1 && strncmpi('No.	Shift1 (ppm)	H`s	Type	Atom1		Multiplet1	 (ppm)',tline,19) ~= 1 && strncmpi('No. 	Shift1 (ppm) 	H`s 	Type 	J (Hz) 	Atom1 	Multiplet1 	 (ppm)',tline,19) ~= 1 && feof(pklist)~=1
        tline=fgetl(pklist); 
    end 
end;

if strncmpi('Table of Mutiplets',tline,19) == 1 || strncmpi('Table of Mutliplets',tline,19) == 1 || (strncmp('Table of Multiplets',tline,19) ~= 1 ||strncmp('No.	Shift1 (ppm)	H`s	Type	Atom1		Multiplet1	 (ppm)',tline,19) ~= 1 || strncmp('No. 	Shift1 (ppm) 	H`s 	Type 	J (Hz) 	Atom1 	Multiplet1 	 (ppm)',tline,19) ~= 1)
    table2=1;
end;

%If Table of Multiplets exists...
if table2==1
    
while strncmp('1',tline,1)~=1 && strncmp('2',tline,1)~=1 && feof(pklist)~=1
    tline=fgetl(pklist);
end;

Type=[];
n=0;
Centre=[];
Start=[];
Endp=[];
intable=0;
skip=0;
  
while intable ~=1 && feof(pklist) ~=1
    intable=strcmp('',tline);
    peakinfo=[];
    range=[];
    n=n+1;
    [peakinfo]=regexp(tline, '\t', 'split');
    k=0;
    
    for i=1:length(peakinfo)
        if strcmp(peakinfo{i},'') ~= 1
            k=k+1;
            Peakinfo{k}=peakinfo{i};
        end;
    end;
    nomatch=0; 
    %Check format of table entries
    
    if length(Peakinfo) == 6
        Peakinfo{4}=Peakinfo{3};
        Peakinfo{7}=Peakinfo{6};
        Peakinfo{2}='';
    end;      
    if length(Peakinfo)>3     
    matchtype=regexp(Peakinfo{4},'[a-z][a-z][a-z]','match');
    if ~isempty(matchtype)
        Type{n}=matchtype{1};
    else
        matchtype=regexp(Peakinfo{4},'[a-z][a-z]','match');
        if ~isempty(matchtype)
            Type{n}=matchtype{1};
        else
            matchtype=regexp(Peakinfo{4},'[a-z]','match');
            if ~isempty(matchtype)
                Type{n}=matchtype{1};
            else
                skip = 1;
            end;
        end;
    end;
    else skip=1;
    end;
     
    % If table format is appropriate...
    if skip==0   
        
    % Read data according to format   
    if length(Peakinfo) ==8
        space=strfind(Peakinfo{8},' ');
        if ~isempty(space) && space(1)==1
            [range]=sscanf(Peakinfo{8},' [%g . . %g]');
        else        
            [range]=sscanf(Peakinfo{8},'[%g . . %g]');
        end;
        Start=[Start,range(1)];
        Endp=[Endp,range(2)];
        Centre=cat(1,Centre,str2num(Peakinfo{2}));
    else
        if length(Peakinfo) ==7
         space=strfind(Peakinfo{7},' ');
        if ~isempty(space) && space(1)==1
            [range]=sscanf(Peakinfo{7},' [%g . . %g]');
        else        
            [range]=sscanf(Peakinfo{7},'[%g . . %g]');
        end;  
        
        Start=[Start,range(1)];
        Endp=[Endp,range(2)];
        
        if strcmp(Peakinfo{2},'') == 1
           Centre=cat(1,Centre,(range(1)+range(2))/2 );
        else
           Centre=cat(1,Centre,str2num(Peakinfo{2})); 
        end;
        
        else
            skip =1;
        end;
    end;
    else
        intable=1;
    end;
    tline=fgetl(pklist);
end;   
end;

if (table1 == 0) || (table2 == 0)
    skip =1;
end;
end;
if skip == 0 
for i=1:n
    fprintf(mult,'%s\t%s\t%g\t%g\t%g\n',name,Type{i},Centre(i),Start(i),Endp(i));
    for j=1:m
        if str2double(PPM{j})>=Start(i) && str2double(PPM{j})<=Endp(i)
            fprintf(output,'%s\t %s\t %s\t %s\t %g\t %g\t %g\n',name,PPM{j},Intensity{j},Type{i},Centre(i),Start(i),Endp(i));
        end;
    end;
end;
end;

fclose(pklist);
end

