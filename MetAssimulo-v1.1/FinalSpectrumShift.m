function [y] = FinalSpectrumShift(x, conc, database, protons,...
    threshold2,bandwidth2,SNR,pH,pKa,allinfo,peaklistinfo,...
    movecheck)

% FinalSpectum: puts together the metabolites spectra and adds noise.
%--------------------------------------------------------------------------
% Produces the final specta by multiplying the spectrum of each metabolite
% by its concentration and proton number. Then sums together the spectra of
% the metabolites to simulate a complex mixture.
% 
%   y = FinalSpectrum(x, conc, database, noise_std, LB2,protons,spectrometer)
%
% Inputs:
%   x               The chemical shifts (x-axis) in ppm. 
%   conc            The mean and standard deviation concentration.
%   database        Contains the preprocessed spectra for all the metabolites.
%   noise_std       The standard deviation of the noise.
%   LB2             Line broadening used in smoothing the random noise (Hz).
%   protons         The number of protons for each metabolite.
%   spectrometer    Frequency of the spectrometer (MHz).
%
% Output: 
%   y               The final mixture spectrum.
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------

[N,n] = size(database);
y = zeros(N,1);

for i=1:n                                       % Adding the spectra together
    if movecheck(i) == 0
        thispeakinfo = peaklistinfo{i};
        npeaks = size(thispeakinfo{1},2);
        thismetinfo = zeros(npeaks,N);
        for j=1:npeaks,
            thismetinfo(j,thispeakinfo{2}(j,1):thispeakinfo{2}(j,2)) = thispeakinfo{1}{j};
        end
%         thismetinfo = ndsparse(peaklistinfo,szpli,{i 1:szpli(2) 1:szpli(3)});
%        metyfinal = PeakShiftFinalStep(x,database(:,i),pH,pKa(i),allinfo(i,:,:),peaklistinfo(i,:,:),do_not_shift);
        metyfinal = CalculateShift(x,database(:,i),pH,pKa(i),allinfo(i,:,:),thismetinfo);
        y = y +conc(i).*metyfinal.*protons(:,i);  % Multiplying by the simulated concentration and the number of protons.
    else
        y = y +conc(i).*database(:,i).*protons(:,i);
    end;
end

noise_std = max(y)/SNR;
if noise_std > 0
    e= randn(N,1)*noise_std;                        % Generating random noise.
    %     esmooth = KernelSmootherFinal(x,e,bandwidth2,threshold2,type2);
    esmooth = KernelSmoothThresh(e,bandwidth2,inf);
    y=y+esmooth;                                    % Adding smoothed noise to the spectrum.
end                                          % NOTE: When noise_std is 0 no noise is added.
