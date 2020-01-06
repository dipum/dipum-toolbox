function visgeotrans(tform)
%VISGEOTRANS Visualize geometric transformation.
%   VISGEOTRANS(TFORM) displays a visualization of the input
%   geometric transformation.
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

% Color of transformed shape.
dark_green = [28 172 120]/255;

% Color of original shape.
light_gray = [0.9 0.9 0.9];

% Load the coordinates of the shape to be transformed.
d = load('ducky');
x = d.x;
y = d.y;

[tx,ty] = transformPointsForward(tform,x,y);

% Plot original shape into new axes. Turn off the patch edges.
ax = newplot;
p1 = patch(d.x, d.y, light_gray, 'Parent', ax);
p1.EdgeColor = 'none';

% Plot the transformed shape into the same axes. Make the shape
% transparent so the original shape shows through underneath.
p2 = patch(tx, ty, dark_green, 'Parent', ax);
p2.EdgeColor = 'none';
p2.FaceAlpha = 0.7;

% Use a 1:1 horizontal-to-vertical aspect ratio. Reverse the y-axis
% so that down is increasing to make it consistent with image
% display. Put the x- and y-axis rulers at the coordinate system
% origin. Display the rulers and their ticks and tick labels on top
% of the geometric shapes.
axis(ax,'equal')
axis(ax,'ij')
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.Layer = 'top';

