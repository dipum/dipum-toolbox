function p = colorSwatches(varargin)
%colorSwatches Display a set of colors on individual squares.
%   colorSwatches(colors) displays a set of colors on individual squares
%   arranged in a row. The input matrix, colors, is Px3 for a set of P
%   colors. The columns of P are the red, green, and blue components.
%   Each square is 1.0x1.0, and the squares are separated by a gap of
%   0.5. Note that the squares may appear rectangular because of the
%   aspect ratio of the axes. Use the command "axis equal" to make the
%   squares appear square.
%
%   colorSwatches(colors,gap), where gap is a nonnegative scalar,
%   specifies the gap between each square. By default, gap is 0.5.
%
%   colorSwatches(colors,sz), where sz is a two-element array, arranges
%   the color squares into a grid where sz(1) is the number of rows and
%   sz(2) is the number of columns. By default, sz is [1
%   size(colors,1)]. Colors are arranged in left-to-right, top-to-bottom
%   order.
%
%   Specify both the gap and the grid size using either
%   colorSwatches(colors,gap,sz) or colorSwatches(colors,sz,gap).
%
%   colorSwatches(ax,___) displays the colors in the specified axes.
%
%   p = colorSwatches(___) returns a handle to the patch object
%   containing all the colors.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

narginchk(1,4);

[colors,gap,sz,ax] = parseInputs(varargin{:});

% Compute the (x,y) coordinates for a sz(1)-by-sz(2) grid of square
% patch faces.
N = sz(2);
M = sz(1);
x = [0 1 1 0 0];
x = x + (1+gap)*(0:N-1)';
x = repmat(x,M,1);
x = x';
x = x(:);

M = sz(1);
y = [0 0 1 1 0];
y = repmat(y,1,N);
y = y + (1+gap)*(0:M-1)';
y = y';
y = y(:);
y = max(y) - y; % Negate y-coordinates to arrange colors top-to-bottom.

V = [x y];

num_faces = M*N;
F = [1 2 3 4 5];
offsets = 5*(0:(num_faces-1))';
F = F + offsets;

% Initialize the face_colors matrix with NaNs. If the specified grid
% size has more faces than the number of input colors, these NaNs will
% remain in the face_colors matrix, and so no color will display for
% those faces.
face_colors = nan(num_faces,3);
num_colors = size(colors,1);
Q = min(num_faces,num_colors);
face_colors(1:Q,:) = colors(1:Q,:);

pp = patch('Faces',F,'Vertices',V,...
   'FaceVertexCData',face_colors,...
   'FaceColor','flat',...
   'EdgeColor','none',...
   'Parent',ax);

% Only return the patch object if the function was called with an output
% argument.
if nargout > 0
   p = pp;
end

%----------------------------------------------------------------------%
function [colors,gap,sz,ax] = parseInputs(varargin)
gap = 0.5;
ax = [];
sz = [];

if isgraphics(varargin{1},'axes')
   % colorSwatches(ax,___) syntax. Process first argument and
   % discard it for subsequent argument processing.
   ax = varargin{1};
   varargin(1) = [];
end

% Process and discard the colors argument.
colors = varargin{1};
varargin(1) = [];

while ~isempty(varargin)
   % Look at the remaining input arguments. A scalar is the gap. A
   % two-element vector is the size of the swatch arrangement.
   val = varargin{1};
   if isscalar(val)
      gap = val;
   elseif (numel(val) == 2)
      sz = val;
   else
      error('Unrecognized input argument.')
   end
   varargin(1) = [];
end

% Assign default values for ax and sz if they are not specified.
if isempty(ax)
   ax = newplot;
end

if isempty(sz)
   sz = [1 size(colors,1)];
end