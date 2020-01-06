function bss = bsubsamp(b,scale,conn,M,N)
%BSUBSAMP Subsample a boundary.
%   BSS = BSUBSAMP(B,SCALE,CONN,M,N) subsamples the boundary B
%   indirectly by: (1) creating an image from the boundary by filling
%   the hole it contains, (2) scaling the resulting image by the
%   specified SCALE, and (3) obtaining the boundary of the resulting
%   image. Parameter CONN specifies the connectivity of the resulting
%   boundary: 4 or 8 (the default). The width and height of the
%   resulting boundary, BSS, is approximately SCALE times the width and
%   height of the original boundary. M and N are the row and column
%   dimensions of the image from which the boundary was obtained.
%   Parameter conn can be omitted from the input argument by replacing
%   it by [], in which case the default connectivity is used.
%
%   The input boundary is specified by a set of coordinates in the form
%   of an np-by-2 array. It is assumed that the boundary is one pixel
%   thick and that it is ordered in a clockwise or counterclockwise
%   sequence.
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

% Defaults.
if isempty(conn)
   conn = 8;
end

% Check inputs.
[np,nc] = size(b);
if np < nc || np < 3
   error('b must be of size np-by-2 with np >= 3'); 
end

% Create an image from the boundary. Function bound2im is a DIPUM3E
% function. The output of bound2im is of class logical. I is also of
% class logical.
I = imfill(bound2im(b,M,N),'holes');

% Scale it. The output will be of class logical. Use the 'nearest'
% option to preserve hard edges.
I = imresize(I,scale,'nearest');

% Compute the subsampled boundary.
B = bwboundaries(I,conn);
bss = B{1};



