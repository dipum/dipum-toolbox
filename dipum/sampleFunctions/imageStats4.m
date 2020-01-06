function S = imageStats4(f) 
%imageStats4 Sample function used in Chapter 2.
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
S.ArraySize = size(f);
S.GlobalMean = mean2(f);
S.RowMeans = mean(f,2);
S.ColumnMeans = mean(f,1);
