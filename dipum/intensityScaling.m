function [g,revertClass] = intensityScaling(f)
%intensityScaling Scale intensities of an image to the full [0 1] range.
%   [G,REVERTCLASS] = intensityScaling(F) scales F to class double with
%   values in the full range [0,1], independently of class(F).
%   REVERTCLASS is a function handle that can be used to convert back to
%   class(F). If the image is multichannel, then the scaling of all
%   channels is with respect to the channel with the highest value.
%
%   To convert any image, im, to the original class of f, use the
%   command im = revertClass(im);
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

% Lookup table.
table = {'uint8',  @im2uint8
         'uint16', @im2uint16
         'int16',  @im2int16
         'logical',@logical
         'double', @im2double
         'single', @im2single};
      
classIndex = find(strcmp(class(f),table(:,1)));

if isempty(classIndex)
   error('Unsupported input image class.');
end

% Return the class of the input image.
revertClass = table{classIndex,2};

% Convert to the full range [0,1], independently of the class of the
% input, using the function mat2gray. This function first subtracts
% min(f(:)) from f so that its minimum value will be 0. It then divides
% all elements of the result by their maximum value, resulting in an
% image whose values are in the range [0,1]. If the image has more than
% one channel (e.g., an RGB image has three), the minimum is over all
% channels, and the maximum is over the result, after the minimum has
% been subtracted from all channels.
g = mat2gray(f);
