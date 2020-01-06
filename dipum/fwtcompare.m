function [ratio, maxdiff] = fwtcompare(f, n, wname)
%FWTCOMPARE Compare wavedec2 and wavefast.
%   [RATIO, MAXDIFF] = FWTCOMPARE(F, N, WNAME) compares the
%   operation of Wavelet Toolbox function WAVEDEC2 and custom
%   function WAVEFAST. 
%
%   INPUTS:
%     F           Image to be transformed.
%     N           Number of scales to compute.
%     WNAME       Wavelet to use.
%
%   OUTPUTS:
%     RATIO       Execution time ratio (custom/toolbox)
%     MAXDIFF     Maximum coefficient difference.
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

% Get transform and computation time for wavedec2.
w1 = @() wavedec2(f, n, wname);
reftime = timeit(w1);

% Get transform and computation time for wavefast.
w2 = @() wavefast(f, n, wname);
t2 = timeit(w2);

% Compare the results.
ratio = t2 / reftime;
maxdiff = abs(max(w1() - w2()));
