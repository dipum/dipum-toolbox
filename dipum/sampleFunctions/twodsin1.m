function f = twodsin1(A,u0,v0,M,N)
%Sample function used in Chapter 2.
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
f = zeros(M,N); % Preallocate space for loop speed.
for c = 1:N
   v0y = v0*(c - 1);
   for r = 1:M
      u0x = u0*(r - 1);
      f(r,c) = A*sin(u0x + v0y);
   end
end
