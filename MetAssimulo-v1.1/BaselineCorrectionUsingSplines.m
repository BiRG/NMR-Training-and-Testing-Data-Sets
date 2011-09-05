function [yo] = BaselineCorrectionUsingSplines(y,bins)
% BaselineCorrectionUsingSplines: Corrects the baseline.
%--------------------------------------------------------------------------
%
% 1. Bins the spectrum (according to the number of bins specified by user).
% 2. Finds the median of the bin and records the mid point of the bin.
% 3. Then uses the function spline() to extrapolate the baseline over the number of points
%    in the total spectrum (eg 10000 points specified by the user).
% 4. Subtracts point-by-point the baseline from the input spectrum.
% 5. Resulting in the output (yo), which has the baseline corrected.
%
%
% Input:    
%           y      NMR spectrum intensities.
%           bins   Number of bins required.
%
% Output: 
%           yo    Spectrum after baseline correction. 
%
% e.g.
%   y1 = BaselineCorrectionUsingSplines(y0,32);     
%
%--------------------------------------------------------------------------
%            Rebecca Anne Jones - Imperial College London (2008)
%--------------------------------------------------------------------------

ylength = length(y);
x = 1:ylength;
binsize = floor(ylength/bins);      % Work out the size of the bins. 
                                    
                                    % Initialise the values.
bin0 = 1; 
bin1 = binsize;
binmedian = 0;
xbase1 = 0;

while bin1<=ylength                 % For each bin find the median intensity
    currentbin = y(bin0:bin1);
    binmedian = [binmedian; median(currentbin)];
    xbase1 = [xbase1; (bin0+bin1)/2];
    bin0 = bin0 + binsize;
    bin1 = bin1 + binsize;
end

ynew = spline(xbase1',binmedian',x);   % Use the median of each bin to generate a spline.
yo = y - ynew;                      % Subtract the spline from the input (y) intensities to get the output (yo).
