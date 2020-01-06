function xyz = lambda2xyz(lambda)
%LAMBDA2XYZ Convert wavelength to tristimulus values.
%   LAMBDA2XYZ converts spectral wavelengths (in nm) to CIE 1931
%   tristimulus values. The output is a Px3 matrix, where P is the
%   number of elements in the array lambda.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

fcns = colorMatchingFunctions;
xyz = interp1(fcns.lambda,[fcns.x fcns.y fcns.z],lambda(:));
