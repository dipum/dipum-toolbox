function [T,SM] = otsuthresh(h)
%OTSUTHRESH Computes Otsu's optimum threshold from a histogram.
%	[T,SM] = OTSUTHRESH(H) computes an optimum threshold, T, in the range
%	[0,1] using Otsu's method on a given a histogram, H.
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

% Normalize the histogram to unit area. If h is already normalized, the
% following operation has no effect:
h = h/sum(h);
h = h(:); % h must be a column vector for processing below.

% All possible intensities represented in the histogram (256 for 8
% bits):
c = (1:numel(h))';  % c must be a column vector for processing below. 
% Values of P1 for all values of k.
P1 = cumsum(h);

% Values of the mean for all values of k:
m = cumsum(c.*h);

% The image mean:
mG = m(end); 

% The between-class variance:
sigSquared = ((mG*P1 - m).^2)./(P1.*(1 - P1) + eps);

% Find the maximum of sigSquared. The index where the max occurs is the
% optimum threshold. There may be several max values. If so, average
% them to obtain the final threshold.
maxSigsq = max(sigSquared);
T = mean(find(sigSquared == maxSigsq));

% Normalized to range [0,1]. 1 is subtracted because MATLAB indexing
% starts at 1, but image intensities start at 0.
T = (T - 1)/(numel(h) - 1); 

% Separability measure:
SM = maxSigsq/(sum(((c - mG).^2).*h) + eps);

