function [p,npix] = histroi(f,c,r)
%HISTROI Computes the histogram of an ROI in an image.
%   [P,NPIX] = HISTROI(F,C,R) computes the histogram, P, of a polygonal
%   region of interest (ROI) in image F. The polygonal region is defined
%   by the column and row coordinates of its vertices, which are
%   specified (sequentially) in vectors C and R, respectively. All
%   pixels of F must be >= 0. Parameter NPIX is the number of pixels in
%   the polygonal region. For consistency with Toolbox function imhist,
%   histogram p is unnormalized. To normalize it, let p = p/npix.
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

% Generate the binary mask image.
B = roipoly(f,c,r);

% Compute the histogram of the pixels in the ROI.
p = imhist(f(B));

% Obtain the number of pixels in the ROI if requested in the output. All
% ROI pixels have value 1.
if nargout > 1
   npix = sum(B(:)); 
end


