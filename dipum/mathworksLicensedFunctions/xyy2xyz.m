function varargout = xyy2xyz(varargin)
%XYY2XYZ Convert chromaticity coordinates to XYZ tristimulus values.
%   [X,Y,Z] = XYY2XYZ(x,y,Y) converts the chromaticity coordinates (x
%   and y) and the Y tristimulus value to the tristimulus values X, Y,
%   and Z. Y, x, y, X, Y, and Z are all arrays with the same size.
%
%   XYZ = XYY2XYZ(xyY) performs the conversion on a Px3 input matrix
%   where P(:,1) contains the x values, P(:,2) contains the y values,
%   and P(:,3) contains the Y values. The output matrix is also Px3.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

if nargin == 3
   style = "separate";
   x = varargin{1};
   y = varargin{2};
   Y = varargin{3};
elseif nargin == 1
   style = "3-column";
   xyY = varargin{1};
   x = xyY(:,1);
   y = xyY(:,2);
   Y = xyY(:,3);
end

X = Y .* x ./ y;
Z = Y .* (1 - x - y) ./ y;

% Handle the numerical edge case where y is 0.
X(y == 0) = 0;
Z(y == 0) = 0;

if style == "3-column"
   varargout{1} = [X Y Z];
else
   varargout{1} = X;
   varargout{2} = Y;
   varargout{3} = Z;
end
