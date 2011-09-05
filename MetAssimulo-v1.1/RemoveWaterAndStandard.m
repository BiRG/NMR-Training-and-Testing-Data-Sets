function yo = RemoveWaterAndStandard(x,y, d0, w0,w1)
% RemoveWaterAndStandard: Removes the exclusion regions.
%--------------------------------------------------------------------------
% 
% 1. This function produces an output of the y axis with the regions of the water 
%    peaks and standard peaks set to zero.
% 2. The boundaries of the regions are defined by the user when using the GUI.
%
% Input:
%   x       The chemical shifts (x-axis) in ppm.                  
%   y       The intensities (y-axis).
%   d0      Boundary of the standard peak exclusion region (ppm).
%   w0      Lower bound of the water peak exclusion region (ppm).
%   w1      Upper bound of the water peak exclusion region (ppm).
%
% Output:
%   yo      The y-axis with the exclusion regions removed.
%
%
% e.g.
%   yo = RemoveWaterAndStandard(x,y, d0, w0,w1)
%
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

yo=y;
  
% Excluding the water region.
ind1 = find(x > w0 & x < w1); 

% Removing the water signal.
yo(ind1) = 0;

% Excluding the standard peak.
ind2 = find(x > - d0 & x < d0); 
yo(ind2) = 0;