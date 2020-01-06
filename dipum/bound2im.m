function image = bound2im(b,M,N)
%BOUND2IM Converts a boundary to an image.
%   IMAGE = BOUND2IM(b) converts b, an np-by-2 array containing the
%   integer coordinates of a boundary, into a binary image with 1s in
%   the locations of the coordinates in b and 0s elsewhere. IMAGE is the
%   smallest image that will contain the boundary.
%
%   IMAGE = BOUND2IM(b,M,N) places the boundary in a region of size
%   M-by-N. M and N must satisfy the following conditions:
%
%       M >= max(b(:,1)) - min(b(:,1)) + 1 
%       N >= max(b(:,2)) - min(b(:,2)) + 1 
%
%   Typically, M = size(f,1) and N = size(f,2), where f is the image
%   from which the boundary was extracted. In this way, the coordinates
%   of IMAGE and f are comparable.
%   
%   The ouput image is of class logical. 
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

% Check input.
if size(b,2) ~= 2
   error('The boundary must be of size np-by-2')
end

% Make sure the coordinates are integers.
 b = round(b);
 
% Defaults.
if nargin == 1
   b(:,1) = b(:,1) - min(b(:,1)) + 1;
   b(:,2) = b(:,2) - min(b(:,2)) + 1;
   M = max(b(:,1));
   N = max(b(:,2));
end

% Create the image.
image = false(M,N);
linearIndex = sub2ind([M,N],b(:,1),b(:,2));
image(linearIndex) = 1;

