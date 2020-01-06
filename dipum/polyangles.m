function angles = polyangles(x,y)
%POLYANGLES Computes internal polygon angles.
%	ANGLES = POLYANGLES(X,Y) computes the interior angles (in degrees) of
%	an arbitrary polygon whose vertices have x- and y-coordinates given
%	in column vectors X and Y. The vertices must be arranged in a
%	clockwise manner.  The program eliminates duplicate adjacent rows in
%	[X,Y], except that the first row may equal the last, so that the
%	polygon is closed.
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
xy = [x(:),y(:)];
if isempty(xy)
    % No vertices!
    angles = zeros(0,1);
    return
end

% Close the polygon if necessary.
if (size(xy,1) == 1) || ~isequal(xy(1,:),xy(end,:))
    xy = [xy;xy(1,:)];
end

% Eliminate duplicate vertices.
if size(xy,1) > 2
    xy(all(diff(xy,1,1) == 0,2),:) = [];
end

% Form a set of vectors by taking the differences between adjacent
% vertices in the polygon.  These vectors form a chain directed in the
% clockwise direction because of the way the data is input.
v2 = diff(xy,1,1);

% Each angle of the polygon is formed by the head of a vector joining
% the tail of the vector following it in the sequence. Each vector in
% the following array precedes its corresponding vector in v2:
v1 = circshift(v2,[1 0]);

% Get the x- and y-components of each vector.
v1x = v1(:,1);
v1y = v1(:,2);
v2x = v2(:,1);
v2y = v2(:,2);

% The angles between the vectors in v2 relative to the vectors in v1 is
% given by the following expression. See, for example,
% http://www.euclideanspace.com/maths/algebra/vectors/ and (select
% "angle between" for an explanation of this expression).
angles = (180/pi)*(atan2(v2y,v2x) - atan2(v1y,v1x));

% Because the head of each vector in v1 points to the tail of the
% subsequent vector in v2 (see above), the preceding expression gives
% "outer" angles. We need the interior angles of the polygon. To do
% this, we have to reverse the direction of one of the vectors or,
% equivalently, add (or subtract) 180 degrees from the previous result.
% We also want to make sure that all angles are in the range 0 to 360
% degrees. The following expression implements both requirements:
angles = mod(angles + 180,360);



