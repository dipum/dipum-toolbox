function tform = geotrans(varargin)
%GEOTRANS Make affine and projective geometric transformations.
%   TFORM = GEOTRANS(TYPE,P1,P2,___) makes a geometric transformation
%   with the specified type and parameters.
%
%   Valid values for TYPE and P1, P2, ..., are:
%
%   'scale'     Scale. If only P1 is provided, it is the scale
%               factor in both directions. If P1 and P2 are provided,
%               then P1 is the horizontal scale factor and P2 is the
%               vertical scale factor.
%
%   'rotate'    Rotation. P1 is the rotation angle, measured in
%               degrees counterclockwise from the positive horizontal
%               axis.
%
%   'translate' Translation. P1 is the horizontal translation and P2
%               is the vertical translation.
%
%   'h-reflect' Horizontal reflection.
%
%   'v-reflect' Vertical reflection.
%
%   'h-shear'   Horizontal shear. P1 is the sheer angle in degrees,
%               measured counterclockwise from the downward-pointing
%               y-axis.
%
%   'v-shear'   Vertical shear. P1 is the sheer angle in degrees,
%               measured clockwise from the horizontal axis.
%
%
%   'compose'   Composition of transformations. P1, P2, ..., are
%               affine2d and projective2d transformations.
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

if ischar(varargin{1}) || isstring(varargin{1})
   operation = varargin{1};
   switch operation
      case 'scale'
         narginchk(2,3);
         tform = scale(varargin{2:end});
      case 'rotate'
         narginchk(2,2);
         tform = rotate(varargin{2});
      case 'translate'
         narginchk(3,3);
         tform = translate(varargin{2:end});
      case 'h-reflect'
         narginchk(1,1);
         tform = reflectHorizontal;
      case 'v-reflect'
         narginchk(1,1);
         tform = reflectVertical;
      case 'h-shear'
         narginchk(2,2);
         tform = shearHorizontal(varargin{2});
      case 'v-shear'
         narginchk(2,2);
         tform = shearVertical(varargin{2});
      case 'compose'
         narginchk(2,Inf);
         tform = compose(varargin{2:end});
      otherwise
         error('Unrecognized operation: %s',operation);
   end
else
   error('Input argument TYPE must be a string or char vector.');
end

%----------------------------------------------------------------------%
function tform = scale(sx,sy)
if nargin < 2
   sy = sx;
end
tform = affine2d([sx 0 0; 0 sy 0; 0 0 1]);

%----------------------------------------------------------------------%
function tform = rotate(angle)
theta = (pi/180) * angle;
T = [ ...
   cos(theta)  sin(theta)  0
   -sin(theta) cos(theta)  0
   0           0           1 ];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = translate(dx,dy)
T = [ ...
   1  0  0
   0  1  0
   dx dy 1 ];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = reflectHorizontal
T = [ ...
   -1  0  0
   0  1  0
   0  0  1 ];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = reflectVertical
T = [ ...
   1  0  0
   0  -1 0
   0  0  1];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = shearVertical(angle_degrees)
alpha = tand(angle_degrees);
T = [ ...
   1 alpha 0
   0 1     0
   0 0     1 ];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = shearHorizontal(angle_degrees)
alpha = tand(angle_degrees);
T = [ ...
   1     0  0
   alpha 1  0
   0     0  1];
tform = affine2d(T);

%----------------------------------------------------------------------%
function tform = compose(varargin)
all_affine = true;
for k = 1:nargin
   if ~(isa(varargin{k},'affine2d') || ...
         isa(varargin{k},'projective2d'))
      error('Input transforms must be affine2d or projective2d.');
   end
   
   if ~isa(varargin{k},'affine2d')
       all_affine = false;
   end
   
end
T = eye(3);
for k = 1:nargin
   tform_k = varargin{k};
   T = T * tform_k.T;
end
if all_affine
    tform = affine2d(T);
else
    tform = projective2d(T);
end
