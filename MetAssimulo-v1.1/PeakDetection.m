function [pKa_value,acid_list,base_list,midpoint_list,peak_list,ibegend,check] = ...
    PeakDetection(x,y,threshold10,name,mmetabolite,mtype,mfull,pKanames,...
    pKa,pKamean,sd,howbroad,max_shift,metabolites,full,abmets,abfull,howclose)
% FindpKaAcidBasePeaks2: Finding the peaks and generating their acid and base limits.
%--------------------------------------------------------------------------
% Takes a metabolite NMR spectrum, detects all the peaks above a threshold.
% Cuts out the area surrounding the peak and captures the peak in an array. Finds the maximum position of the peak.
% Sets up the pKa values. Then calculates the acid and base limits using a
% normal distribution. Removes one peak at a time until all about the
% threshold is captured.
%
% Input
% x             = ppm
% y             = intensity
% threshold1    = Percentage of the maximum peak in the whole spectrum.
% name          = Name of the metabolite
% mmetabolite   = List of metabolite names corresponding to multiplet information.(when incorperating multiplet info)
% mtype         = The type of multiplet.(when incorporating multiplet info)
% mfull         = Centre, start and end of multiplets. (when incorperating multiplet info)
% pKanames      = List of metabolite names corresponding to known pKa values.
% pKa           = List of known pKa values.
% pH            = The pH of the sample.
% sd            = The standard deviation used in generating the pKa.
% howbroad      = Specifies the width of where the peak is to be cut.
% max_shift     = The maximum shift.
%
% Output
% pKa_value     = The pKa value.
% acid_list     = List of acid limits corresponding the to the peak list.
% base_list     = List of base limits corresponding the to the peak list.
% midpoint_list = List of the peak midpoints corresponding the to the peak list.
% peak_list     = The peaks detected within the metabolite spectrum.
%
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

set = (max(y)./100).*threshold10;

%%% Get the pKa value (or generate it) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Incorporating known pKa
pKanames = lower(pKanames);
name = lower(name);
match3 = strmatch(name,pKanames, 'exact');
if match3
   pKa_value = pKa(match3(1));
end

% If there's no known pKa then the value is taken from a normal distribution.
if 0 == exist('pKa0')
   pKa_value = pKamean + (randn(1,1) * sd); % mean pH, standard deviation 0.5  (changed to 0.1 after meeting with Maria)
end

%---- Get the acid base info already existing ----------------------------%       
[a1,dummy1] = size(abmets);
[a2,dummy2] = size(abfull);
if a1 > 0 && a2 >0
    abmets = lower(abmets);
    abc = abfull(:,1);
    abst = abfull(:,2);
    abe = abfull(:,3);
    abmatch = strmatch(name, abmets, 'exact');  
    if abmatch
        abc0 = abc(abmatch);        
        abst0 = abst(abmatch); 
        abe0 = abe(abmatch);    
    else
        abc0 = [];
        abst0 = [];
        abe0 = [];
    end
else    
  abc0 = [];
    abst0 = [];
    abe0 = [];
end
% abc0 = midpoint of the peak   abst0 = acid limit  abe0 = base limit

%----------Perform Peak Detection-----------------------------------------%

[finalmid, peak_listt, ibegend, check] = IndivPeakDetection(x,y,set,howbroad,name);
%Finding the all the maximum peaks above a threshold.

if check==0
    % User info on peaks that shift together..
    metabolites = lower(metabolites);
    peakpos = full(:,1);                                        % The peak position
    multcen = full(:,2);                                        % The multiplet that the peak is within
    pmatch = strmatch(name, metabolites, 'exact');              % Finding the peak info for that specific metabolite
    if pmatch
        [multpeak, midpoints,justindeces] = FindingPeaksToShiftTogether(x,...
            set,y,finalmid, peak_listt,howclose,peakpos,multcen,pmatch);
                                                   
    else
        multpeak = [];
        midpoints = [];
        justindeces = [];
    end
    movetogether = justindeces((find(justindeces(:,:,1)>0)),:,:);
    finallen = length(finalmid);
    acid_list = zeros(finallen,1);
    base_list = zeros(finallen,1);
    midpoint_list = x(finalmid)';
    
    % Convert peak_list to a cell array capturine only parts with non-zero
    % entries - this is to save memory later on
    for i=1:size(peak_listt,1)
        peak_list{i} = peak_listt(i,ibegend(i,1):ibegend(i,2));
    end
    
    % FOR EACH IN FINALMIDT
    for k = 1:finallen
        % Firstly find if the acid base values already exist.
        if abc0
            noab = length(abc0);
            for j = 1:noab
                [val, ind] = min(abs(x(finalmid(k))-abc0(j)));   %Finding the nearest peak
                if val <=howclose     % Allows you to adjust how close you want the peaks to correspond to
                    if (abst0(j) > x(finalmid(k)) && abe0(j) < x(finalmid(k)))||(abst0(j) < x(finalmid(k)) && abe0(j) > x(finalmid(k)))
                        acid_list(k) = abst0(j);
                        base_list(k) = abe0(j);
                    end
                end
            end
        end
    end
    
    if movetogether
        [mox moy moz] = size(movetogether);
        for h = 1:mox
            [mox1 moy1 moz1] = size(movetogether(h,:,:));
            indtomove = movetogether(h,1,:);
            %%%
            noap  = length(indtomove); 
            acid_listshare = zeros(noap,1);
            base_listshare = zeros(noap,1);
            aa= randn*max_shift;         
            bb= randn*max_shift;   
            if (all([aa bb]>0) ) || (all([aa bb]<0) ) 
                if rand < 0.5
                    aa=-aa;
                else
                    bb=-bb;
                end;
            end;
            % For each peak ...
            for j = 1:noap
                i = indtomove(j);
                position = finalmid(i,1);
                true_position = x(position);                
                aa0 = true_position + aa;
                bb0 = true_position + bb; 
                acid_listshare(j,1) = aa0;
                base_listshare(j,1) = bb0;
            end;
            %%%
            acid_list(indtomove) = acid_listshare;
            base_list(indtomove) = base_listshare;
        end;
    end;
    
    % Then find where there are null entries, find the indeces of these and
    % generate acid base limits for those
    
    abnotpresent = find(acid_list == 0);
    if ~isempty(abnotpresent)
        %     [acid_list1,base_list1] = GenerateAcidBaseLimits(x,finalmidt,max_shift,abnotpresent);
        [acid_list1,base_list1] = GenerateAcidBaseLimits2(x,finalmid,max_shift,abnotpresent,pKa_value);
        
        acid_list(abnotpresent) = acid_list1;
        base_list(abnotpresent) = base_list1;
    end
    
    
else
    acid_list=[];
    base_list=[];
    midpoint_list=[];
    peak_list={};
    ibegend=[];
end;
