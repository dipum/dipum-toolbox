function [X,r] = imstack2vectors(S,MASK)
%IMSTACK2VECTORS Extracts vectors from an image stack.
%   [X,R] = imstack2vectors(S,MASK) extracts vectors from S, which is an
%   M-by-N-by-n stack array of n registered images of size M-by-N each
%   (see Fig. 13.32 in DIPUM3). The extracted vectors are arranged as
%   the rows of matrix X. Input MASK is an M-by-N logical or numeric
%   image with nonzero values in the locations where elements of S are
%   to be used in forming X and 0s in locations to be ignored. The
%   number of row vectors in X is equal to the number of nonzero
%   elements of MASK. If MASK is omitted, all M*N locations are used in
%   forming X.  A simple way to obtain MASK interactively is to use
%   function roipoly. Finally, R is a column vector that contains the
%   linear indices of the locations of the vectors extracted from S.
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

% Stack size.
[M,N,n] = size(S);

% Default.
if nargin == 1
   MASK = true(M,N);
else
   MASK = MASK ~= 0;
end

% Find the linear indices of the 1-valued elements in MASK. Each
% element of r identifies the location in the M-by-N array of the
% vector extracted from S.
r = find(MASK);

% The remaining code finds X.

% First reshape S into X by turning each set of n values along the
% third dimension of S so that it becomes a row of X. The order is
% from top to bottom along the first column, the second column, and
% so on.
Q = M*N;
X = reshape(S,Q,n);

% Now reshape MASK so that it corresponds to the right locations
% vertically along the elements of X.
MASK = reshape(MASK,Q,1);

% Keep the rows of X at locations where MASK is not 0.
X = X(MASK,:);

