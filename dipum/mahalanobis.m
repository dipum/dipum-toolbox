function D = mahalanobis(varargin)
%MAHALANOBIS Computes the Mahalanobis distance.
%   D = MAHALANOBIS(Y,X) computes the Mahalanobis distance between each
%   vector in Y to the mean (centroid) of the vectors in X, and outputs
%   the result in vector D, whose length is size(Y,1). The vectors in X
%   and Y are assumed to be organized as rows of these matrices. The
%   input data can be real or complex. The outputs are real quantities.
%
%   D = MAHALANOBIS(Y,CX,MX) computes the Mahalanobis distance between
%   each vector in Y and the given mean vector, MX. The results are
%   output in vector D, whose length is size(Y, 1). The vectors in Y are
%   assumed to be organized as the rows of this array. The input data
%   can be real or complex. The outputs are real quantities. In addition
%   to the mean vector MX, the covariance matrix CX of a population of
%   vectors X must be provided also. Uses custom function COVMATRIX.
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

% Preliminaries.
param = varargin; 
Y = param{1}; % param is a cell array.
if length(param) == 2
   X = param{2};
   % Compute the mean vector and covariance matrix of the vectors in X
   % using DIPUM3E custom function covmatrix.
   [Cx,mx] = covmatrix(X);
elseif length(param) == 3 % Cov. matrix and mean vector provided.
   Cx = param{2};
   mx = param{3};
else 
   error('Wrong number of inputs.')
end

% Make sure that mx is a row vector for the next step.
mx = mx(:)';

% Subtract the mean vector from each vector in Y.
Yc = Y - mx;

% Compute the Mahalanobis distances.
D = real(sum(Yc/Cx.*conj(Yc),2));
