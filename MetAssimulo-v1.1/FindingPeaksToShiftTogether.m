function [peaklistinfo, allinfo, justindeces] = FindingPeaksToShiftTogether(...
    x,set,y,finalmid, peak_list,howclose,peakpos,multcen,pmatch)
% FindingPeaksToShiftTogether:
%--------------------------------------------------------------------------
% [peakpos0,multcen0,ua00,umultcen0,ua0,N,allinfo,peaklistinfo,justindeces] =...
%     SetUpFindingPeaksToShift(peakpos,multcen,pmatch,x);
% SetUpFindingPeaksToShift: Sets up the array for peak shift.
%--------------------------------------------------------------------------
peakpos0 = peakpos(pmatch);
multcen0 = multcen(pmatch);
        
[ua00,ub00] = size(multcen0);                       % ua00 = Number of peaks
umultcen0 = unique(multcen0);      
                
[ua0,ub0] = size(umultcen0);                        % ua0 = Number of multiplets
        
[no, N] =size(x);                                   % N = Number of datapoints
 
% Setting up arrays
allinfo = zeros(ua0,1,1);                          % Will contain the peak 
peaklistinfo = zeros(ua0,N,1);
justindeces = zeros(ua0,1,1);
% ua00 = Number of peaks
% ua0 = Number of multiplets
% N = Number of datapoints    

for i = 1:ua0                                        % For each multiplet...  
    [midpoints,capturepeaks,peakindeces] = FindCorrespondingPeaks(i,ua00,...
        multcen0,umultcen0,peakpos0,N,x,finalmid,howclose,peak_list);
    % Some will correspond to the same peak, so only move this peak once.
    
    %     [allinfo,peaklistinfo,justindeces] = OnlyUniquePeaksInMultiplet(i,...
    %         midpoints,capturepeaks,allinfo,peaklistinfo,justindeces,peakindeces);
    % Gather information about the peaks to move within a multiplet
    test4 = unique(midpoints);
    [fts1,fts2] = size(test4);
    if (fts1 == 1) % Then there is only 1 peak - therefore no shared moving
    else
        for h = 1:fts1
            samevals = find(test4(h) == midpoints);
            allinfo(i,1,h) = midpoints(samevals(1),1);
            peaklistinfo(i,:,h) =capturepeaks(samevals(1),:);
            justindeces(i,1,h) = peakindeces(samevals(1),1);
        end
    end
end

finalmat = find(allinfo(:,:,1));
fm1 = length(finalmat);
       
allinfo0 = zeros(fm1,1,1);
peaklistinfo0 = zeros(fm1,N,1);
       
