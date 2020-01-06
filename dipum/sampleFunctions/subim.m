function s = subim(f,m,n,rx,cy)
%SUBIM Extracts a subimage, s, from a given image, f.
%   The subimage is of size m-by-n, and the coordinates of its top, 
%   left corner are (rx,cy).
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

% Note the use of 'like' in the following statement to create an
% array of zeros of the same class as f (see Table 2.7).
s = zeros(m,n,'like',f); % Preallocate space for loop speed.

%Sample function used in Chapter 2.

for r = 1:m
   for c = 1:n
      s(r,c) = f(r + rx - 1,c + cy - 1);
   end
end
