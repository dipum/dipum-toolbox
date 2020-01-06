function [hs,imp] = levelsetHeaviside(phi,epsilon)
%levelsetHeaviside 2D Heaviside and impulse for level set segmentation.
%   HS = levelsetHeaviside(PHI,METHOD,EPSILON) computes a Heaviside
%   function and its corresponding impulse (the derivative of the
%   Heaviside function) for a 1-D or 2-D input function PHI, using the
%   method suggested by Chan and Vese in the paper "Active Contours
%   Without Edges," IEEE Trans. Image Processing, Vol. 10, no. 12, 2001,
%   pp. 266-277. The equations implemented are:
%
%   Equation (12-68) in DIPUM3E:  
%        HS = 0.5*(1 + (2/pi)*(1 + arctan(phi/epsilon)) 
%   Equation (12-69):
%        IMP = (1/pi)*epsilon./(epsilon^2 + phi.^2)
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

%   where epsilon is a constant that defaults to 1 when not included
%   in the argument.

% PRELIMINARIES
% Default.
if nargin == 1
    epsilon = 1;
end
% Make sure phi is floating point.
phi = double(phi);

% HEAVISIDE FUNCTION.
hs = 0.5*(1 + (2/pi)*atan(phi/epsilon));

% CORRESPONDING IMPULSE.
imp = (1/pi)*epsilon./(epsilon^2 + phi.^2);







