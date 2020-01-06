function [rgb,lambda] = spectrumColors
%spectrumColors RGB colors corresponding to the visible light spectrum.
%   [rgb,lambda] = spectrumColors returns a set of RGB colors
%   corresponding to wavelengths in the visible light spectrum. Colors
%   are computed for integer wavelength values from 380 to 780 nm. The
%   first output, rgb, is a Px3 matrix containing color values in the
%   sRGB space. The second output, lambda, is 380:780. P is
%   length(lambda).
%
%   There is no single, uniquely correct method for performing this
%   computation. Spectral colors cannot be completely reproduced using a
%   finite set of display primaries or printing inks, so any
%   reproduction is an approximation. The method used here, a variation
%   of the one given by [Young 2012], maps spectral colors into the sRGB
%   space, which is suitable for computer display. The resulting colors
%   may appear distorted when printed.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

% Visible wavelength region. [Berns 2000, p. 3]
lambda = 380:780;
XYZ = lambda2xyz(lambda);
Y = XYZ(:,2);

% Convert to linear sRGB values. Linear values are needed for the
% scaling and average steps that follow.
rgb_lin = xyz2rgb(XYZ,'ColorSpace','linear-rgb');

% Scale so that the maximum linear RGB value is 1.0. Note: [Young 2012]
% divides by a fixed value of 2.34.
rgb_lin = rgb_lin / max(rgb_lin(:));

% One component at a time, and for each color, mix in a sufficient
% amount neutral gray with the same Y to bring negative component values
% up to 0.
for k = 1:3
   C = rgb_lin(:,k);
   F = Y ./ (Y - C);
   F(C >= 0) = 1;
   
   rgb_lin = Y + F.*(rgb_lin - Y);
end

% To get brighter spectral colors, including a good yellow, scale up the
% linear RGB values, allowing them to get higher than 1.0. Then, for
% each color, scale all components back down, if necessary, so that the
% maximum component value is 1.0. Note: [Young 2012] uses a scale factor
% of 1.85.
rgb_lin = rgb_lin * 2.5;
S = max(rgb_lin,[],2);
S = max(S,1);
rgb_lin = rgb_lin ./ S;

% Smooth out the linear RGB curves to eliminate discontinuous first
% derivatives. This helps the spectrum to appear smoother, reducing
% sharp transition points. Note: This step is not in [Young 2012].
rgb_lin = conv2(rgb_lin,ones(21,1)/21,'same');

% Eliminate small negative numbers and numbers slightly greater than 1
% that have been introduced through floating-point round-off.
rgb_lin = min(max(rgb_lin,0),1);

% Convert to nonlinear sRGB values suitable for display on a computer
% monitor.
rgb = lin2rgb(rgb_lin);

