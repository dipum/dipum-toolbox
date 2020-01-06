function [dir,x0,y0] = boundarydir(x,y,orderout) 
%BOUNDARYDIR Determine the direction of a sequence of planar points.
%   DIR = BOUNDARYDIR(X,Y) determines the direction of travel of a
%   closed, nonintersecting sequence of planar points with coordinates
%   contained in column vectors X and Y. Values of DIR are 'cw'
%   (clockwise) and 'ccw' (counterclockwise). The direction of travel is
%   with respect to the image coordinate system defined in Chapter 2 of
%   the book.
%
%   [DIR,X0,Y0] = BOUNDARYDIR(X,Y,ORDEROUT) determines the direction DIR
%   of the input sequence, and also outputs the sequence with its
%   direction of travel as specified in ORDEROUT. Valid values of this
%   parameter as 'cw' and 'ccw'. The coordinates of the output sequence
%   are column vectors X0 and Y0.
%
%   The input sequence is assumed to be nonintersecting, and it cannot
%   have duplicate points, with the exception of the first and last
%   points possibly being the same, a condition often resulting from
%   boundary-following functions, such as bwboundaries.
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
% Make sure coordinates are column vectors.
x = x(:);
y = y(:);

% If the first and last points are the same, delete the last point.
% The point will be restored later.
restore = false;
if x(1) == x(end) && y(1) == y(end)
   x = x(1:end-1);
   y = y(1:end-1);
   restore = true;
end
% Check for duplicate points.
if length([x y]) ~= length(unique([x y],'rows')) 
   error('No duplicate points except first and last are allowed.')
end

% The topmost, leftmost point in the sequence is always a convex
% vertex.
x0 = x; 
y0 = y;
cx = find(x0 == min(x0));
cy = find(y0 == min(y0(cx)));
x1 = x0(cx(1));
y1 = y0(cy(1));
% Scroll data so that the first point in the sequence is (x1, y1),
% the guaranteed convex point.
I = find(x0 == x1 & y0 == y1);
x0 = circshift(x0, [-(I - 1), 0]);
y0 = circshift(y0, [-(I - 1), 0]);

% Form the matrix needed to check for travel direction. Only three
% points are needed: (x1, y1), the point before it, and the point
% after it.
A = [x0(end) y0(end) 1; x0(1) y0(1) 1; x0(2) y0(2) 1];
dir = 'cw';
if det(A) > 0
   dir = 'ccw';
end

% Prepare outputs.
if nargin == 3
   x0 = x; % Reuse x0 and y0.
   y0 = y;
   if ~strcmp(dir,orderout)
      x0(2:end) = flipud(x0(2:end)); % Reverse order of travel.
      y0(2:end) = flipud(y0(2:end));
   end
   if restore
      x0(end + 1) = x0(1);
      y0(end + 1) = y0(1);
   end
end
   






