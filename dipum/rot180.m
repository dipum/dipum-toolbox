function A = rot180(A)
%ROT180 Rotates input matrix by 180 degrees.
%   A = ROT180(A) rotates matrix A by 180 degrees. This is the same as
%   flipping A along its two axes.  This function is a special case of
%   DIPUM3E function flipdims, but applicable only to 2D arrays. It is
%   used for clarity of notation in the backpropagation stage of
%   convolutional neural nets.
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

% flipdims is a DIPUM3E utility function.
A = flipdims(A,[1 2]);

