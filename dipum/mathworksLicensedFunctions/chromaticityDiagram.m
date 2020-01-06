function p = chromaticityDiagram
%chromaticityDiagram Plot chromaticity diagram.
%   chromaticityDiagram plots a chromaticity diagram in a new figure.
%
%   p = chromaticityDiagram returns the patch object used to display the
%   colors inside the spectral boundary.
%
%   Note that many colors in a chromaticity diagram cannot be exactly
%   reproduced on a display or in printed form. This function shows
%   approximate colors suitable for displays based on the sRGB color
%   space.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

% Compute the triangle mesh within the spectral boundary.
[bx,by] = chromaticityBoundary;
t = chromaticityMesh(bx,by);

% Determine the display color for each point in the mesh.
rgb = xy2rgb(t.Points);

% Create a new figure and axes with the desired properties.
[~,ax] = chromaticityFigure;

% Draw the chromaticity colors using a patch.
pp = patch('Faces',t.ConnectivityList,...
   'Vertices',t.Points,...
   'FaceColor','interp',...
   'FaceVertexCData',rgb,...
   'EdgeColor','none',...
   'Parent',ax);

% Draw the grid lines next so that they are above the patch but below
% the spectral boundary, wavelength ticks, and wavelength labels.
for x = ax.XTick
   line([x x],[0 1],'Color','k','LineWidth',0.5,...
      'LineStyle',':',...
      'Parent',ax);
end
for y = ax.YTick
   line([0 1],[y y],'Color','k','LineWidth',0.5,...
      'LineStyle',':',...
      'Parent',ax);
end

% Draw the spectral boundary.
line('XData',bx,'YData',by,'Color',[1 1 1],'LineWidth',1,'Parent',ax);

labelWavelengths(ax);

xlabel('x')
ylabel('y')

if nargout > 0
   p = pp;
end

end

%----------------------------------------------------------------------%
function [fig,ax] = chromaticityFigure
%chromaticityFigure Create and configure chromaticity figure and axes

% Make the figure (and axes) black to increase the contrast with the
% chromaticity colors. Set InvertHardcopy to 'off' so that the figure
% stays black when printed or exported.
fig = figure('Color',[0 0 0],...
   'InvertHardcopy','off');

ax = gca(fig);
ax.Color = [0 0 0];

% Use equal aspect ratio so that visible distances and angles are
% accurate.
axis(ax,'equal');

% Configure the limits and ticks. Leave room to the left of the origin
% for wavelength labels, but do not show ticks or tick labels for values
% less than 0.
ax.XLim = [-0.1 0.8];
ax.YLim = [-0.1 0.9];
ax.XTick = 0:0.1:0.8;
ax.YTick = 0:0.1:0.9;

% Configure ruler and grid colors.
ax.XColor = [1 1 1];
ax.YColor = [1 1 1];
end

%----------------------------------------------------------------------%
function rgb = xy2rgb(xy)
%xy2rgb Convert chromaticity coordinates to RGB values
xyy = zeros(size(xy,1),3);
for k = 1:size(xy,1)
   xyy(k,:) = xy2xyy(xy(k,:));
end

XYZ = xyy2xyz(xyy);
rgb = xyz2rgb(XYZ);
rgb = max(min(rgb,1),0);
end

%----------------------------------------------------------------------%
function [x,y] = chromaticityBoundary
%chromaticityBoundary x-y coordinates of chromaticity boundary diagram

cie_table = readtable('CIE 1931 Standard Observer (1nm).xlsx');
[x,y] = xyz2xyy(cie_table.x,cie_table.y,cie_table.z);

% Remove the unchanging chromaticity values at the end.
x = x(1:339);
y = y(1:339);

% Add extra vertices along the line of purples.
spacing = 0.005;
line_of_purples_length = hypot(x(1)-x(end),y(1)-y(end));
P = round(line_of_purples_length/spacing);
x_fill = linspace(x(end),x(1),P)';
y_fill = linspace(y(end),y(1),P)';
x = [x; x_fill(2:end-1)];
y = [y; y_fill(2:end-1)];

% Close the boundary.
x = [x; x(1)];
y = [y; y(1)];
end

%----------------------------------------------------------------------%
function t = chromaticityMesh(x,y)
%chromaticityMesh Triangular mesh of points within chromaticity diagram

% Make a grid of points inside the chromaticity diagram.
spacing = 0.005;
[x1,x2] = bounds(x);
[y1,y2] = bounds(y);
[xx,yy] = meshgrid(x1:spacing:x2,y1:spacing:y2);
xx = xx(:);
yy = yy(:);
out = ~inpolygon(xx,yy,x,y);
xx(out) = [];
yy(out) = [];

% Add the boundary points to the grid of points. Remove any duplicated
% points. Use the 'first' option in the call to unique so that the
% chromaticity boundary points will stay at the beginning of the sorted
% list of points. The boundary points need to be first so they can be
% used as constraints in the call to delaunayTriangulation below.
xm = [x ; xx];
ym = [y ; yy];
P = [xm ym];
[~, I, ~] = unique(P,'first','rows');
I = sort(I);
P = P(I,:);

% Compute the delaunay triangulation. Constraint it so that the
% triangulation edges include the chromaticity boundary.
N = length(x);
C = [(1:(N-1))' (2:N)'; N 1];
t = delaunayTriangulation(P,C);
end

%----------------------------------------------------------------------%
function xyY = xy2xyy(xy)
%xy2xyy Convert xy values to xyY values.
%   xy2xyy(xy) converts xy values to xyY values. For chromaticity
%   coordinates inside the sRGB gamut triangle, preserve the input xy
%   values and choose a Y value based on interpolation from Y values at
%   the corners, plus two additional Y values. One is chosen along the
%   green-red triangle edge to boost the near Y values higher, producing
%   a visible yellow region. The other is chosen inside the triangle to
%   reduce Y values near the red-blue triangle edge, which helps reduce
%   the visibility of that edge.
%
%   For chromaticity coordinates outside the sRGB gamut triangle, use a
%   blended strategy of gamut mapping. For xy coordinates near the
%   triangle edge, choose the Y value corresponding to the nearest point
%   along the triangle edge. This helps minimize the visibility of the
%   triangle edge by avoiding a sudden shift in Y along the edge. For
%   chromaticity coordinates further away, project the xy coordinate
%   toward the sRGB white point and use the Y value where the projection
%   crosses the triangle. This preserves the spectral hue. Blend these
%   two gamut-mapping strategies smoothly by using a weighted average of
%   them.

persistent f TR Yt
if isempty(f)
   % sRGB chromaticity and Y values
   red_xy = [0.64   0.33];
   red_Y = 0.2126;
   
   green_xy = [0.3    0.6];
   green_Y = 0.7152;
   
   blue_xy = [0.15   0.06];
   blue_Y = 0.0722;
   
   white_xy = [.3127 .3290];
   white_Y = 1;
   
   % Yellow chromaticity and Y values. The xy coordinates were computed
   % by projecting the xy location corresponding to a wavelength of 570
   % nm toward the sRGB white point and intersecting the projection with
   % the green-red triangle edge. The Y value was determined
   % experimentally.
   yellow_xy = [0.416552   0.507444];
   yellow_Y = 0.8;
   
   % Make a triangulation from the sRGB white point, the three triangle
   % corners, and the yellow point, which is on the green-red triangle
   % edge. This triangulation will be used to project out-of-gamut xy
   % points toward the white point.
   P = [white_xy ; red_xy ; green_xy ; blue_xy ; yellow_xy];
   T = [...
      1 2 5              % white - red - yellow
      1 5 3              % white - yellow - green
      1 3 4              % white - green - blue
      1 2 4];            % white - red - blue
   TR = triangulation(T,P);
   
   % Make a vector of Y values in the same order as P, the points in the
   % triangulation.
   Yt = [white_Y red_Y green_Y blue_Y yellow_Y]';
   
   % Make a function for interpolating Y values within the sRGB
   % triangle. Add a point near the red-blue edge to bring down the Y
   % values in that region to help minimize the edge's visibility. Use
   % natural-neighbor interpolation and an extrapolation method of
   % 'none'. With no extrapolation method, Y values outside the sRGB
   % triangle will be returned as NaN, which is convenient for
   % determining that a point is out-of-gamut.
   inside_xy = [0.4 0.26];
   inside_Y = 0.2;
   f = scatteredInterpolant( ...
      [red_xy ; green_xy ; blue_xy ; yellow_xy ; inside_xy], ...
      [red_Y ; green_Y ; blue_Y ; yellow_Y ; inside_Y], ...
      'natural','none');
end

Y = f(xy);
if ~isnan(Y)
   % xy is inside the sRGB triangle. Return xy unchanged, and use the
   % interpolated value for Y.
   xyY = [xy Y];
else
   Nt = size(TR.ConnectivityList,1);
   B = cartesianToBarycentric(TR,(1:Nt)',repmat(xy,Nt,1));
   
   % Determine which triangle to use for the gamut-mapping procedure.
   % Of the triangles with a negative barycentric coordinate
   % corresponding to the white point, use the one with the most
   % nonnegative barycentric coordinates.
   idx = find(B(:,1) < 0);
   num_nonnegative_weights = sum(B(idx,:) >= 0,2);
   [~,nnw_idx] = max(num_nonnegative_weights);
   idx = idx(nnw_idx);
   
   % Find the distance (d) between xy and the line containing the
   % triangle edge corresponding to idx. Find the point (xy1) on the
   % triangle edge nearest to xy. Find Y1 by interpolating along the
   % triangle edge to the location of the nearest point.
   Tk = TR.ConnectivityList(idx,:);
   s1 = TR.Points(Tk(2),:);
   s2 = TR.Points(Tk(3),:);
   p = xy;
   [p0,xy1,t] = closestPointOnLine(s1,s2,p);
   d = norm(p - p0);
   t = min(max(t,0),1);
   Y1 = Yt(Tk(2)) + t*(Yt(Tk(3)) - Yt(Tk(2)));
   
   % Find xy2 and Y2 by projecting from xy toward the white point and
   % finding the intersection with the triangle edge.
   W = B(idx,:);
   W(1) = 0;
   W = W/sum(W);
   xy2 = sum(TR.Points(Tk,:) .* W(:));
   Y2 = sum(Yt(Tk) .* W(:));
   
   % Return a weighted average of [xy1 Y1] and [xy2 Y2]. When close to
   % the triangle edge, favor [xy1 Y1]. The distance threshold for
   % computing the weight was determined experimentally.
   td = 0.2;
   alpha = 1 - (1/td)*min(d,td);
   xyY = [alpha*xy1 + (1-alpha)*xy2, alpha*Y1 + (1-alpha)*Y2];
end
end

%----------------------------------------------------------------------%
function [p0,p0c,t] = closestPointOnLine(s1,s2,p)
%closestPointOnLine Closest point and constrained point on line
%   closestPointOnLine(s1,s2,p) returns the closest point (p0) to p on
%   the line defined by the points s1 and s2. It also returns the
%   closest point (p0c) that is constrained to lie on the line segment
%   defined by s1 and s2. The parameter t satisfies these relationships:
%
%       p0 = s1 + t*(s2 - s1)
%       p0c = s1 + min(max(t,0),1)*(s2 - s1)

v = s2 - s1;
t = sum((p - s1) .* v) / sum(v.^2);
p0 = s1 + t*v;
p0c = s1 + min(max(t,0),1)*v;
end

%----------------------------------------------------------------------%
function labelWavelengths(ax)
%labelWavelengths Label wavelengths on spectral boundary.

lambda = [440 460 480 490 500 510 520 540 ...
   560 580 600 690];

tick_length = 0.02;

for k = 1:length(lambda)
   lambda_k = lambda(k);
   xy = xyz2xyy(lambda2xyz(lambda_k));
   
   % Use complex values as a convenient way to estimate the local
   % tangent slope and normal directions.
   xy = xy(1) + 1i*xy(2);
   v = xyz2xyy(lambda2xyz(lambda_k + 1)) - ...
      xyz2xyy(lambda2xyz(lambda_k - 1));
   v = v(1) + 1i*v(2);
   v = v/abs(v);
   n = v * exp(1i * pi/2);
   
   % Draw the tick.
   xy2 = xy + tick_length*n;
   line('XData',[real(xy) real(xy2)],...
      'YData',[imag(xy) imag(xy2)],...
      'LineWidth',2,...
      'Color','w',...
      'Parent',ax);
   
   % Draw the text label at the appropriate angle.
   text_angle = rad2deg(angle(n));
   if ((90 < text_angle) && (text_angle <= 180)) || ...
         ((-180 <= text_angle) && (text_angle < -90))
      text_angle = text_angle + 180;
      h_align = 'right';
   else
      h_align = 'left';
   end
   xy3 = xy + 1.5*tick_length*n;
   text(real(xy3),imag(xy3),string(lambda_k),'Color','w',...
      'Rotation',text_angle,...
      'HorizontalAlignment',h_align)
end
end
