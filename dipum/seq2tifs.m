function seq2tifs(s, file)
%SEQ2TIFS Creates a multi-frame TIFF file from a MATLAB sequence.
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

% Write the first frame of the sequence to the multiframe TIFF.
imwrite(s(:, :, :, 1), file, 'Compression', 'none', ...
    'WriteMode', 'overwrite');

% Read the remaining frames and append to the TIFF file.
for i = 2:size(s, 4)
    imwrite(s(:, :, :, i), file, 'Compression', 'none', ...
        'WriteMode', 'append');
end
