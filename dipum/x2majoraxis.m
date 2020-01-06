function [C,theta] = x2majoraxis(A,B)
%X2MAJORAXIS Aligns coordinate x with the major axis of a region.
%  [C,THETA] = X2MAJORAXIS(A,B) aligns the x-coordinate axis with the
%  major axis of a region or boundary. The y-axis is perpendicular to
%  the x-axis.  The rows of 2-by-2 matrix A are the coordinates of the
%  two end points of the major axis, in the form A = [x1 y1; x2 y2].
%  Input B is either a an image of class logical containing a single
%  region, or it is an np-by-2 set of points representing a (connected)
%  boundary. In the latter case, the first column of B must represent
%  x-coordinates and the second column must represent the corresponding
%  y-coordinates. Output C contains the same data as the input, but
%  aligned with the major axis. If the input is an image, so is the
%  output; similarly the output is a sequence of coordinates if the
%  input is such a sequence. Parameter THETA is the initial angle
%  between the major axis and the x-axis. The origin of the xy-axis
%  system is at the bottom left; the x-axis is the horizontal axis and
%  the y-axis is the vertical.
%
%  Keep in mind that rotations can introduce round-off errors when the
%  data are converted to integer (pixel) coordinates, which typically is
%  a requirement.  Thus, postprocessing (e.g., with bwmorph) of the
%  output may be required to reconnect a boundary.
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

% Preliminaries.
if islogical(B)
  type = 'region';
elseif size(B,2) == 2
  type = 'boundary';
  [M,N] = size(B);
  if M < N
    error('B is boundary. It must be of size np-by-2; np > 2.')
  end
  % Compute centroid for later use. c is a 1-by-2 vector. 
  % Its 1st component is the mean of the boundary in the x-direction.
  % The second is the mean in the y-direction.
  c(1) = round((min(B(:,1)) + max(B(:,1)))/2);
  c(2) = round((min(B(:,2)) + max(B(:,2)))/2);
  
  % It is possible for a connected boundary to develop small breaks
  % after rotation. To prevent this, the input boundary is filled, 
  % processed as a region, and then the boundary is re-extracted.
  % This guarantees that the output will be a connected boundary.
  m = max(max(B));
  % The following image is of size m-by-m to make sure that there
  % there will be no size truncation after rotation.
  B = bound2im(B,m,m); 
  B = imfill(B,'holes');
else
  error('Input must be a boundary or a binary image.')
end

% Major axis in vector form.
v(1) = A(2,1) - A(1,1);
v(2) = A(2,2) - A(1,2);
v = v(:);  % v is a col vector

% Unit vector along x-axis.
u = [1; 0];

% Find angle between major axis and x-axis. The angle is
% given by acos of the inner product of u and v divided by
% the product of their norms. Because the inputs are image
% points, they are in the first quadrant.
nv = norm(v);
nu = norm(u);
theta = acos(u'*v/nv*nu); 
if theta > pi/2
  theta = -(theta - pi/2);
end
theta = theta*180/pi;  % Convert angle to degrees.

% Rotate by angle theta and crop the rotated image to original size.
C = imrotate(B,theta,'bilinear','crop');

% If the input was a boundary, re-extract it.
if  strcmp(type,'boundary')
  C = bwboundaries(C);
  C = C{1};
  % Shift so that centroid of the extracted boundary is  
  % approx equal to the centroid of the original boundary:
  C(:,1) = C(:,1) - (min(C(:,1)) + max(C(:,1)))/2 + c(1);
  C(:,2) = C(:,2) - (min(C(:,2)) + max(C(:,2)))/2 + c(2);
end
