function g = imwarp2(f,varargin)
%IMWARP2 2-D geometric transformation with fixed output location.
%   G = IMWARP2(F,TFORM,___) applies a 2-D geometric transformation to
%   an image. IMWARP2 fixes the output image location, or "output view,"
%   to cover the same region as the input image. IMWARP2 takes the same
%   set of optional parameters as IMWARP.
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

output_view = imref2d(size(f));
g = imwarp(f,varargin{:},'OutputView',output_view);
