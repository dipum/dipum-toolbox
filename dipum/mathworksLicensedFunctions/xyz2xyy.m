function varargout = xyz2xyy(varargin)
%XYZ2XYY Convert XYZ tristimulus values to chromaticity coordinates.
%   [x,y,Y] = XYZ2XYY(X,Y,Z) converts the tristimulus values (X, Y, and
%   Z) to chromaticity coordinates (x and y). Y is also returned as the
%   third output argument. X, Y, Z, x, and y are arrays with the same
%   size.
%
%   xyY = XYZ2XYY(XYZ) performs the conversion on a Px3 input matrix
%   where P(:,1) contains the X values, P(:,2) contains the Y values,
%   and P(:,3) contains the Z values. The output matrix is also Px3.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

if nargin == 3
   style = "separate";
   X = varargin{1};
   Y = varargin{2};
   Z = varargin{3};
elseif nargin == 1
   style = "3-column";
   XYZ = varargin{1};
   X = XYZ(:,1);
   Y = XYZ(:,2);
   Z = XYZ(:,3);
end

denominator = X + Y + Z;
x = X./denominator;
y = Y./denominator;

% Handle the numerical edge case where X + Y + Z is 0.
x(denominator == 0) = 0;
y(denominator == 0) = 0;

if style == "3-column"
   varargout{1} = [x y Y];
else
   varargout{1} = x;
   varargout{2} = y;
   varargout{3} = Y;
end

