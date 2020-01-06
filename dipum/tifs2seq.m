function s = tifs2seq(file)
%TIFS2SEQ Create a MATLAB sequence from a multi-frame TIFF file.
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

% Get the number of frames in the multi-frame TIFF.
frames = size(imfinfo(file), 1);

% Read the first frame, preallocate the sequence, and put the first
% in it.
i = imread(file, 1);
s = zeros([size(i) 1 frames], 'uint8');
s(:,:,:,1) = i;

% Read the remaining TIFF frames and add to the sequence.
for i = 2:frames
    s(:,:,:,i) = imread(file, i);
end
