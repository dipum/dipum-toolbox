function y = sinfun2(M)
%Sample function used in Chapter 2.
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
x = 0:M - 1;
% Preallocate y with M zeros. 
y = zeros(1,M); % Class double by default. 
for k = 1:M
   y(k) = sin(x(k)/(100*pi));
end
