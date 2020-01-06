function cnn = cnnff(cnn,minibatch)
%CNNFF Convolutional net network feedforward.
%   CNN = CNNFF(CNN,MINIBATCH) feedforward of MINIBATCH through
%   convolutional neural network CNN. This function is based on the
%   entries in the second row of Table 14.10 in DIPUM3E. 
%
%   Type
%
%   >> help cnninfo
%
%   at the prompt for a definition and explanation of all cnn
%   parameters.
%
%   The inputs to this function are structure cnn, and array minibatch,
%   a subset of images extracted from a training set.
%
%   The structure fields computed by this function for each layer of the
%   cnn are:
%     cnn.InputMaps
%     cnn.OutputMaps   
%     cnn.FeatureMaps   
%     cnn.hprimez           
%     cnn(Lc).OutputVectors.
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

% SETUP.
                        
% Number of convolutional layers. 
Lc = numel([cnn.NumLayerKernels]);

% The minibatch array is of size M-by-M-by-depth-by-MBS, where M is the
% (square) image spatial size, depth is the image depth (e.g., 1 for
% grayscale images and 3 for RGB images), and MBS is the minibacth size
% (i.e., the number of images in the minibatch).

% Number of images in the minibatch.
numImages = size(minibatch,4);

% Image depth.
depth = size(minibatch,3);

% If the input images are multispectral, extract each component image
% from all the images in the minibatch. Input maps to the first layer.
% (Function squeeze eliminates the singleton (3rd) component.) This will
% result in K arrays of size M-by-M-by-numImages, where K = image depth.
% One array will correspond to each multispectral image component.
% First, preallocate space for cell array layerInputMaps.
layerInputMaps{depth} = []; 
for i = 1:depth
   layerInputMaps{i} = squeeze(minibatch(:,:,i,:));
end

% FEEDFORWARD.

for k = 1:Lc
   cnn(k).InputMaps = layerInputMaps;
   for j = 1:cnn(k).NumOutputMaps
      % Preallocate space for loop speed. z is an array of size
      % N-by-N-by-numImages, where N is the size of the square feature
      % maps in layer k.
      N = cnn(k).FeatureMapSize;
      z = zeros(N,N,numImages);
      
      % Convolution.
      for i = 1:cnn(k).NumInputMaps
         z = z + convn(cnn(k).InputMaps{i},cnn(k).Kernel{i}{j},'valid');
      end
 
      % Add bias and activate to obtain the feature maps.
      [hz,hprimez] = cnnactivate((z + cnn(k).Bias{j}),...
                                            cnn(k).ActivationFunction);
      cnn(k).FeatureMaps{j} = hz;
      cnn(k).hprimez{j} = hprimez; % Will use in backpropagation.
   end
   
   % Pooling.
   for j = 1:cnn(k).NumFeatureMaps
      mp = cnn(k).PoolSize;
      cnn(k).OutputMaps{j} = cnnpool(cnn(k).FeatureMaps{j},...
                                                   cnn(k).PoolType,mp);
   end
   
   % Next set of layer input maps.
   layerInputMaps = cnn(k).OutputMaps;
end

% VECTORIZE THE OUTPUT OF THE LAST CNN LAYER USING CUSTOM FUNCTION
% MAPS2VECTORS.
cnn(Lc).OutputVectors = maps2vectors(cnn(Lc).OutputMaps);
