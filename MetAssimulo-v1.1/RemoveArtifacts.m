function [yo] = RemoveArtifacts(y,bins)
% RemoveArtifacts : removes artifacts from the spectrum that are below a limit value.
%--------------------------------------------------------------------------
% Steps used to find the limit value:
% 1) The standard deviation of each bin is calculated. 
% 2) The median value of the standard deviation is found.
% 3) The overall median of the y values is calculated. 
% 4) Use the following formula to calculate the limit value:
%       Limit value = median - (3 * median standard deviation)
%
% [yo] = RemoveArtifacts(y,bins)
% 
% Input:
%   y       The intensities (y-axis).
%   bins    Number of bins for finding the minimum standard deviation.
%
% Output:
%   yo      The y-axis after the removal of negative artifacts.
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

ylength = length(y);
binsize = floor(ylength/bins);      % Work out the size of the bins.  %[Round down and always miss the last section]
                                    % Initialise the values.
bin0 = 1; 
bin1 = binsize;
stddev = [];

while bin1<=ylength                 % For each bin find the standard deviation.
    currentbin = y(bin0:bin1);
    stddev = [stddev; std(currentbin)];
    bin0 = bin0 + binsize;
    bin1 = bin1 + binsize;
end

med = median(y);                    
minstddev= median(stddev);      

limit = (med - 3.*minstddev);       
ind2 = find(y<limit);               % Find all points which are less than the limit value [median - 3*minimum standard deviation].
yo = y;                             % Initialise the output.
yo(ind2) = med - 3.*minstddev;      % Set the artifacts to the limit value.
    
