function G = imageStats3(f)
%imageStats3 Sample function used in Chapter 2.
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
P = size(f,3);
G = cell(4,P);
for k = 1:P
    G{1,I} = size(f(:,:,k));
    G{2,I} = mean2(f(:,:,k));
    G{3,I} = mean(f(:,2,k),2);
    G{4,I} = mean(f(:,1,k),1);
end
