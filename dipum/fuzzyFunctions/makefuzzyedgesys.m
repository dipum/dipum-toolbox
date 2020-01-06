%MAKEFUZZYEDGESYS Script to make MAT-file used by FUZZYFILT.
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

% Input membership functions.
zero = @(z) bellmf(z,-0.3,0);
not_used = @(z) onemf(z);

% Output membership functions.
black = @(z) triangmf(z,0,0,0.75);
white = @(z) triangmf(z,0.25,1,1);

% There are four rules and four inputs, so the inmf matrix is 4x4. Each
% row of the inmf matrix corresponds to one rule.
inmf = {zero, not_used, zero, not_used
   not_used, not_used, zero, zero
   not_used, zero, not_used, zero
   zero, zero, not_used, not_used};

% Specify cell array of output membership functions, OUTMF (see function
% IMPLFCNS). There are four IF-THEN rules in this problem, all resulting
% in WHITE, and one ELSE rule resulting in BLACK (see Fig. 3.40).
outmf = {white,white,white,white,black};

% Inputs to the output membership functions are in the range [0,1].
vrange = [0,1];

F = fuzzysysfcn(inmf,outmf,vrange);

% Compute a lookup-table-based approximation to the fuzzy system
% function. Each of the four inputs is in the range [-1,1].
G = approxfcn(F,[-1 1; -1 1; -1 1; -1 1]);

% Save the fuzzy system approximation function to a MAT-file.
save fuzzyedgesys G
