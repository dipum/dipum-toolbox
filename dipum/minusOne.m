function [g,A] = minusOne_v2(f)
%minusOne Multiplies an input array by (-1)^x+y.
%   [G,A] = minusOne(F) multiplies F by (-1)^x+y to produce G. F can be
%   a 1-D or 2-D array. On the output, G = (-1)^(x+y).*F, and A is the
%   array of values (-1)^(x+y). Output G is floating point with values
%   in the same numerical range as F.
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

% Preliminaries.

% Convert input to floating point for multiplication later.
f = im2double(f);

% Image size.
[M,N] = size(f);

x = (0:M - 1)';
y = 0:N - 1;

A = (-1).^(x + y);

% Multiply input by matrix.
g = A.*f;
