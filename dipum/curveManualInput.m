function [x,y] = curveManualInput(f,varargin)
%curveManualInput Manual input of curve coordinates.
%   In all the following options, instructions for inputting the points
%   are displayed when the function is called.
%
%   [X,Y] = curveManualInput(F) generates the (X,Y) coordinates of
%   points selected interactively from input image F, and displays them
%   as green circles (o) superimposed on F.
%
%   [X,Y] = curveManualInput(F,NP) same as above, but interpolation is
%   used to produce NP equally-spaced (in terms of arc-distance) points.
%   Spline interpolation is used for accuracy, and the resulting curve
%   is closed to form a closed polygon.
%
%	 If a different display other than red circles is desired, use
%   function curveManualInput first to generate the coordinates (X,Y) of
%   the points. Delete the default display of red circles, then use
%   function curveDisplay(X,Y,varargin) to replot the points (X,Y) using
%   one or more of the various options available in that function.
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

% DISPLAY INSTRUCTIONS FOR INPUTTING POINTS.
disp(' ')
disp('INSTRUCTIONS.')
disp('1) PRESS ANY KEY TO BEGIN DATA ENTRY:') 
disp('2) WAIT FOR THE IMAGE DISPLAY-THEN SELECT POINTS WITH THE MOUSE.')
disp('3) WHEN FINISHED, PRESS RETURN TO TERMINATE DATA ENTRY.')
pause;
figure, imshow(f)

% GET THE POINTS INTERACTIVELY.
% Get points interactively. Function myginput is a 3rd-party utility
% function included in your book support package. This function uses a
% (col,row) format, as opposed to the book (row,col) format, thus we
% use (x,y) in the reverse order on the output.
[y,x] = myginput;

% DEFAULT VALUE TO PLOT THE SNAKE AS GREEN CIRCLES.
LineSpec = 'go';


% DETERMINE IF THE CURVE SHOULD BE CLOSED.
if nargin > 1
	% Add one more point to close the curve.
   x(numel(x) + 1) = x(1);
   y(numel(y) + 1) = y(1);
end

% DETERMINE IF INTERPOLATION SHOULD BE DONE.
if nargin > 1
   np = varargin{1};
   % Interpolate to get np, equally-spaced (in terms of arc distance)
   % points. Note the order in which x and y are input. Function
   % interparc is a 3rd-party function included in the book support
   % package.
   p = interparc(np,y,x,'linear'); 
   % interparc outputs values as (c,r), so we extract the values of x
   % and y in the reverse order to match the book (r,c) convention.
   x = p(:,2); 
   y = p(:,1);
end

% DISPLAY THE RESULT 
% First, close the current figure.
close gcf

% Display the image with the curve superimposed on it. Function
% curveDisplay is a DIPUM3E utility function, so its inputs follow the
% book coordinate book convention: (x,y) = (row,col).
figure, imshow(f)
hold on
curveDisplay(x,y,LineSpec,'MarkerFaceColor','w','MarkerSize',3)
hold off
