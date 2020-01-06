function Xflip = flipdims(X,v)
%FLIPDIMS Flips array in specified dimensions.
%   XFLIP = FLIPDIMS(X,V) flips (rotates by 180 degrees) array X in the
%   dimensions specified in vector V. The first dimension is the
%   vertical spatial dimension, the second is the horizontal dimension,
%   and the third is what we call depth of a 3-D volume. The remaining
%   dimensions cannot be visualized. The default when V is given is to
%   flip X along all its dimensions.
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

% Set default.
if nargin == 1
   % Set v to all dimensions.
   v = 1:ndims(X);
end

% Form vector of subscripts. Initialize with ':' for dimensions that
% remain unchanged.
num_subscripts = max(ndims(X),max(v));
subscripts = repmat({':'},1,num_subscripts);
for k = 1:length(v)
   vk = v(k);
   Nk = size(X,vk);
   subscripts{vk} = Nk:-1:1;
end

% Do the flipping using a single indexing operation.
Xflip = X(subscripts{:});

