function R = strsimilarity(a,b)
%STRSIMILARITY Similarity measure between two character vectors.
%   R = STRSIMILARITY(A,B) computes the similarity measure, R, defined
%   in Eq. (14-22) between character vectors A and B. The vectors do not
%   have to be of the same length, but they should be otherwise
%   registered for this method to make sense. All blanks in both vectors
%   are deleted, so they should not be used as valid characters in
%   defining A and B. Inputs can be either character vectors or scalar
%   strings, in the sense defined by MATLAB. If the inputs are strings
%   they are converted to character vectors.
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

% If inputs are scalar strings, covert them to character vectors. If
% they already are character vectors, they are not affected by the
% following function.
if (isstring(a) && isstring(b)) || (ischar(a) && ischar(b))
   a = convertStringsToChars(a);
   b = convertStringsToChars(b);
else
   error('a and b must both character vectors or both be strings')
end

% Make sure the inputs are character vectors and not higher-dimensional
% character arrays.
if ~(size(a,1) == 1 || size(a,2) == 1) && ~(size(b,1) == 1 ||...
                                                         size(b,2) == 1)
   error('a and b must be character vectors')
end

% Make sure they are rows for dimensional consistency later on.
a = a(:)';
b = b(:)';
   
% Remove all blanks.
a = a(~isspace(a)); 
b = b(~isspace(b));

% Pad the end of the shorter string. 
La = length(a); 
Lb = length(b);
if La > Lb
   b = [b,blanks(La - Lb)];
else 
   a = [a,blanks(Lb - La)];
end

% Compute the similarity measure.
I = find(a == b);
alpha = numel(I);
den = max(La,Lb) - alpha;
R = alpha/den;
