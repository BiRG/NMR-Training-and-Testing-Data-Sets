function [y] = FinalSpectrumNoShift(x, conc, database, protons,threshold2,bandwidth2,SNR)
% FinalSpectum: puts together the metabolites spectra (with no shift) and adds noise.
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
%   protons         The number of protons for each metabolite.
%   threshold2      The threshold used in kernel smoothing the noise.
%   bandwidth2      The bandwidth used when kernel smoothing the noise.
%   type2           The type of kernel used in when kernel smoothing the noise.
%   SNR             The signal to noise ratio.
%
% Output: 
%   y               The final mixture spectrum.
%
%--------------------------------------------------------------------------
%        ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

[N,n] = size(database);
y = zeros(N,1);

for i=1:n                                       % Adding the spectra together
    y = y +conc(i).*database(:,i).*protons(:,i);  % Multiplying by the simulated concentration and the number of protons.
end

noise_std = max(y)/SNR;

if noise_std > 0
    e= randn(N,1)*noise_std;                        % Generating random noise.
%     esmooth = KernelSmootherFinal(x,e,bandwidth2,threshold2,type2);
    esmooth = KernelSmoothThresh(e,bandwidth2,inf);
    y=y+esmooth;
     % Adding smoothed noise to the spectrum.
end                                          
