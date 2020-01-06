function L = mmat2labels(R)
%MMAT2LABELS Convert membership matrix to vector of class labels.
%   L = MMAT2LABELS(R) converts membership matrix R to vector L of
%   numerical labels. R is of size NC-by-N where NC is the number of
%   classes, and N is the number of pattern vectors or images. L is of
%   size N-by-1. As explained in Sections 14.SS and 14.SS, R(:,k) has a
%   1 in the jth position if the kth pattern vector or image belongs to
%   class j.
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

% The location of a 1 in a column gives the class of the corresponding
% pattern vector or image corresponding to that column. For a properly
% constructed R, there is a single 1 per column.
N = size(R,2);
L = zeros(N,1);
for j = 1:N
   idx = find(R(:,j) == 1);
   if numel(idx) ~= 1
      error('Mambership matrix R must have a single 1 in each column')
   end
	L(j) = idx;
end



