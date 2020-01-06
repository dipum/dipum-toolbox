function rgbcube(vx,vy,vz)
%RGBCUBE Displays an RGB cube on the MATLAB desktop.
%   RGBCUBE(VX,VY,VZ) displays an RGB color cube, viewed from point
%   (VX,VY,VZ). With no input arguments, RGBCUBE uses (10,10,4) as the
%   default viewing coordinates. To view individual color planes, use
%   the following viewing coordinates, where the first color in the
%   sequence is the closest to the viewing axis.
%
%      -------------------------------------------------
%           COLOR PLANE                  ( vx,  vy,  vz)
%      -------------------------------------------------
%       Blue-Magenta-White-Cyan          (  0,   0,  10)
%       Red-Yellow-White-Magenta         ( 10,   0,   0)
%       Green-Cyan-White-Yellow          (  0,  10,   0)
%       Black-Red-Magenta-Blue           (  0, -10,   0)
%       Black-Blue-Cyan-Green            (-10,   0,   0)
%       Black-Red-Yellow-Green           (  0,   0, -10)
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

% Set up the parameters for function patch.
vertices_matrix = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
faces_matrix = [1 5 6 2;1 3 7 5;1 2 4 3;2 4 8 6;3 7 8 4;5 6 8 7];
colors = vertices_matrix;
% The order of the cube vertices was selected to be the same as the
% order of the (R,G,B) colors (e.g., (0,0,0) corresponds to black,
% (1,1,1) corresponds to white, and so on.)

% Generate RGB cube using function patch.
patch('Vertices',vertices_matrix,'Faces',faces_matrix, ...
   'FaceVertexCData',colors,'FaceColor','interp', ...
   'EdgeAlpha',0)

% Set up the viewing point.
if nargin == 0
   vx = 10; vy = 10; vz = 4;
elseif nargin ~= 3
   error('Wrong number of inputs.')
end
axis off
view([vx,vy,vz])
axis square
