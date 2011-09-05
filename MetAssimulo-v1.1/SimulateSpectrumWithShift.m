function [ycontrol,ycase,allinfo,pKalist,molecules_name] = ...
    SimulateSpectrumWithShift(x,nrepl_control,nrepl_case,sim_concs_control,...
    sim_concs_case,database,SNR,protons,threshold2,bandwidth2,pH1,pH2,...
    threshold1,molecules_name,mmetabolite,mtype,mfull,pKanames,pKa,pKamean,...
    sd,howbroad,max_shift,name1,name2,metabolites,full,abmets,...
    abfull,howclose)
% SimulateEndSpectrum: calls other functions to simulate the final spectra.
%--------------------------------------------------------------------------
% Calls functions to calculate the standard deviation of the noise to add
% onto the final spectrum. It also initiates the function Final Spectrum
% for both input mixtures, which create the mixture spectra.
%
% [ycontrol,ycase] = SimulateEndSpectrum(x,conc_control,nrepl_control,...
%    nrepl_case,sim_concs_control,sim_concs_case,database,LB2,SNR,protons,spectrometer)
%
% Inputs:
%   x                   The chemical shifts (x-axis) in ppm.
%   conc_control        The mean and standard deviation of the metabolites in mixture 1.
%   nrepl_control       Number of replicates of mixture 1.
%   nrepl_case          Number of replicates of mixture 2.
%   sim_concs_control   Simulated concentrations of each metabolite in
%                       mixture 1 for a number of replicates.
%   sim_concs_case      Simulated concentrations of each metabolite in
%                       mixture 2 for a number of replicates.
%   database            Contains the preprocessed spectra for all the metabolites.
%   LB2                 Line broadening used in smoothing the random noise (Hz).
%   SNR                 Signal to noise ratio.
%   protons             The number of protons for each metabolite.
%   spectrometer        Frequency of the spectrometer (MHz).
%
% Outputs:
%   ycontrol            Replicated end spectra of mixture 1.
%   ycase               Replicated end spectra of mixture 2.
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------

[dummy,n] = size(database);
pKalist = zeros(1,n);
allinfo = zeros(n,3,1);
% maxNpeaks = 500;
% maxSpace = 1e6;
% szpli = [n N maxNpeaks];
% peaklistinfo = zeros(n,N,1);
% peaklistinfo = ndsparse(szpli,maxSpace); % Allocate 3-way sparse array
peaklistinfo = cell(n,1);

fid1 = fopen(strtrim(name1),'wt');
fid2 = fopen(strtrim(name2),'wt');
movecheck=zeros(1,n);

for i = 1:n       % For each metabolite
    [pKa_value,acid_list,base_list,midpoint_list,peak_list,ibegend,check] = ...
        PeakDetection(x,database(:,i),threshold1,molecules_name{i},...
        mmetabolite,mtype,mfull,pKanames,pKa,pKamean,sd,howbroad,max_shift,...
        metabolites,full,abmets,abfull,howclose);
    pKalist(1,i) = pKa_value;
    
    if check ==1
        movecheck(i)=1;
        fprintf(fid1,'%s\t',molecules_name{i});
        fprintf(fid1,'%s\n','Unable to Shift');
        fprintf(fid2,'%s\t',molecules_name{i});
        fprintf(fid2,'%s\n','Unable to Shift');
    else
        
        fprintf(fid1,'%s\t',molecules_name{i});
        fprintf(fid1,'%g\n',pKalist(1,i));
        
        lenabm = length(midpoint_list);
        for j = 1:lenabm
            allinfo(i,1,j) = midpoint_list(j);
            allinfo(i,2,j) = acid_list(j);
            allinfo(i,3,j) = base_list(j);
            %         peaklistinfo(i,:,j) = peak_list(j,:);
            %             peaklistinfo = ndsparse(peaklistinfo,szpli,...
            %                 {i 1:length(peak_list) j},peak_list(j,:)); % save peak_list in sparse array
            peaklistinfo{i} = {peak_list ibegend};
            fprintf(fid2,'%s\t',molecules_name{i});
            fprintf(fid2,'%g\t%g\t%g\n',allinfo(i,:,j));
        end
    end;
end

fclose(fid1);
fclose(fid2);


ycontrol = zeros(length(x), nrepl_control);

for j= 1:nrepl_control
    [ycontrol(:,j)] = FinalSpectrumShift(x, sim_concs_control(:,j),...
        database, protons,threshold2,bandwidth2,SNR,pH1(j,1),pKalist,...
        allinfo,peaklistinfo,movecheck);
end

ycase = zeros(length(x), nrepl_case);
for j=1:nrepl_case
    [ycase(:,j)] = FinalSpectrumShift(x, sim_concs_case(:,j),...
        database, protons,threshold2,bandwidth2,SNR,pH2(j,1),pKalist,...
        allinfo,peaklistinfo,movecheck);
end
