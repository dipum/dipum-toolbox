function [C,m] = covmatrix(X)
%COVMATRIX Computes the covariance matrix and mean vector.
%   [C,M] = COVMATRIX(X) computes the covariance matrix, C, and the mean
%   vector, M, of a vector population organized as the rows of matrix X.
%   This matrix is of size K-by-N, where K is the number of samples and
%   N is their dimensionality. C is of size N-by-N and M is of size
%   N-by-1. If the population contains a single sample, this function
%   outputs M = X and C as an N-by-N matrix of NaN's because the
%   definition of an unbiased estimate of the covariance matrix divides
%   by K - 1.
%
%   The following link has a manual computational example that you can
%   compare with the results obtained by covmatrix for the same data:
%   https://www.itl.nist.gov/div898/handbook/pmc/section5/pmc541.htm
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

K = size(X,1);
X = double(X);

% Compute an unbiased estimate of m.
m = sum(X,1)/K;

% Subtract the mean from each row of X.
X = X - m;

% Compute an unbiased estimate of C. Note that the product is X'*X
% because the vectors are rows of X.
C = (X'*X)/(K - 1);

% Convert the mean vector to a column vector.
m = m(:);     

