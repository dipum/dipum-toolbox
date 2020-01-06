function C = imcircle(M,N,x0,y0,r,np)
%IMCIRCLE Creates a binary image of circle.
%   C = IMCIRCLE(M,N,X0,Y0,R,NP) creates an M-by-N binary image
%   containing a (white) circle of radius R centered at (X0,Y0). The
%   boundary of the circle is NP pixels thick. R is the radius of the
%   outer boundary of the circle. The default when NP is not included in
%   the call is NP = 1. If NP = R + 1, the circle becomes a white solid
%   disk of radius R, centered at (X0,Y0).
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

% Approach: Create two white disks. One of radius r, and the other of
% radius r - np. Then use the smaller circle to zero out the inside of
% the larger disk. This will create a circular boundary np pixels thick.
if nargin == 5
    np = 1;
end
y = 0:N-1;
x = (0:M-1)';
D = hypot(x - x0,y - y0);
C = (D <= r);
Cs = (D <= r - np);
C = (imcomplement(Cs)) & C;
