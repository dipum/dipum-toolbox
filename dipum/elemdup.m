function B = elemdup(A,v)
%ELEMDUP Duplicates the elements of an array in specified dimensions.
%   B = ELEMDUP(A,V) duplicates each element of A the number of times
%   specified in the corresponding locations of vector V. For example,
%   if A is a 3-D array and we specify V = [2,2,1], the elements of the
%   rows and colums of A are duplicated 2 times each. The third
%   dimension is left unchanged. If A is a K-dimensional array and we
%   only specify in V the first J dimensions (J <= K) of A, the
%   remaining dimensions of A are not touched. This is also true if V
%   contains more elements than ndims(A), provided that all those extra
%   elements are valued 1. The number of dimensions of B and A are the
%   same, the sizes of the two arrays will be different in the
%   corresponding values of V that are not 1. All elements of V must be
%   positive.
%
%   This function is a generalization of function pixeldup in DIPUM2E. 
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

nDimsA = ndims(A);

% If the number of elements of v exceeds nDimsA, and all those elements
% past numDimsA are valued 1, delete them, as they could be caused by
% handling arrays of various dimensions along which A is not expected to
% be processed. However, if any of those trailing elements of v are not
% 1, then issue an error.
if numel(v) > nDimsA
   idx = find(v ~= 1);
   % Keep only those dim values larger than nDimsA.
   idx = idx(idx > nDimsA);
   % If the values of v in any of those dimensions is not valued 1,
   % issue an error.
   if sum(v(idx)) ~= numel(idx)
      error('One or more of the dims of v that exceed ndims(A) are not valued 1')
   end
elseif numel(v) < nDimsA
   % Set the remaining dimensions of vdims to 1.
   v(numel(v) + 1 : nDimsA) = 1;
end

% Process A along the first ndimsA dimensions of v. Function repelem is
% a MATLAB function introduced in R2015a. This function  has the syntax
% B = repelem(A,r1,r2,...,rN). The construct vdims = num2cell(vdims) and
% its use as vdims{:} converts the elements of the vector into a
% comma-separated list, as required by this function.
v = num2cell(v);
B = repelem(A,v{:});



 
