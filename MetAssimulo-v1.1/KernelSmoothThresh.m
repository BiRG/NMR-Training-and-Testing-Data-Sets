function [yout] = KernelSmoothThresh(y,bwidth,thres)
% KernelSmoothThresh - Perform kernel smoothing for peaks above threshold
% [yout] = KernelSmoothThresh(x,y,bwidth,thres,type)
% Rewrite of KernelSmootherFinal to use FFT based convolution (uses
% conv_fft script due to Steve Eddins at Mathworks)
% 
% %%%%%%%%%%%%%%
% CURRENTLY INTRODUCES ARTEFACTS BETWEEN THE ABOVE/BELOW THRESHOLD REGIONS
%%%%%%%%%%%%%%%%%%%
%
% Written 030810 TMDE  
% (c) Copyright 2006 Dr. T.M.D. Ebbels, Imperial College, London

if (size(y,1)>1) % Make y a row vector
    y=y'; 
    colvec=1; 
else
    colvec=0;
end 
% Generate kernel - only bother with Gaussian
krange = 4*round(bwidth); % kernel support is 4 times bandwidth
if (mod(krange,2)==0) krange=krange+1; end % make odd
x = 1:krange;
x0 = (krange+1)/2; % mid point
sig2 = bwidth*bwidth/4;
kernel = (exp(-(x-x0).*(x-x0)/(2*sig2)))/sqrt(2*pi*sig2);

% Smooth the whole of y
yout = conv_fft(y,kernel);
yout = yout(x0-1:end-x0); % Chop of extra tails from convolution

% Replace parts of y which are above the threshold with unsmoothed version
threshold = (max(y)./100).*thres;
iabovethresh = (y>threshold);
yout(iabovethresh) = y(iabovethresh);

if colvec, yout=yout(:); end