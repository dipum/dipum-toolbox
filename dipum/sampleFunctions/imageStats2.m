function G = imageStats2(f)
%imageStats2 Sample function used in Chapter 2.
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
G{1} = size(f);
G{2} = mean2(f);
G{3} = mean(f,2);
G{4} = mean(f,1);
