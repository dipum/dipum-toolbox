function f = twodsin2(A,u0,v0,M,N)
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
r = 0:M - 1; % Row coordinates.
c = 0:N - 1; % Column coordinates.
[C,R] = meshgrid(c,r); % Observe the order of r and c, and R and C.
f = A*sin(u0*R + v0*C);
