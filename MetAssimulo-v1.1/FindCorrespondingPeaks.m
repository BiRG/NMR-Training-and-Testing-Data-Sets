function [midpoints,capturepeaks,peakindeces] = FindCorrespondingPeaks(i,...
    ua00,multcen0,umultcen0,peakpos0,N,x,finalmid,howclose,peak_list)
% FindCorrespondingPeaks:
%--------------------------------------------------------------------------
% For one multiplet, finds the peaks corresponding to it.

multpeaks = [];
for j = 1:ua00                                  % For each peak in the multiplet...
    if multcen0(j) == umultcen0(i)
        multpeaks = [multpeaks; peakpos0(j)];
    end
end
[sa1,sb1] = size(multpeaks);

midpoints = zeros(sa1,1);
capturepeaks = zeros(sa1,N);
peakindeces = zeros(sa1,1);

for j = 1:sa1   %p = no of peaks in that multiplet
    [valtest1, indtest1] = min(abs(x(finalmid)-multpeaks(j)));   %Finding the nearest peak
    if valtest1 <=howclose     % Allows you to adjust how close you want the peaks to correspond to
        midpoints(j,1) = finalmid(indtest1);
        capturepeaks(j,:) = peak_list(indtest1,:);
        peakindeces(j,1) = indtest1;
    end
end

% find nearest midpoint (within a good range)
% if exists then put midpoint into array 1xp
% and peak into 10000xp array