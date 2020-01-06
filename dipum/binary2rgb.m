function rgbim = binary2rgb(binaryim,rgbtriplet)
%BINARY2RGB Converts high values in a binary image to one RGB color.
%   RGBIM = BINARY2RGB(BINARYIM,RGBTRIPLET) converts the high values in
%   bivalued (binary) image BINARYIM to a single color specified in
%   triplet RGBTRIPLET, which is of the form [r,g,b], where r, g, and b
%   are 0 or 1, and define the color of the output. For example, [1,0,0]
%   specifies red and [1 1 0] specifies yellow.
%
%   This is a DIPUM3E utility function.
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

% If the input is not already logical, convert to logical, treating
% anything greater than the minimum value as high (foreground).
if ~islogical(binaryim)
   binaryim = binaryim > min(binaryim(:));
end

% Initialize three component images.
red = zeros(size(binaryim));
green = red;
blue = red;

% Insert the corresponding RGB triplet value into the component images
% based on the foreground pixel locations in binaryim.
red(binaryim) = rgbtriplet(1);
green(binaryim) = rgbtriplet(2);
blue(binaryim) = rgbtriplet(3);

% Form RGB output image from the three component images.
rgbim = cat(3,red,green,blue);





