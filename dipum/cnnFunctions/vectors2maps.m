function maps = vectors2maps(vectors,numOutputMaps)
%VECTORS2MAPS Converts vectors to the format of cnn output maps.
%   VECTORS = MAPS2VECTORS(MAPS,NUMOUTPUTMAPS) coverts vectors resulting
%   from backpropagation in a fully-connected neural net (FCN) to the
%   format of the output of a cnn that generated those vectors for
%   feedforward. The vectors are of size (M*M*NumOutputMaps) x
%   (NumImages), where M is the spatial size of the (square) output
%   maps, NumOutputMaps is self explanatory, and numImages is the number
%   of images in the minibatches used in training the cnn. MAPSIZE is
%   the spatial dimension of the (square) output maps in the cnn. MAPS
%   is a cell array of the form maps{j} where j ranges over
%   numOutputMaps. Each cell of cell array maps is an array of class
%   double, of size (M,M,NumImages)
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

% Number of images.
numImages = size(vectors,2);

% Size of the (square) output maps.
M = sqrt(size(vectors,1)/numOutputMaps);

% Initialize cell array maps for loop speed.
maps{numOutputMaps} = [];

% Reshape vectors into maps.
for j = 1:numOutputMaps  
   maps{j} = reshape(vectors(((j - 1)*M*M + 1):j*M*M,:),[M,M,numImages]);
end
