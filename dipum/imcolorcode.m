function rgbim = imcolorcode(im,fground,bground)
%IMCOLORCODE Converts values in a gray or binary image to RGB color.
%   RGBIM = IMCOLORCODE(IM,FGROUND,BGROUND) converts two specific pixel
%   values in binary or grayscale image, IM, to FGROUND and BGROUND
%   colors, both of which are RGB triplets of the form [r,g,b]. For
%   example to code foreground pixels in yellow, we set FGROUND  =
%   [1,1,0]. When IM is a binary image, its high values are considered
%   foreground and its low values considered background. If IM is
%   grayscale, high means highest, and low means lowest. If BGROUND is
%   not specified, all pixels with values less than the high value are
%   left untouched. All values of FGROUND AND BGROUND must be 0 or 1,
%   independently of the class of the input. The class of the output is
%   the same as the class of the input, except if the class of the input
%   is logical because RGB images cannot be of that class. In this case,
%   the output will be floating point.
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

[im,revertClass] = tofloat(im);

red = im;
green = im;
blue = im;

switch nargin
   case 2
      % Code the highest values with the color specified in fground.
      mask = im == max(im(:));
      red(mask) = fground(1);
      green(mask) = fground(2);
      blue(mask) = fground(3);
   case 3
      % Code the highest and the lowest values.
      mask1 = im == max(im(:));
      mask2 = im == min(im(:));
      
      % Code the highest values with the color specified in fground.
      red(mask1) = fground(1);
      green(mask1) = fground(2);
      blue(mask1) = fground(3);

      % Code the lowest values with the color specified in bground.
      red(mask2) = bground(1);
      green(mask2) = bground(2);
      blue(mask2) = bground(3);
   otherwise
      error('Wrong number of inputs')
end

rgbim = cat(3,red,green,blue);

if ~isequal(revertClass,@logical)
   rgbim = revertClass(rgbim);
end

