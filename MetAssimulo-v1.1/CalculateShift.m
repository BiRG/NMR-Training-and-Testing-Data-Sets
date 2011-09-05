function [yout] = CalculateShift(x,y,pH,pKa,allinfo,peaklistinfo)
% PeakShiftFinalStep: Calculating the peak shift.
%--------------------------------------------------------------------------
%
% Input
% x             = The x-axis (ppm)
% y             = The y-axis (intensity)
% threshold1    = 
% pH            =
% pKa           =
% allinfo       =
% peaklistinfo  =
%
% Output
% yout          =
%
% Reference spectrum / to build up the reference spectrum/ need to look at each individual peak
% and need to shift the molecules /must cut an area surrounding the peak/ calc thickness of peaks
% set a threshold for standard cut off/ max peak /100/ take one peak at a time.... loop through removing one peak at a time....
% the mid point of the peak is the position.
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

leny = length(y);
yout = zeros(1,leny);

newlen = length(find(allinfo(1,1,:)));

% For each peak ...
for j = 1:newlen
    midp = allinfo(1,1,j);
    acidp = allinfo(1,2,j);
    basep = allinfo(1,3,j);
    peak = peaklistinfo(j,:);
    tp = midp;     
    aa = acidp;
    bb = basep;  
    
    %----------Calculate the shift----------------------------------------% 
    shift=(bb-tp+(aa-tp)*exp(pH-pKa))/(1+exp(pH-pKa));
 
    ffind1 = find(peak);
    %%%%%%% BEGIN EDIT TMDE - cope with interpolation when only one data
    % point in peak - give peak, plus one data point either way
    if (min(ffind1)>1) 
        ffind1=[ffind1(1)-1 ffind1]; 
    end;
    if (max(ffind1)<leny) 
        ffind1=[ffind1 ffind1(end)+1]; 
    end
    %%%%%%% END EDIT TMDE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    testffind1 = x(ffind1) + shift;      %Round shift to closest shift point
    eg = interp1(testffind1,y(ffind1),x);          
    eg(isnan(eg))=0;
    yout = yout + eg;

end
yout = yout';


  
