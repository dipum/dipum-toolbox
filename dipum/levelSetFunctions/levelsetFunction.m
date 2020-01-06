function phi = levelsetFunction(type,varargin)
%LEVELSETFUNCTION Generates a level-set function.
%   PHI = LEVELSETFUNCTION(TYPE,VARARGIN) generates a level set
%   (signed distance) function, PHI.  
%
%   If TYPE = 'mask' and VARARGIN = BINMASK (a binary image containing a
%	 zero level set curve) then a signed distance function is generated
%	 using BINMASK. BINMASK should have 1's inside and on the curve and
%	 zeros elsewhere. If only the coordinates of the zero level set curve
%	 are available, use custom function coord2mask to generate BINMASK
%	 before using levelsetFunction. The level set function is computed
% 	 directly (without iteration) using function bwdist.
%
%	 If TYPE = 'circular' and VARARGIN = M,N,X0,Y0,R then a circular
%	 signed distance function array of size M-by-N, with center at
%	 (X0,Y0) and radius R, is computed. The approach is illustrated in
%	 Fig. 12.12 of DIPUM3E.
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

% COMPUTE THE LEVEL SET FUNCTION, DEPENDING ON SPECIFIED TYPE.
switch type
	case 'mask'
      % Create the level set function as a signed distance function.    
      binmask = varargin{1};
      phi = double(bwdist(1 - binmask) - bwdist(binmask)...
                                                - (binmask - 0.5));
	case 'circular'
      % A circle is automatically a signed distance function.
      M = varargin{1};
      N = varargin{2};
      x0 = varargin{3};
      y0 = varargin{4};
      r = varargin{5};
      [y,x] = meshgrid(1:N,1:M);
      phi = sqrt((x - x0).^2 + (y - y0).^2) - r;
end
