function f = twodsin3(A,u0,v0,M,N)
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
r = (0:M - 1)';
c = 0:N - 1;
f = A*sin(u0*r + v0*c);
