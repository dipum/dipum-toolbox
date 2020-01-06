function out = colorMatchingFunctions
%colorMatchingFunctions Color-matching functions.
%   colorMatchingFunctions returns a table containing the color matching
%   functions for the CIE 1931 Standard Observer. The table contains the
%   variables lambda, x, y, and z. The color matching functions are
%   returned for wavelengths between 360nm and 830nm at intervals of 1nm.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

persistent t

if isempty(t)
   t = readtable('CIE 1931 Standard Observer (1nm).xlsx',...
      'UseExcel',false);
end

out = t;
