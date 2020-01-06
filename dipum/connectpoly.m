function c = connectpoly(x,y)
%CONNECTPOLY Connects the vertices of a polygon with straight lines.
%   C = CONNECTPOLY(X,Y) connects the points in X and Y with straight
%   lines, where X and Y are vectors containing the row and column
%   coordinates of the polygon vertices. These points are assumed to be
%   ordered in the clockwise or counterclockwise direction. The output,
%   C, is np-by-2 matrix whose rows are the (row,col) coordinates of the
%   boundary of the polygon, which are in the same direction as the
%   input vertices. The last point in the sequence is equal to the
%   first, thus producing a polygon that is both fully connected and
%   closed.
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

v = [x(:),y(:)];

% Close the polygon.
if ~isequal(v(end,:),v(1,:))
   v(end + 1,:) = v(1,:);
end

% Connect the vertices.
segments = cell(1,length(v) - 1);
for k = 2:length(v)
   [x,y] = intline(v(k - 1,1),v(k,1),v(k - 1,2),v(k,2));
   segments{k - 1} = [x,y];
end

c = cat(1,segments{:});
