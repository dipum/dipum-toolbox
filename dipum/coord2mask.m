function mask = coord2mask(M,N,vx,vy)
%COORD2MASK Generates a binary mask from given coordinates.
%   MASK = COORD2MASK(M,N,vx,yy) generates a binary mask, MASK, of size
%   M-by-N given a set of sequential coordinates [vx,yy] describing the
%   vertices of a polygon. The points inside and on the polygon are
%   labeled with 1s and all other points are labeled 0.
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

% Create the mask by labeling as 1 all point inside or on the polygon
% defined by the vertices [vx,vy]. All other points in mask are labeled
% 0. This labeling is done automatically by MATLAB function poly2mask.
% NOTE: The syntax of this function is awkward. The order of vx (rows)
% and vy (columns) coordinates have to be reversed to match the book,
% but the M (number of rows) and N (number of columns) are input in the
% order used in the book.
mask = poly2mask(vy,vx,M,N); 




