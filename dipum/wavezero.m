function [nc,g8] = wavezero(c,s,l,wname)
%WAVEZERO Zeroes wavelet transform detail coefficients. 
%   [NC,G8] = WAVEZERO(C,S,L,WNAME) zeroes the level L detail
%   coefficients in wavelet decomposition structure [C, S] and computes
%   the resulting inverse transform with respect to WNAME wavelets.
%
%   Copyright 2002-2020 Gatesmark
%
%   This function, and other functions in the DIPUM Toolbox, are based 
%   on the theoretical and practical foundations established in the 
%   book Digital Image Processing Using MATLAB, 3rd ed., Gatesmark 
%   Press, 2020.
%
%   Book website: http://www.imageprocessingplace.com
%   License: https://github.com/dipum/dipum-toolbox/blob/master/LICENSE.txt

[nc,~] = wavecut('h',c,s,l);
[nc,~] = wavecut('v',nc,s,l);
[nc,~] = wavecut('d',nc,s,l);
i = waveback(nc,s,wname);
g8 = im2uint8(mat2gray(i));
figure; imshow(g8);
