function m = tifs2movie(file)
%TIFS2MOVIE Create a MATLAB movie from a multiframe TIFF file.
%   M = TIFS2MOVIE(FILE) creates a MATLAB movie structure from a
%   multiframe TIFF file.
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

% Get file info like number of frames in the multi-frame TIFF
info = imfinfo(file);
frames = size(info, 1);

% Create a gray scale map for the UINT8 images in the MATLAB movie
gmap = linspace(0, 1, 256);
gmap = [gmap' gmap' gmap'];

% Read the TIFF frames and add to a MATLAB movie structure.
for i = 1:frames
    [f, fmap] = imread(file, i);
    if (strcmp(info(i).ColorType, 'grayscale'))
        map = gmap;
    else
        map = fmap;
    end
    m(i) = im2frame(f, map);
end
