function sig = signature(b,x0,y0)
%SIGNATURE Computes the signature of a boundary.
%   SIG = SIGNATURE(B,X0,Y0) computes the signature of boundary. B. A
%   signature is defined as the distance (DIST) from (X0,Y0) to the
%   boundary, as a function of angle. B is an np-by-2 matrix, with np >=
%   360, whose rows contain the (x,y) = (row,col) coordinates of the
%   boundary ordered in a clockwise or counterclockwise direction. If
%   (X0,Y0) is not included in the input argument, the centroid of the
%   boundary is used by default. SIG is a vector of size size 360-by-1,
%   indicating a signature resolution of one degree. The input must be a
%   one-pixel-thick boundary obtained, for example, by using function
%   bwboundaries.
%
%   If (X0,Y0) or the default centroid is outside the boundary, the
%   signature is not defined and an error is issued.
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

% Check dimensions of b.
[np,nc] = size(b);
if (np < 360 || nc ~= 2)
   error('b must be of size (>=360)-by-2.');
end

% Some boundary tracing programs, such as bwboundaries.m, result in a
% sequence in which the coordinates of the first and last points are the
% same. If this is the case, in b, eliminate the last point.
if isequal(b(1,:),b(np,:))
   b = b(1:np - 1,:);
   np = np - 1;
end

% If (x0,y0) is not specified, set the origin from which the signature
% is computed as the centroid.
if nargin == 1
   % Coordinates of the centroid.
   x0 = sum(b(:,1))/np;
   y0 = sum(b(:,2))/np;
end

% Check to see that (x0,y0) is inside the boundary.
IN = inpolygon(x0,y0,b(:,1),b(:,2));
if ~IN
   error('(x0,y0) or centroid is not inside the boundary.')
end

% Shift origin of coordinate system to (x0,y0).
b(:,1) = b(:,1) - x0;
b(:,2) = b(:,2) - y0;

% Convert the coordinates to polar. But first have to convert the given
% image coordinates, (x,y), to the coordinate system used by MATLAB for
% conversion between Cartesian and polar cordinates. Designate these
% coordinates by (xcart,ycart). The two coordinate systems are related
% as follows:  xcart = y and ycart = -x, where (x,y) = (row,col).
xcart = b(:,2);
ycart = -b(:,1);
[theta,rho] = cart2pol(xcart,ycart);

% Convert angles to degrees.
theta = theta.*(180/pi);

% Convert to all nonnegative angles.
j = theta == min(theta(:));
k = theta == max(theta(:));
theta = theta.*(0.5*abs(1 + sign(theta)))...
   - 0.5*(-1 + sign(theta)).*(360 + theta);

% Set the smallest angle to 0 and the largest angle to 359.
theta(j) = 0;
theta(k) = 359;

% Sort angles in ascending order and pair them with the corresponding
% rho
[theta,idx] = sort(theta);
rho(idx) = rho;
n = size(theta,1);

% Subsample the signature into 360 angle increments.
n = size(rho,1);
idx = round(linspace(1,n,360));
rho = rho(idx);
sig = rho;

