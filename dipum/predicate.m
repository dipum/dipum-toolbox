function flag = predicate(region)
%PREDICATE Helper function for splitmerge.
%   This function sets flag to TRUE (logical 1)  if the predicate in the
%   body of the function is satisfied. Otherwise it sets flag to FALSE
%   (logical 0).
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

sd = std2(region);
m = mean2(region);
flag = (sd > 0) & (m > 0) & (m < 125);
