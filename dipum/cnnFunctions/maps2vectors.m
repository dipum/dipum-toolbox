function vectors = maps2vectors(maps)
%MAPS2VECTORS Converts maps in the output of a cnn to vectors.
%   VECTORS = MAPS2VECTORS(MAPS) coverts the MAPS at the output of a
%   convolutional neural net (CNN) and converts them to vectors for
%   input into a fully-connected neural net (FCN). MAPS are in the form
%   of a cell array each cell of which is an array of class double of
%   size M-by-M-by-NumImages where M is the spatial size of the (square)
%   maps, and numImages is the number of images submitted to the system
%   as one minibatch. The number of cells in the cell array is the
%   number of output maps. VECTORS is an array of size
%   (M*M*NumOutputMaps) x (NumImages). Thus, each column of VECTORS is
%   formed by concatenating in the vertical direction all the output
%   maps corresponding to ONE input image. See Fig. 14.FF in DIPUM3E for
%   further details.
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

% The number of cells in equals the number of output maps in the cnn. 
numOutputMaps = numel(maps);

numImages = size(maps{1},3);

% Spatial (M-by-M) size.
M = size(maps{1},1); 

% Construct the vectors by reshaping each feature map into a column.
% This is done for all images at the same time.
vectors = [];
for j = 1:numOutputMaps
   vectors = cat(1,vectors,reshape(maps{j},[M*M,numImages]));
end










