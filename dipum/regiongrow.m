function [g,NR,SI,TI] = regiongrow(f,S,T)
%REGIONGROW Image segmentation using region growing.
%   [G,NR,SI,TI] = REGIONGROW(F,S,T). S can be a matrix of the same size
%   as the input image F, with a 1 at the coordinates of every seed
%   point and 0s elsewhere. S can also be a single seed value. Similarly
%   T can be a matrix of the same size as F, containing a threshold
%   value for each pixel in F. T can also be a scalar, in which case it
%   becomes a global threshold. All values in S and T must be in the
%   range [0,1].
%
%   G is the segmented image resulting from region growing, with each
%   region labeled by a different integer, NR is the number of regions,
%   SI is the final seed image used by the algorithm, and TI is the
%   image consisting of the pixels in F that satisfied the threshold
%   test, but before they were processed for connectivity.
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

f = tofloat(f);
% If S is a scalar, obtain the seed image.
if numel(S) == 1
   SI = f == S;
   S1 = S;
else
   % S is a matrix. Eliminate duplicate, connected seed locations to 
   % reduce the number of loop executions in the following section of
   % code.
   SI = bwmorph(S,'shrink',Inf);  
   S1 = f(SI); % Matrix of seed values.
end
 
TI = false(size(f));
for K = 1:length(S1)
   seedvalue = S1(K);
   S = abs(f - seedvalue) <= T; % Re-use variable S.
   TI = TI | S;
end

% Use function imreconstruct with SI as the marker image to obtain the
% regions corresponding to each seed in S. Function bwlabel assigns a
% different integer to each connected region.
[g,NR] = bwlabel(imreconstruct(SI,TI));

