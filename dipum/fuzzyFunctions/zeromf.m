function mu = zeromf(z)
%ZEROMF Constant membership function (zero).
%   MU = ZEROMF(Z) returns an an array of zeros with the same size as Z.
%
%   When using the @max operator to combine rule antecedents,
%   associating this membership function with a particular input means
%   that input has no effect.
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
