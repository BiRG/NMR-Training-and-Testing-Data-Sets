%          ***** MetAssimulo: NMR Metabolic Profile Simulator *****
% -------------------------------------------------------------------------
% MetAssimulo is a nucelar magnetic resonance (NMR) metabolic profile
% simulator. 
% 
% MetAssimulo works on the basis of linear combination of spectra from 
% individual metabolites to form an overall mixture spectrum i.e.
% a biofluid such as urine.
% 
% Input files needed for MetAssimulo to work:
% * Tab delimited concentration files for both groups of metabolites, 
%   containing metabolite names, mean and standard devation concentrations.   
% * Metabolite database comprising of 1D NMR spectra for standard
%   metabolites. 
% * File identifying the experiments to use for each metabolite.
% * File listing the number of protons in each metabolite.
% * Parameter file containing the default values of the parameters.
%
% MetAssimulo contains a variety of data pre-processing steps that are
% performed on the input spectra. These include interpolation, removal of
% exclusion regions, baseline correction, removal of artifacts, low pass
% filter and normalisation.
%           
% The output consists of the following three components:
% * The chemical shift in ppm. (x)
% * The intensities at each chemical shift for the first mixture. (ymixture1)
% * The intensities at each chemical shift for the second mixture. (ymixture2)
%   Where ymixture1(:,n) and ymixture2(:,n) are the spectra for replicate number
%   n in the first and second mixtures respectively.
% 
% These are written to three output files x.txt, ymixture1.txt, and ymixture2.txt.
%
% Via the MetAssimulo GUI the user is able to change a whole host of
% parameters, for a full list of these type: help GUIInputParameters.
%
%-------------------------------------------------------------------------- 
%                           ** Acknowledgements **
%--------------------------------------------------------------------------
%                                Dr Tim Ebbels
%                              Dr Maria De Iorio
%                             Dr Natalia Bochkina
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2007) **
%--------------------------------------------------------------------------

%==========================================================================
%--------------------------------------------------------------------------
%                               METAssimulo 5.0
%--------------------------------------------------------------------------
%                            2009-2010 Update 
% The MetAssimulo User Interface has been overhauled and bugs in the peak
% shift code have been fixed.
% MetAssimulo now incorporates user-defined correlation coefficients into
% the simulation process.
%--------------------------------------------------------------------------
%            Harriet Jane Muncey - Imperial College London (2010)
%--------------------------------------------------------------------------                         
%==========================================================================

%--------------------------------------------------------------------------
%                             Simulate spectra
%--------------------------------------------------------------------------
    % The output consists of the following three components:
    % * The chemical shift in ppm. (x)
    % * The intensities at each chemical shift for the first mixture. (ymixture1)
    % * The intensities at each chemical shift for the second mixture. (ymixture2)
    %   Where ymixture1(:,n) and ymixture2(:,n) are the spectra for replicate number
    %   n in the first and second mixtures respectively.

[x,ymixture1,ymixture2,wherex,wheremix1,wheremix2,outputdir,both,display_output] = SimulateSpectrum;


%--------------------------------------------------------------------------
%                           Displaying the results
%--------------------------------------------------------------------------
    % Default displaying of the results.
if sum(x) ~= 0;
    if display_output 
        DisplayResults(x,ymixture1,ymixture2,outputdir,both);
    end;
    simltn=strcat(outputdir,'/Simulated_Data.mat');
    load(simltn,'simulation');
    disp('Simulation complete.');
    clear x ymixture1 ymixture2 wherex wheremix1 wheremix2 outputdir both simltn
end;
close(gcbf);
