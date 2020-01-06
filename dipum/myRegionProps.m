function [P,C,evalmax,evalmin] = myRegionProps(I)
%myRegionProps Properties of a single binary region.
%   P = myRegionProps(I) computes properties of a single region in
%   binary image I. P is a structure with the following fields: P.comp
%   for compactness, P.circ, for circularity, and P.ecc for
%   eccentricity.
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

% Convert to floating point in the range [0,1]
I = intensityScaling(I);

% Find the coordinates of the 1-valued pixels.
[x,y] = find(I == 1);

% Compute the covariance matrix of the points. This is a utility
% function.
C = covmatrix([x y]);
% Find the eigenvalues using MATLAB function eig. Return eigenvalues
% in column vector evals.
[~,evals] = eig(C,'vector');

% Find the largest and smallest eigenvalues.
evalmax = max(evals);
evalmin = min(evals);

% Use regionprops to obtain the perimeter.
stats = regionprops(logical(I),'Perimeter');
p = stats.Perimeter;

%-Area of number of 1-valued pixels in I.
A = sum(I(:));

%-Compactness
P.comp = (p^2)/A;

%-Circularity.
P.circ = 4*pi*A/(p^2);

%-Eccentricity.
P.ecc = sqrt(1 - (evalmin/evalmax)^2);






