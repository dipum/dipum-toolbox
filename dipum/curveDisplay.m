function curveDisplay(x,y,varargin)
%curveDisplay Display of 2-D curve.
%   curveDisplay(X,Y,LINESPEC) displays the coordinates (x,y) of a CURVE. 
%
%   LineSpec is a character string made from one element from any or all
%   the following 3 columns:
%
%            b     blue          .     point           -     solid
%            g     green         o     circle          :     dotted
%            r     red           x     x-mark          -.    dashdot 
%            c     cyan          +     plus            --    dashed   
%            m     magenta       *     star          (none)  no line
%            y     yellow        s     square
%            k     black         d     diamond
%            w     white         v     triangle (down)
%                                ^     triangle (up)
%                                <     triangle (left)
%                                >     triangle (right)
%                                p     pentagram
%                                h     hexagram
%                           
%
%   A symbol from the first column gives the color, the second is the
%   symbol used in the plot, and the third specifies the type of line
%   used to join the points in the plot. For example, to plot red circles
%   joined by straight lines we speficify the string 'ro-'. To plot just
%   red circles without any connecting lines we specify the string 'ro'.
%   The default for curveDisplay is black dots with no lines.
% 
%   curveDisplay(X,Y,LINESPEC,NAME,VALUE) further modifies the lines and
%   markers using Name,Value pairs. Any Name,Value pairs supported by
%   the PLOT function are allowed, including:
%
%           Name                          Value
%
%        LineWidth         Width (in points) of the line and border
%                          of filled markers (circle, square, diamond,
%                          pentagram, hexagram, and the four triangles
%                          points). The default is 0.5 pt.
%
%          Color           The color of the line. The color can be
%                          specified as an RGB triplet (such as [0.5 1.0
%                          0.8]), a hexadecimal color code (such as
%                          '#FF8800'), a color name (such as 'red'), or
%                          a short color name (listed above in the
%                          description for LineSpec), or 'none'. The
%                          default is 'k' (black).
%
%     MarkerEdgeColor      Color of the marker or the color of the edge
%                          of the marker for filled markers, specified
%                          as described above for the Color parameter.
%                          The default is black, or, if a line is
%                          specified, the same color as the line joining
%                          the markers.
%
%    MarkerFaceColor       The fill color for the filled markers,
%                          specified as described above for the Color
%                          parameter. The default is 'none'.
%
%      MarkerSize          The size of the marker in points. The default
%                          is 7 pt.
%
%  Example: curveDisplay(x,y,'ro-','MarkerFaceColor','g','MarkerSize',4)
%  displays red circles of size 4 pt, connected by red solid line of 0.5
%  pt thick, with the circles filled in green.
%
%	To superimpose the curve on an image, f, use the following syntax:
%	figure, imshow(f)
%	hold on
%	curveDisplay(x,y,varargin)
%	hold off
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

narginchk(2,Inf)
if nargin == 2
   % Default.
   plot(y,x,'.')
else
   if ~isodd(length(varargin))
      error('Wrong number of inputs.');
   end
   plot(y,x,varargin{:});
end
