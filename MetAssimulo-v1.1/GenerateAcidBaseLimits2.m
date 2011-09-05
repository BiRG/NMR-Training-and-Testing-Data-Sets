function [acid_list,base_list] = GenerateAcidBaseLimits2(x,finalmid,max_shift,...
    abnotpresent,pKa)
% GenerateAcidBaseLimits2 - generate acid/base limits using Normal
% distribution, capped at max_shift
% [acid_list,base_list] = GenerateAcidBaseLimits2(x,finalmid,max_shift,actualpeak)
%
% (acid / base limit) is sampled from N(0,max_shift/3), truncated
% at +/- max_shift. Then calculate acid limit from HH equation, knowing pKa & 
% assuming template spectrum measured at pH 7.4.
%
% Written 060810 TMDE  
% (c) Copyright 2010 Dr. T.M.D. Ebbels, Imperial College, London

pH = 7.4; % Assume template spectra measured at pH 7.4
npeaks = length(abnotpresent);
acid_list = zeros(npeaks,1);
base_list = zeros(npeaks,1);
sig = max_shift/3;
for i=1:npeaks
    ab = max_shift+1;
    while (abs(ab)>max_shift), 
        ab = randn*sig; 
    end
    acid_list(i) = x(finalmid(i)) - ab/(1+exp(pH-pKa)); % HH equation
    base_list(i) = acid_list(i)+ab;
end