function mu = trapezmf(z,a,b,c,d)
%TRAPEZMF Trapezoidal membership function.
%   MU = TRAPEZMF(Z,A,B,C,D) computes a fuzzy membership function with a
%   trapezoidal shape. Z is the input variable and can be a vector of
%   any length. A, B, C, and D are scalar parameters that define the
%   trapezoidal shape. The parameters must be ordered so that A <= B, B
%   <= C, and C <= D.
%
%       MU = 0                          Z < A
%       MU = (Z - A) ./ (B - A)         A <= Z < B
%       MU = 1                          B <= Z < C
%       MU = 1 - (Z - C) ./ (D - C)     C <= Z < D
%       MU = 0                          D <= Z
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

up_ramp_region = (a <= z) & (z < b);
top_region = (b <= z) & (z < c);
down_ramp_region = (c <= z) & (z < d);

mu(up_ramp_region) = 1 - (b - z(up_ramp_region))./(b - a);
mu(top_region) = 1;
mu(down_ramp_region) = 1 - (z(down_ramp_region) - c)./(d - c);

