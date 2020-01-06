function y = mat2lpc(x,f)
%MAT2LPC Compresses a matrix using 1-D lossles predictive coding.
%   Y = MAT2LPC(X, F) encodes matrix X using 1-D lossless predictive
%   coding. A linear prediction of X is made based on the coefficients
%   in F. If F is omitted, F = 1 (for previous pixel coding) is assumed.
%   The prediction error is then computed and output as encoded matrix
%   Y.
%
%   See also LPC2MAT.
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

narginchk(1,2);                     % Check input arguments
if nargin < 2                       % Set default filter if omitted
    f = 1;
end

x = double(x);                      % Ensure double for computations
[m, n] = size(x);                   % Get dimensions of input matrix
p = zeros(m,n);                     % Init linear prediction to 0
xs = x;     zc = zeros(m,1);        % Prepare for input shift and pad

for j = 1:length(f)                 % For each filter coefficient ...
    xs = [zc xs(:,1:end - 1)];      % Shift and zero pad x
    p = p + f(j) * xs;              % Form partial prediction sums
end

y = x - round(p);                   % Compute prediction error
