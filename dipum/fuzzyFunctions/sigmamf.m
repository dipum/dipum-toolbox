function mu = sigmamf(z,a,b)
%SIGMAMF Sigma membership function.
%   MU = SIGMAMF(Z,A,B) computes the sigma fuzzy membership function. Z
%   is the input variable and can be a vector of any length. A and B are
%   scalar shape parameters, ordered such that A <= B.
%
%       MU = 0                          Z < A
%       MU = (Z - A) ./ (B - A)         A <= Z < B
%       MU = 1                          B <= Z
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

mu = trapezmf(z,a,b,Inf,Inf);

