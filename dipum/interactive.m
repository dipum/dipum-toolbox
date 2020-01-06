function [c,r] = interactive()
%INTERACTIVE Illustrates inputs from keyboard and mouse.
%   [C,R] = INTERACTIVE() accepts from the keyboard an image filename of
%   the form 'filename.ext' (with single or double quotes). Upon typing
%   Enter (Return), the function displays the image, and activates
%   crosshairs superimposed on the image. The mouse is used to control
%   the location of the crosshairs. The coordinates [C,R] of the center
%   of the crosshairs are captured by a left click from the mouse. Data
%   acquisition is terminated by typing Enter (Return) on the keyboard.
%   The output, [C,R], consists of two column vectors of size K-by-1,
%   containing the column and corresponding row coordinates,
%   respectively. K is the number of samples taken. This function
%   assumes that the image file is in the MATLAB path.
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
 
% Get image.
disp(' '); % Blank separator line.
imageName = input('Type image file name, then Enter (Return): ');
 
% Read the image from disk.
f = imread(imageName);
 
% Display instructions.
disp(' '); % Blank separator line.
disp('Image and crosshairs will be displayed next. Use the mouse')
disp('to control the location of the crosshairs, and left-click to')
disp('sample the coordinates.')
disp(' '); % Blank separator line.
 
% Message to user:
input('Type Enter (Return) to start AND to stop when finished:');
% Wait for user to type Enter (Return).
 
% Display the image and activate the crosshairs.
figure, imshow(f)
[c,r] = ginput; 
close % Close the image window.
