function h = ntrop(x,n)
%NTROP Computes a first-order estimate of the entropy of a matrix.
%   H = NTROP(X,N) returns the entropy of matrix X with N symbols. N =
%   256 if omitted but it must be larger than the number of unique
%   values in X for accurate results. The estimate assumes a
%   statistically independent source characterized by the relative
%   frequency of occurrence of the elements in X. The estimate is a
%   lower bound on the average number of bits per unique value (or
%   symbol) when coding without coding redundancy.
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

narginchk(1,2);         % Check input arguments
if nargin < 2   
   n = 256;                           % Default for n.
end 

x = double(x);                        % Make input double
xh = histcounts(x(:),n);             % Compute N-bin histogram
xh = xh / sum(xh(:));                 % Compute probabilities  

% Make mask to eliminate 0's since log2(0) = -inf.
i = find(xh);           

h = -sum(xh(i) .* log2(xh(i)));       % Compute entropy
