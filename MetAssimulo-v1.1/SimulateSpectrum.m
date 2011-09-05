function [x,ymixture1,ymixture2,wherex,wheremix1,wheremix2,outputdir,both,...
    display_output] = SimulateSpectrum(outputdir)
% SimulateSpectrum: simulates NMR spectra under parameters specified by the user.
% -------------------------------------------------------------------------
% SimulateSpectrum carries out the following processes:
%
%   Setting Parameters
%   ------------------
%   * Gets parameters from the GUI.
%   * Reads in the concentrations of metabolites.
%   * Simulates concentrations for a number of replicates.
%
%   Data Pre-Processing
%   -------------------
%   * For each metabolite reads in the spectrum.
%   * Interpolates the spectrum onto an axis specified by the user.
%   * Removes the water and standard peaks.
%   * Carries out baseline correction.
%   * Removes negative artifacts.
%   * Decreases noise via a low pass filter.
%   * Normalisation of the spectrum.
%   * Puts the metabolite spectrum into an array.
%
%   Output: 
%           x               The ppm values 
%           ymixture1       The intensity values for the mixture 1 simulated spectra.
%           ymixture2       The intensity values for the mixture 2 simulated spectra.
%           wherex          The location of output file to contain all the ppm values.
%           wheremix1       The location of output file to contain all the mixture 1 intensity values.
%           wheremix2       The location of output file to contain all the mixture 2 intensity values.
%
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%                   Revised August 2010 Tim Ebbels
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Specify the parameters.                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read parameters via GUI or parameter file. Any changes must be edited
% into both GUIInputParameters.m AND ReadParamFile.m

if (nargin<1) 
    nogui=0; 
else nogui=1; 
end;
if nogui
    [SNR,nrepl_mixture1,nrepl_mixture2,file_mixture1,file_mixture2,xaxis0,xaxis1,...
        datapoints,databaseloc,bins,standard,water0,water1,...
        experiment_fileloc,protons_fileloc,binsbc,local_names,synonyms,bandwidth1, bandwidth2,...
        threshold1, threshold2,ratios,peak_shift_on,thresh3,howbroad,sd,howclose,...
        max_shift,update,pHsame1,pHsame2,pHval1,pHval2,sdev1,sdev2,pka_file,...
        just_multiplets,multiplets,ab,ConpKa,ConMult,ConPeaks,ConABLims,wherex,wheremix1,wheremix2,...
        outname,Concs1Out,Concs2Out,ConpKaOut,ConMultOut,ConPeaksOut,ConABLimsOut,pKaOut,ABLimsOut,PH1Out,PH2Out,pKamean,...
        correlate,both,samesim,display_output] = ReadParamFile;
else
    [SNR,nrepl_mixture1,nrepl_mixture2,file_mixture1,file_mixture2,xaxis0,xaxis1,...
        datapoints,databaseloc,bins,standard,water0,water1,...
        experiment_fileloc,protons_fileloc,binsbc,local_names,synonyms,bandwidth1, bandwidth2,...
        threshold1, threshold2,ratios,peak_shift_on,thresh3,howbroad,sd,howclose,...
        max_shift,update,pHsame1,pHsame2,pHval1,pHval2,sdev1,sdev2,pka_file,...
        just_multiplets,multiplets,ab,ConpKa,ConMult,ConPeaks,ConABLims,wherex,wheremix1,wheremix2,...
        outname,Concs1Out,Concs2Out,ConpKaOut,ConMultOut,ConPeaksOut,ConABLimsOut,pKaOut,ABLimsOut,PH1Out,PH2Out,pKamean,...
        correlate,both,samesim,display_output] = GUIInputParameters;
end
        %      [SNR]                        Signal to noise ratio.
        %      [nrepl_mixture1]             Number of replicates of mixture 1.
        %      [nrepl_mixture2]             Number of replicates of mixture 2.
        %      [file_mixture1]              File location of mixture 1 concentration information.
        %      [file_mixture2]              File location of mixture 2 concentration information.
        %      [xaxis0]                     Start of the x-axis (ppm).
        %      [xaxis1]                     End of the x-axis (ppm).
        %      [datapoints]                 Number of datapoints. 
        %      [databaseloc]                Location of the standard metabolites database.
        %      [bins]                       Number of bins in the negative artifacts function.
        %      [standard]                   Boundary of the standard peak exclusion region (ppm).
        %      [water0]                     Lower bound of the water peak exclusion region (ppm).
        %      [water1]                     Upper bound of the water peak exclusion region (ppm).
        %      [experiment_fileloc]         Location of the experiments file.
        %      [protons_fileloc]            Location of the protons file.
        %      [binsbc]                     Number of bins in the baseline
        %      [local_names]                Local metabolite names 
        %      [synonyms]                   Synonym Converter 
        %      [bandwidth1]                 Bandwidth for the individual metabolite kernel smoothing.
        %      [bandwidth2]                 Bandwidth for the kernel smoothing the noise to be added to the overall mixture spectra.
        %      [threshold1]                 Threshold for the individual metabolite kernel smoothing
    	%      [threshold2]                 Threshold for the kernel smoothing the noise to be added to the overall mixture spectra.
        %      [ratios]                     If the mixture2 concentrations are ratios then this is set to 1, if they are absolute values then this is set to 0.
        %      [thresh3]                    Threshold of the individual peak detection.
        %      [howbroad]                   Broadness for peak detection.
        %      [pKamean]                    pKa mean value.                
        %      [sd]                         pKa st dev.
        %      [howclose]                   Distance between peaks for Matching.
        %      [max_shift]                  Maximum peak shift in ppm.
        %      [peak_shift_on]              Perform simulation with peak shift.
        %      [update]                     Update peak shift data to local database names.
        %      [pHsame1]                    Same pH for all metabolites in Control.
        %      [pHsame2]                    Same pH for all metabolites in Case.
        %      [pHval1]                     pH value for Control.
        %      [pHval2]                     pH value for Case.
        %      [sdev1]                      Control pH standard dev.
        %      [sdev2]                      Case pH standard dev.
        %      [pka_file]                   Location of pKa file.
        %      [just_multiplets]            Location of just_multiplets.txt.
        %      [multiplets]                 Location of multiplets.txt.
        %      [ab]                         Location of Converted  acid base list.
        %      [ConpKa]                      Location of Converted pKa_list.txt.
        %      [ConMult]                      Location of Converted Multiplet data.
        %      [ConPeaks]                      Location of Converted Multiplet data.
        %      [ConABLims]                      Location of Converted acid base list.
        %      [wherex]                     Location of x values.
        %      [wheremix1]                  Location of final Control spectra values.
        %      [wheremix2]                  Location of final Case spectra values.
        %      [outname]                    Location of list of Metabolites not included.
        %      [Concs1Out]                      Location of Control Concentrations.
        %      [Concs2Out]                      Location of Case Concentrations.
        %      [ConpKaOut]                     Location of Converted pKa_list.txt.
        %      [ConMultOut]                     Location of Converted Multiplet data.
        %      [ConPeaksOut]                     Location of Converted Multiplet data.
        %      [ConABLimsOut]                     Location of Converted  acid base list.
        %      [pKaOut]                      Location of Output : Converted pka list.
        %      [ABLimsOut]                      Location of Output : Converted acid base list.
        %      [PH1Out]                     Location of Output : Control pH.
        %      [PH2Out]                     Location of Output : Case pH.
        %      [threshold1]                 Threshold in the baseline correction.
        %      [threshold2]                 Threshold in the low pass filter.

if databaseloc ~= 0
    
%-------------------------------------------------------------------------%
%                    Check Input Files are available                      %
%-------------------------------------------------------------------------%

if exist(file_mixture1,'file') == 0
    warning(strcat('Unable to find mixture 1 concentrations file: ',file_mixture1));
elseif exist(file_mixture2,'file') == 0
    warning(strcat('Unable to find mixture 2 concentrations file: ',file_mixture2));
elseif exist(experiment_fileloc,'file') == 0
    warning(strcat('Unable to find experiments file: ',experiment_fileloc));
elseif exist(synonyms,'file') == 0
    warning(strcat('Unable to find synonyms file: ',synonyms));
elseif exist(local_names,'file') == 0
    warning(strcat('Unable to find local names file: ',local_names));
elseif peak_shift_on == 1 && both == 0
    if exist(pka_file,'file') == 0
        warning(strcat('Unable to find pKa data file: ',pka_file));
    elseif exist(just_multiplets,'file') == 0
        warning(strcat('Unable to find multiplet boundary data file: ',just_multiplets));
    elseif exist(multiplets,'file') == 0
        warning(strcat('Unable to find multiplet peak data file: ',multiplets));
    elseif exist(ab,'file') == 0
        warning(strcat('Unable to find acid/base limit data file: ',ab));
    elseif exist(ConpKa,'file') == 0
            warning(strcat('Unable to find pKa file: ',ConpKa));
        elseif exist(ConMult,'file') == 0
            warning(strcat('Unable to find multiplet file: ',ConMult));
        elseif exist(ConPeaks,'file') == 0
            warning(strcat('Unable to find multiplet file: ',ConPeaks));
        elseif exist(ConABLims,'file') == 0
            warning(strcat('Unable to find acid/base limits file: ',ConABLims));
    elseif update == 1
        if exist(ConpKaOut,'file') == 0
            warning(strcat('Unable to find pKa file: ',ConpKaOut));
        elseif exist(ConMultOut,'file') == 0
            warning(strcat('Unable to find multiplet file: ',ConMultOut));
        elseif exist(ConPeaksOut,'file') == 0
            warning(strcat('Unable to find multiplet file: ',ConPeaksOut));
        elseif exist(ConABLimsOut,'file') == 0
            warning(strcat('Unable to find acid/base limits file: ',ConABLimsOut));
        end; 
    end;
end;

%-------------------------------------------------------------------------%
%                       Update Output File Location                       %
%-------------------------------------------------------------------------%

   if exist('Output','file') ~= 7
     mkdir('Output');
   end;
   if (nargin<2)
       outputdir='Output';
       date=datestr(now,'dd-mmm-HH-MM');
       mkdir(outputdir,date);
       outputdir=fullfile(outputdir,date);
   else
       mkdir(outputdir);
   end
   
   if both ==1
   mkdir(outputdir,'WithShift');
   mkdir(outputdir,'WithoutShift');
   pKaOut= fullfile(outputdir,'WithShift',pKaOut);
   ABLimsOut= fullfile(outputdir,'WithShift',ABLimsOut);
   PH1Out= fullfile(outputdir,'WithShift',PH1Out);
   PH2Out= fullfile(outputdir,'WithShift',PH2Out);
   
   else
   wherex = fullfile(outputdir,wherex);
   wheremix1 = fullfile(outputdir,wheremix1);
   wheremix2= fullfile(outputdir,wheremix2);
   pKaOut= fullfile(outputdir,pKaOut);
   ABLimsOut= fullfile(outputdir,ABLimsOut);
   PH1Out= fullfile(outputdir,PH1Out);
   PH2Out= fullfile(outputdir,PH2Out);
   end;
   
   outname= fullfile(outputdir,outname);
   Concs1Out= fullfile(outputdir,Concs1Out);
   Concs2Out= fullfile(outputdir,Concs2Out);
   
if both == 1
    peak_shift_on =1;
end;
if samesim == 1
    nrepl_mixture2=nrepl_mixture1;
end;

%-------------------------------------------------------------------------%
%         Convert Peak Shift Files to NSSD names if required.             %
%-------------------------------------------------------------------------%
if peak_shift_on == 1   
    if update == 1
        SetUpPeakShiftInput(pka_file,local_names,synonyms,just_multiplets,...
            ConpKaOut,ConMultOut,multiplets,ConPeaksOut,ab,ConABLimsOut);
        [names_pKa, pKa, mmetabolites,mtype,mfull,metabolites,full,abmets,abfull] = ...
            PeakShiftInput(ConpKa,ConMult,ConPeaks,ConABLims); 
    end

    if update == 0
        [names_pKa, pKa, mmetabolites,mtype,mfull,metabolites,full,abmets,abfull] = ...
            PeakShiftInput(ConpKa,ConMult,ConPeaks,ConABLims); 
    end
end
        %       [names_pKa]             Names corresponding to the pKa values in the input file. 
        %       [pKa]                   The pKa values.
        %       [mmetabolites]          Names corresponding to the peak information.
        %       [mtype]                 The type of peak in the spectrum (eg. s - singlet)
        %       [mfull]                 The information about peak centre, start and end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Read in the concentration data.                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Reading in data...');
[conc_mixture10, conc_mixture20, molec_name] = ReadInConcentrations2(file_mixture1,file_mixture2);   
disp('...Completed.');
        
        %       [conc_mixture1]         The mean and standard deviation of the metabolites in mixture 1.
        %       [conc_mixture2]         The mean and standard deviation of
        %       the metabolites in mixture 2. (currently ratios)
        %       [molec_name]            The names of the metabolites in the mixtures.
        %       [molecules_no]          The total number of metabolites in the mixtures.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Synonym convertor.                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Converting Synonyms...')
[molecules_name,conc_mixture1,conc_mixture2,no_after_con] = MainConverter(molec_name, local_names, synonyms,conc_mixture10, conc_mixture20,outname);
disp('...Completed.');
        
        %       [molecules_name]
        %       [conc_mixture1]
        %       [conc_mixture2]
        %       [no_after_con]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            If needed, read in metabolite correlations.                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if correlate == 1
   disp('Reading correlations...')
   [nc,correlated_molecules,corr1,corr2]=GUICorrelation(molecules_name,outputdir,samesim);
   disp('...Completed.');
end;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Simulation of concentrations.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if min(size(conc_mixture1)) == 0 ||min(size(conc_mixture2)) == 0
    warning('No Readable Metabolites for Simulation');
     disp('');
     disp('*************************');
     disp('*  Program  Terminated  *');
     disp('*************************');
    x=0;
    ymixture1=0;
    ymixture2=0;
    wherex=0;
    wheremix1=0;
    wheremix2=0;
    outputdir=0;
    both=0;
else
disp('Simulating concentrations...');
if correlate == 0
    [sim_concs_mixture1,sim_concs_mixture2] = SimulationOfConcs(no_after_con,nrepl_mixture1,nrepl_mixture2,conc_mixture1,conc_mixture2,ratios); 
end;
if correlate ==1
    [sim_concs_mixture1,sim_concs_mixture2,corr1,corr2,cov1,cov2] = Correlated_Concs(nc,molecules_name,correlated_molecules,corr1,corr2,conc_mixture1,conc_mixture2,no_after_con,nrepl_mixture1,nrepl_mixture2,ratios,outputdir);
    
end;
%       [sim_conc_mixture1]          Simulated concentrations of each metabolite in mixture 1 for a number of replicates.  
%       [sim_concs_mixture2]         Simulated concentrations of each metabolite in mixture 2 for a number of replicates.  
if samesim ==1
    sim_concs_mixture2=sim_concs_mixture1;
end;

%-------------------------------------------------------------------------%
%                  Write Concentrations to File.                          %
%-------------------------------------------------------------------------%

mixt1 = fopen(strtrim(Concs1Out),'wt');
mixt2 = fopen(strtrim(Concs2Out), 'wt');
for i = 1:no_after_con
    fprintf(mixt1, '%s\t', molecules_name{i});
    fprintf(mixt1, '%g\t', sim_concs_mixture1(i,:));
    fprintf(mixt2, '%s\t', molecules_name{i});
    fprintf(mixt2, '%g\t', sim_concs_mixture2(i,:));
    fprintf(mixt1, '\n');
    fprintf(mixt2, '\n');
end
fclose(mixt1);
fclose(mixt2);
disp('...Completed.');

%-------------------------------------------------------------------------%
%      Read in the experiment and protons numbers for each metabolite.    %
%-------------------------------------------------------------------------%
experiment_used = ReadInExperiment(molecules_name, experiment_fileloc);
protons = ReadInProtons(molecules_name, protons_fileloc);                
%       [experiments_used]          The experiment numbers for each metabolite.
%       [protons]                   The number of protons for each metabolite.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Read in spectra & Pre-Process                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

database = zeros(datapoints,no_after_con);    
        %       [database] To contain the preprocessed spectra for all the metabolites.     
disp('Pre-processing metabolite spectra...');        
for i=1:no_after_con   % For each molecule...                         
    file = [databaseloc molecules_name{i}];
    spec = specread(file,experiment_used(i),1);   % ...read in the data.
    if strcmp(spec,'empty') == 1
        y4=zeros(datapoints,1);
        x = xaxis0:(xaxis1/(datapoints-1)):xaxis1;
    else
        xinput= spec(:,1);                         
        yinput = spec(:,2);
        x = xaxis0:((xaxis1-xaxis0)/(datapoints-1)):xaxis1; % Create the x-axis points.
        y = interp1(xinput,yinput,x);              % Interpolate the spectrum onto the user specified axis.
        y(isnan(y))=0;  % Set all NaN to 0 so the ifft works.                                                                                                                                                     
        y0 = RemoveWaterAndStandard(x,y,standard,water0,water1);% Remove water and standard peaks.     
        y1 = BaselineCorrectionUsingSplines(y0,binsbc);         % Baseline correction using splines.                
        y2 = RemoveArtifacts(y1,bins);                          % Remove negative artifacts.
        y3 = KernelSmootherFinal(x,y2,bandwidth1,threshold1);% Smoothing the noise.
%         y3 = KernelSmoothThresh(y2,bandwidth1,threshold1);% Smoothing the noise.
        y4 = y3./abs(sum(y3)); % Normalise the area under the spectrum.   
    end;
    database(:,i) = y4;     % Place in an array with the preprocessed spectra of all the other molecules.
    fprintf('%d ',i);
end
disp('...Completed.');    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Simulate the final spectra.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------%
%                              WITH SHIFT                                 %
%-------------------------------------------------------------------------%

if peak_shift_on == 1 
    disp('Simulating spectra with peak shift...');
    if both == 1
         wherex = strcat(outputdir,'/WithShift/',wherex);
         wheremix1 = strcat(outputdir,'/WithShift/',wheremix1);
         wheremix2= strcat(outputdir,'/WithShift/',wheremix2);
         displayout=strcat(outputdir,'/WithShift');
    else displayout =outputdir;
    end;
    %------------Set up pH values-----------------------------------------%
    
    if pHsame1 == 0                                % If a normal distribution...
        pH1 = (randn(nrepl_mixture1,1) * sdev1) + pHval1; % ..then pH1 is sampled with has mean pHval and standard deviation sdev1. 
    elseif pHsame1 == 1                            % Else the pH1 values are all the same.
        pH1 = zeros(nrepl_mixture1,1);
        pH1 = pH1 + pHval1;
    end
    if pHsame2 == 0
        pH2 = (randn(nrepl_mixture2,1) * sdev2) + pHval2;
    elseif pHsame2 == 1
        pH2 = zeros(nrepl_mixture2,1);
        pH2 = pH2 + pHval2;
    end
    %------------Write pH values to File----------------------------------%
    mixt1 = fopen(strtrim(PH1Out),'w');
    mixt2 = fopen(strtrim(PH2Out), 'w');
    fprintf(mixt1, '%g\n', pH1);
    fprintf(mixt2, '%g\n', pH2);
    fclose(mixt1);
    fclose(mixt2);
    
    %------------Simulate Spectrum----------------------------------------%
    
    [ymixtureshift1, ymixtureshift2,allinfo,pkalist,molecules_name] = ...
        SimulateSpectrumWithShift(x,nrepl_mixture1,nrepl_mixture2,...
    sim_concs_mixture1,sim_concs_mixture2,database,SNR,protons,threshold2,...
    bandwidth2,pH1, pH2,thresh3,molecules_name,mmetabolites,mtype,mfull,...
    names_pKa,pKa,pKamean,sd,howbroad,max_shift,pKaOut,ABLimsOut,...
    metabolites,full,abmets,abfull,howclose); 

    %-------------Save Output to File-------------------------------------%
    
    file1=fopen(wherex,'w');
    fclose(file1);
    file2=fopen(wheremix1,'w');
    fclose(file2);
    file3=fopen(wheremix2,'w');
    fclose(file3);
    save(wherex, 'x', '-ASCII');
    save(wheremix1, 'ymixtureshift1', '-ASCII');
    save(wheremix2, 'ymixtureshift2', '-ASCII');
    disp('...Completed.');
end;
%----------Create MATLAB Data Structure-----------------------------------%

if both == 1
    %--------Display Output-----------------------------------------------%
    if display_output
        DisplayResults(x,ymixtureshift1,ymixtureshift2,displayout,both);
    end
    mix1.shift.metabolites=molecules_name;
    mix1.shift.spectra=ymixtureshift1;
    mix1.shift.x=x;
    mix1.shift.info=struct('midpoint',allinfo(:,1,:),'acidlist',allinfo(:,2,:),'baselist',allinfo(:,3,:),'pkavalues',pkalist);
    mix2.shift.metabolites=molecules_name;
    mix2.shift.spectra=ymixtureshift2;
    mix2.shift.x=x;
    mix2.shift.info=struct('midpoint',allinfo(:,1,:),'acidlist',allinfo(:,2,:),'baselist',allinfo(:,3,:),'pkavalues',pkalist);
    peak_shift_on = 0;
elseif both == 0 && peak_shift_on == 1
    mix1.shift=struct('midpoint',allinfo(:,1,:),'acidlist',allinfo(:,2,:),'baselist',allinfo(:,3,:),'pkavalues',pkalist);
    mix2.shift=struct('midpoint',allinfo(:,1,:),'acidlist',allinfo(:,2,:),'baselist',allinfo(:,3,:),'pkavalues',pkalist);
    ymixture1=ymixtureshift1;   
    ymixture2=ymixtureshift2;
end;

%-------------------------------------------------------------------------%
%                           WITHOUT SHIFT                                 %
%-------------------------------------------------------------------------%

if peak_shift_on == 0 
    disp('Simulating spectra without peak shift...');
    if both == 1
         wherex = strcat(outputdir,'/WithoutShift/','ppm_Values_X.txt');
         wheremix1 = strcat(outputdir,'/WithoutShift/','Spectra_Mix1.txt');
         wheremix2 = strcat(outputdir,'/WithoutShift/','function CreateConcOutputFiles(name1, name2, no_after_con, molecules_name, sim_concs_mixture1, sim_concs_mixture2)Spectra_Mix2.txt');
         displayout=strcat(outputdir,'/WithoutShift');
         both=3;
    else displayout =outputdir;
    end;  
    
    %------------Simulate Spectrum----------------------------------------%
    
    ymixture1 = zeros(length(x), nrepl_mixture1); 
    for j= 1:nrepl_mixture1
        [ymixture1(:,j)] = FinalSpectrumNoShift(x,...
            sim_concs_mixture1(:,j), database, protons,threshold2,bandwidth2,SNR);
    end;
    ymixture2 = zeros(length(x), nrepl_mixture2);
    for j=1:nrepl_mixture2
        [ymixture2(:,j)] = FinalSpectrumNoShift(x,...
            sim_concs_mixture2(:,j), database, protons,threshold2,bandwidth2,SNR);
    end;
    if (both ==3 && display_output)
    %--------Display Output-----------------------------------------------%
        DisplayResults(x,ymixture1,ymixture2,displayout,both);
    end;
    
    %--------Save Output to File------------------------------------------%
    
    file4=fopen(wherex,'w');
    fclose(file4);
    file5=fopen(wheremix1,'w');
    fclose(file5);
    file6=fopen(wheremix2,'w');
    fclose(file6);
    save(wherex, 'x', '-ASCII');
    save(wheremix1, 'ymixture1', '-ASCII');
    save(wheremix2, 'ymixture2', '-ASCII');
    disp('...Completed.');
end;

%------Create MATLAB Data Structure---------------------------------------%

    mix1.metabolites=molecules_name;
    mix1.spectra=ymixture1;
    mix1.x=x;
    mix2.metabolites=molecules_name;
    mix2.spectra=ymixture2;
    mix2.x=x;   
if correlate ==1
    mix1.corr=corr1;
    mix1.cov=cov1;
    mix2.corr=corr2;
    mix2.cov=cov2;
end;
simulation= struct('mix1', mix1, 'mix2', mix2); 
sim=fullfile(outputdir,'Simulated_Data.mat');
save(sim, 'simulation');
end;
else
    x=0;
    ymixture1=0;
    ymixture2=0;
    wherex=0;
    wheremix1=0;
    wheremix2=0;
    outputdir=0;
    both=0;
end;
