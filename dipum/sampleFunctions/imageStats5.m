function T = imageStats5(f)
%imageStats5 Sample function used in Chapter 2.
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
% Initialize table variables to hold information for P images.
ArraySize = zeros(P,2);
GlobalMean = zeros(P,1);
RowMeans = zeros(P,size(f,1));
ColumnMeans = zeros(P,size(f,2));
for k = 1:P
   fk = f(:,:,k);
   ArraySize(k,:) = size(fk);
   GlobalMean(k) = mean2(fk);
   RowMeans(k,:) = mean(fk,2)'; % Transpose to store row means as a row   
                                % vector
   ColumnMeans(k,:) = mean(fk,1);
end
% Create the table from the individual variables.
T = table(ArraySize,GlobalMean,RowMeans,ColumnMeans);
