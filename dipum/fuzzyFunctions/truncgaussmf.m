function mu = truncgaussmf(z,a,b,s)
%TRUNCGAUSSMF Truncated Gaussian membership function.
%   MU = TRUNCGAUSSMF(Z,A,B,S) computes a truncated Gaussian fuzzy
%   membership function. Z is the input variable and can be a vector of
%   any length. A, B, and S are scalar shape parameters. A and B have to
%   be ordered such that A <= B.
%
%       MU = exp(-(Z - B).^2/(2*s^2))   abs(Z - B) <= (B - A)
%       MU = 0                          otherwise
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


mu = zeros(size(z));

c = a + 2*(b - a);
range = (a <= z) & (z <= c);
mu(range) = exp(-(z(range) - b).^2/(2*s^2));

