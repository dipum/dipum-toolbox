function movie2tifs(m, file)
%MOVIE2TIFS Creates a multiframe TIFF file from a MATLAB movie.
%   MOVIE2TIFS(M, FILE) creates a multiframe TIFF file from the
%   specified MATLAB movie structure, M.
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

% Write the first frame of the movie to the multiframe TIFF.
imwrite(frame2im(m(1)), file, 'Compression', 'none', ...
    'WriteMode', 'overwrite');

% Read the remaining frames and append to the TIFF file.
for i = 2:length(m)
    imwrite(frame2im(m(i)), file, 'Compression', 'none', ...
        'WriteMode', 'append');
end
