function A = iswhole(X)
% ISWHOLE True for integers(whole numbers).
%     A = ISWHOLE(X) returns true (1) in A for the elements of X that
%     are whole numbers (integers in the "traditional" sense), and false
%     (0) for all other values of X, where X is an array of arbitrary
%     dimensions. ISWHOLE does not check for integer data type as does
%     MATLAB function ISINTEGER.
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

A = (X == floor(X));


