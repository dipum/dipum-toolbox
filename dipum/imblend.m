function [s,smax,smin] = imblend(f,g)
%IMBLEND Weighted sum of two images.
%   [S,SMAX,SMIN] = IMBLEND(F,G) computes a weighted sum (S) of two
%   input images, F and G. IMBLEND also computes the maximum (SMAX) and
%   minimum (SMIN) values of S. F and G must be of the same size and
%   numeric class. The output image is of the same class as the input
%   images.
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

fw = 0.5*f;
gw = 0.5*g;
s = fw + gw;
smax = max(s(:));
smin = min(s(:));
