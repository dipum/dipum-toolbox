function mu = smf(z,a,b)
%SMF S-shaped membership function.
%   MU = SMF(Z,A,B) computes the S-shaped fuzzy membership function. Z
%   is the input variable and can be a vector of any length. A and B are
%   scalar shape parameters, ordered such that A <= B.
%
%       MU = 0                              Z < A
%       MU = 2*((Z - A) ./ (B - A)).^2      A <= Z < P
%       MU = 1 - 2*((Z - B) ./ (B - A)).^2  P <= Z < B
%       MU = 1                              B <= Z
%     
%  where P = (A + B)/2.
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

p = (a + b)/2;
low_range = (a <= z) & (z < p);
mu(low_range) = 2*( (z(low_range) - a)./(b - a) ).^2;

mid_range = (p <= z) & (z < b);
mu(mid_range) = 1 - 2*( (z(mid_range) - b)./(b - a) ).^2;

high_range = (b <= z);
mu(high_range) = 1;
