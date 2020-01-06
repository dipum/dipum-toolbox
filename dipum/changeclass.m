function image = changeclass(class, varargin)
%CHANGECLASS Changes the storage class of an image.
%  I2 = CHANGECLASS(CLASS, I);
%  RGB2 = CHANGECLASS(CLASS, RGB);
%  BW2 = CHANGECLASS(CLASS, BW);
%  X2 = CHANGECLASS(CLASS, X, 'indexed');
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

%  Copyright 1993-2002 The MathWorks, Inc.  Used with permission.

switch class
case 'uint8'
   image = im2uint8(varargin{:});
case 'uint16'
   image = im2uint16(varargin{:});
case 'double'
   image = im2double(varargin{:});
otherwise
   error('Unsupported IPT data class.');
end

