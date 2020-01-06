function XYZ = rspd2xyz(varargin)
%RSPD2XYZ Convert relative spectral power density to XYZ.
%   RSPD2XYZ(lambda,phi) converts a relative spectral power density
%   function to 1931 CIE XYZ tristimulus values. The inputs, lambda and
%   phi, are both vectors with the same length. The input lambda is the
%   wavelength (in nm). The input phi is the relative spectral power
%   density.
%
%   RSPD2XYZ(S) converts a relative spectral power density function
%   represented as either a Px2 numeric matrix or a table. If S is a
%   numeric matrix, then S(:,1) is the wavelength, lambda, and S(:,2) is
%   phi. If S is a table with a variable called "lambda", then that
%   variable is used as lambda and the table's other variable is used as
%   phi. If the table does not have a variable named "lambda", then the
%   table's first variable is used as lambda, and the second variable is
%   used as phi.
%
%   RSPD2XYZ(I,R) converts an illumination spectral power density curve
%   (I) and a relative reflectance curve (R) to tristimulus values. I
%   and R can each be either a Px2 matrix or a table.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

narginchk(1,2);

if nargin == 2
   if isvector(varargin{1}) && isvector(varargin{2})
      % rspd2xyz(lambda,phi)
      % Treat the input as I (the illumination curve). Construct the
      % reflectance curve as a constant from lambda = 300 to lambda =
      % 830.
      lambda = varargin{1};
      phi = varargin{2};
      I = [lambda(:) phi(:)];
      R = [300 1; 830 1];
   else
      % rspd2xyz(I,R)
      I = varargin{1};
      R = varargin{2};
   end
else
   % rspd2xyz(S)
   % Treat the input as I (the illumination curve). Construct the
   % reflectance curve as a constant from lambda = 300 to lambda = 830.
   I = varargin{1};
   R = [300 1; 830 1];
end

% Convert the inputs, in either Px2 matrix or table form, to function
% handles that return phi(lambda) for any lambda using spline
% interpolation and constant extrapolation.
fI = phiFunction(I);
fR = phiFunction(R);

matching_fcns = colorMatchingFunctions;

L = matching_fcns.lambda;
x = matching_fcns.x;
y = matching_fcns.y;
z = matching_fcns.z;
x = x/(100*sum(x));
y = y/(100*sum(y));
z = z/(100*sum(z));

% Perform a simple numerical integration.
XYZ = sum(fI(L) .* fR(L) .* [x y z],1);

%----------------------------------------------------------------------%
function f = phiFunction(S)
%   Create a function handle that returns phi(lambda). The input can be
%   a Px2 numeric matrix or a table as described in the documentation
%   above for rspd2xyz.

if istable(S)
   % Look for table variable called lambda.
   idx = find(S.Properties.VariableNames == "lambda",1);
   if isempty(idx)
      % The table does not have a lambda variable. Assume the first
      % variable is lambda and the second variable is phi.
      lambda = S{:,1};
      phi = S{:,2};
   else
      lambda = S{:,idx};
      
      % Use the first non-lambda table variable as phi.
      kk = 1:width(S);
      kk(idx) = [];
      phi = S{:,kk(1)};
   end
else
   % S is a matrix. Use the first column as lambda and the second
   % column as phi.
   S = double(S);
   lambda = S(:,1);
   phi = S(:,2);
end

% Add zeros to the beginning and end of phi. When using the spline
% function for cubic spline interpolation, this has the effect of
% enabling constant extrapolation using the first and last values of
% phi. See section 7.2.2.1, Extrapolation, CIE 15:2004, Technical Report
% on Colorimetry.
phi = [0 ; phi ; 0];

% Create a function handle that interpolates phi using cubic spline
% interpolation.  Cubic spline is one of the recommended interpolation
% methods. See section 7.2.1.1, Interpolation, CIE 15:2004, Technical
% Report on Colorimetry.
f = @(lambda_q) spline(lambda,phi,lambda_q);
