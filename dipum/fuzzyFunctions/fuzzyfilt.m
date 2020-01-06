function g = fuzzyfilt(f)
%FUZZYFILT Fuzzy edge detector.
%   G = FUZZYFILT(F) implements the rule-based fuzzy filter discussed in
%   in Section 3.6 of DIPUM3E. F and G are the input and filtered
%   images, respectively.
%
%   FUZZYFILT is implemented using a precomputed fuzzy system function
%   handle saved in the MAT-file fuzzyedgesys.mat.  The script
%   makefuzzyedgesys.m contains the code used to create the fuzzy system
%   function.
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
 
% Work in floating point.
[f,revertClass] = tofloat(f);

% The fuzzy system function has four inputs - the differences between
% the pixel and its north, east, south, and west neighbors. Compute
% these differences for every pixel in the image using imfilter.
z1 = imfilter(f,[0 -1 1],'conv','replicate');
z2 = imfilter(f,[0; -1; 1],'conv','replicate');
z3 = imfilter(f,[1; -1; 0],'conv','replicate');
z4 = imfilter(f,[1 -1 0],'conv','replicate');

% Load the precomputed fuzzy system function and apply it.
s = load('fuzzyedgesys');
g = s.G(z1,z2,z3,z4);

% Convert the output image back to the class of the input image.
g = revertClass(g);
