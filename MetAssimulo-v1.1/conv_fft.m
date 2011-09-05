function [c] = conv_fft(a,b)
% conv_fft - Convolution using FFT method
% [c] = conv_fft(a,b)
%
% a,b = [nx1] vectors to be convolved
%
% c = [nx1] convolved output
%
% Written 040810 TMDE Entirely ripped off from Steve Eddins' blog on MATLAB
% central:
% http://blogs.mathworks.com/steve/2009/11/03/the-conv-function-and-implementation-tradeoffs/
%
% (c) Copyright 2010 Dr. T.M.D. Ebbels, Imperial College, London

P = numel(a);
Q = numel(b);
L = P + Q - 1;
K = 2^nextpow2(L);

c = ifft(fft(a, K) .* fft(b, K));
c = c(1:L);
