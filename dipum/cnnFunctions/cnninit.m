function [cnn,fcnn] = cnninit(cnnparam)
%CNNINIT Initializes convolutional neural network.
%   CNN = CNNINIT(CNNPARAM) The cnn at the output of this function is a
%   structure called cnn. The initial fields for this structure are
%   computed from user specifications provided in structure CNNPARAM
%   whose fields are explained below.
%
%   All variables and constants used to implement the cnn are explained
%   in function cnninfo.m. Type
%
%     >> help cnninfo
%
%   at the prompt for a listing.
%
%   SPECIFYING THE ARCHITECTURE AND PARAMETERS OF THE CONVOLUTIONAL
%   NEURAL NETWORK.
%
%   The architecture and parameters of the cnn are defined by the fields
%   of user-defined structure cnnparam, which is passed to this function
%   as its only input. Several of the field specifications have default
%   values that cnninit implements automatically when the relevant field
%   is not specified. The cnn implemented is based on the model in Fig.
%   14.20 in DIPUM3E). As noted above, all parameters listed below are
%   explained in function cnninfo.
%
%   cnnparam.NumLayerKernels 
%   cnnparam.KernelSize (defaults to 3 for all layers).
%   cnnparam.ActivationFunction (defaults to {'sigmoid'} for all layers).
%   cnnparam.PoolType (defaults to {'average'} for all layers). 
%   cnnparam.PoolSize (defaults to 2 for all layers).
%   cnnparam.Alpha (defaults to 1.0).
%
%   The cnn components formatted from cnnparam, or computed by this
%   function for each layer, are:
%
%   cnn.NumLayerKernels
%   cnn.KernelSize
%   cnn.Kernel (i.e., the weights of each kernel)
%   cnn.Bias   
%   cnn.ActivationFunction
%   cnn.PoolType
%   cnn.PoolSize 
%   cnn.Alpha
%   cnn.InputMaps
%   cnn.InputMapSize
%   cnn.FeatureMaps
%   cnn.FeatureMapSize
%   cnn.OutputMaps
%   cnn.OutputMapSize
%
%   The input maps to layer 1 are the input images. The output maps of
%   all layers are the pooled maps. Input maps for layer k > 1 are the
%   output maps from the previous layer.
%
%   SPECIFYING THE ARCHITECTURE AND PARAMETERS OF THE FULLY-CONNECTED
%   NEURAL NETWORK (FCNN) THAT FOLLOWS THE CNN.
%
%   cnnparam.fcnnHiddenNodes (defaults to 0 implying a linear classifier).
%   cnnparam.fcnnActivationFunction (defaults to {'sigmoid'} for all layers).
%   cnnparam.fcnnAlpha (defaults to 1.0)'
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
 
% Number of layers.
Lc = numel([cnnparam.NumLayerKernels]);

% Initial empty structures.
cnn = [];

% Set cnn and fcnn defaults.
[cnn,fcnn] = setdefaults(cnn,cnnparam);

% The number of feature maps, pooled maps, and output maps in each layer
% is all the same, and equal to the number of kernels in that layer
for k = 1:Lc
   cnn(k).NumFeatureMaps = cnnparam.NumLayerKernels(k);
   cnn(k).NumOutputMaps = cnn(k).NumFeatureMaps;
end

% Make sure array cnninput.Images is formatted properly. That is, to
% avoid ambiguities, cnninput.Images must be a 4-element vector: The
% first two dimensions are the spatial dimensions, the next dimension is
% the depth of the images, and the fourth is the number of images.
if numel(cnnparam.ImageSize) ~= 3
   error('cnnparam.ImageSize must be a 3-element vector')
end

% The number of input maps in layer k = 1 is the depth of the input
% image volume (e.g., depth is 1 for grayscale images and 3 for RGB
% images). That is, a map is a 2D array and, on the input, the size of
% the maps is the spatial size of the images.
cnn(1).NumInputMaps = cnnparam.ImageSize(3);

% Additional parameters for layer 1.
cnn(1).InputMapSize = cnnparam.ImageSize(1); % Images are square.
% Feature maps are obtained by spatial convolution, which determines
% their size.
cnn(1).FeatureMapSize = cnn(1).InputMapSize - cnn(1).KernelSize + 1;
% Output maps are the result of pooling, which determines their size.
cnn(1).OutputMapSize = cnn(1).FeatureMapSize/cnn(1).PoolSize;

% In layers k > 1, the depth of the input maps in layer k is equal to
% the depth of the output maps layer k - 1.
for k = 2:Lc
   cnn(k).NumInputMaps = cnn(k - 1).NumOutputMaps;
end

% Sizes of input and output maps in layers 2,3,...,Lc.
for k = 2:Lc
   % Size of input maps to layer k.
   cnn(k).InputMapSize = cnn(k-1).OutputMapSize;
   % Size of feature maps is determined by convolution.
   cnn(k).FeatureMapSize = cnn(k).InputMapSize - cnn(k).KernelSize + 1;
   % Size of output maps is determined by pooling.
   cnn(k).OutputMapSize = cnn(k).FeatureMapSize/cnn(k).PoolSize;
end

% Check output maps in all layers. Because the size of the inputs as
% they propagate through the cnn decreases, we perform a check to make
% sure that all sizes are proper. The sizes can also depend on ratios
% which have to be integers. 
for k = 1:Lc 
   % Check that output map sizes are integers (whole numbers)
   if rem(cnn(k).OutputMapSize,floor(cnn(k).OutputMapSize)) ~= 0      
          error('Output map size not an integer in layer: %u',k)
   end
   % Check that all output map sizes are positive.
   if cnn(k).OutputMapSize <= 0
      error('Output map size <= 0 in layer: %u',k)
   end
end
% Check that the size of output maps in layer k-1 is not less than the
% kernel size in layer k.
for k = 2:Lc
   if cnn(k-1).OutputMapSize < cnn(k).KernelSize
      error('Input map size is smaller than kernel size in layer: %u',k)
   end
end

% Compute the initial (random) kernel weights and biases for cnn and
% fcnn. 
[cnn,fcnn] = initweights(cnn,fcnn,cnnparam);

%----------------------------------------------------------------------%
function [cnn,fcnn] = setdefaults(cnn,cnnparam)
% Sets default values of the cnn and fcnn based on the given cnnparam.

% Number of layers of the cnn.
Lc = numel([cnnparam.NumLayerKernels]);
% Number of layers of the fcnn. If cnnparam.fcnnHiddenNodes = [ ] (i.e.,
% no hidden layers), the fcnn will be a linear classifier.
L = 2 + numel(cnnparam.fcnnHiddenNodes); 

for k = 1:Lc
   cnn(k).NumLayerKernels = cnnparam.NumLayerKernels(k);
end

% Kernel sizes.
if ~isfield(cnnparam,'KernelSize')
   for k = 1:Lc
       cnn(k).KernelSize = 3;
   end
elseif numel(cnnparam.KernelSize) == 1
    % Set all to specified scalar size.
    for k = 1:Lc
      cnn(k).KernelSize = cnnparam.KernelSize;
    end
else
   for k = 1:Lc
      cnn(k).KernelSize = cnnparam.KernelSize(k);
   end
end

% Activation functions for cnn.
if ~isfield(cnnparam,'ActivationFunction')
   for k = 1:Lc
       cnn(k).ActivationFunction = 'sigmoid';
   end
elseif numel(cnnparam.ActivationFunction) == 1
   if ~iscell(cnnparam.ActivationFunction)
      error('cnnparam.ActivationFunction must be specified as a cell array')
   end
   for k = 1:Lc
      cnn(k).ActivationFunction = char(cnnparam.ActivationFunction{1});
   end
else
   if ~iscell(cnnparam.ActivationFunction)
      error('cnnparam.ActivationFunction must be specified as a cell array')
   end
   for k = 1:Lc
      cnn(k).ActivationFunction = char(cnnparam.ActivationFunction{k});
   end
end
   
% Pooling type.
if ~isfield(cnnparam,'PoolType')
   for k = 1:Lc
       cnn(k).PoolType = 'average';
   end
elseif numel(cnnparam.PoolType) == 1
   if ~iscell(cnnparam.PoolType)
      error('cnnparam.PoolType must be specified as a cell array')
   end
   for k = 1:Lc
      cnn(k).PoolType = char(cnnparam.PoolType{1});
   end
else
   for k = 1:Lc
      cnn(k).PoolType = char(cnnparam.PoolType{k});
   end
end

% Pooling (neighborhood) size.

if ~isfield(cnnparam,'PoolSize')
   for k = 1:Lc
      cnn(k).PoolSize = 2;
   end
elseif numel(cnnparam.PoolSize) == 1
   % Only one size specified. Use for all layers.
   for k = 1:Lc
       cnn(k).PoolSize = cnnparam.PoolSize;
   end
else
   for k = 1:Lc
       cnn(k).PoolSize = cnnparam.PoolSize(k);
   end
end

% Alpha. Although this is a single scalar constant, we reformat it as
% cnn(k).Alpha for consistency in our structure notation.
if ~isfield(cnnparam,'Alpha')
   cnnparam.Alpha = 1.0;
end
for k = 1:Lc
   cnn(k).Alpha = cnnparam.Alpha;
end

% Defaults for the fully-connected net that follows the cnn.

% Alpha. Although this is a single scalar constant, we reformat it as
% fcnn(k).Alpha for consistency in our structure notation.
if ~isfield(cnnparam,'fcnnAlpha')
   cnnparam.fcnnAlpha = 1.0;
end
for k = 2:L
   fcnn(k).Alpha = cnnparam.fcnnAlpha;
end

% Activation functions for the fcnn.
if ~isfield(cnnparam,'fcnnActivationFunction')
   for k = 2:L
       fcnn(k).ActivationFunction = 'sigmoid';
   end
elseif numel(cnnparam.fcnnActivationFunction) == 1
   if ~iscell(cnnparam.fcnnActivationFunction)
      error('cnnparam.ActivationFunction must be specified as a cell array')
   end
   for k = 2:L
      fcnn(k).ActivationFunction = char(cnnparam.fcnnActivationFunction{1});
   end
else
   if ~iscell(cnnparam.fcnnActivationFunction)
      error('cnnparam.fcnnActivationFunction must be specified as a cell array')
   end
   for k = 2:L
      fcnn(k).ActivationFunction = char(cnnparam.fcnnActivationFunction{k});
   end
end
    
%----------------------------------------------------------------------%
function [cnn,fcnn] = initweights(cnn,fcnn,cnnparam)
% Generates random kernel weights in the range [-.5 .5]. All initial
% biases are set to 0. We use a weight scaling method adapted to cnn's
% from the approach suggested by Xavier Glorot and Yoshua Bengio for
% sigmoid activation: "Understanding the Difficulty of Training Deep
% Forward Neural Networks," Proc. 13th Int'l Conf. on Artificial
% Intellince and Statistics, pp. 249–256, 2010.
%
% For the CNN  weights have the form cnn(k).KernelWeights{i}{j} where i
% ranges from 1:numInputMaps and j ranges from 1:numOutputMaps. Thus,
% the total number of kernels in layer k is
% (numInputMaps)*(numOutputMaps), and cnn(k).KernelWeights{i}{j} are the
% weights used in performing convolution with InputMap i to obtain
% OutputMap j. All biases are set to 0 initially. There is a single
% scalar bias per feature map; its form is cnn(k).Bias{j}. 
%
% For the FCNN, weights and biases have the form fcnn(k).Weights and
% fcnn(k).Biases. The biases are initially set to 0. There is a single
% scalar bias per neuron in the FCNN.

% Initialize. 
% Random starting seed. Uncomment to use & comment rng(0,'v5uniform')
rng('shuffle'); 
% Fixed starting seed for repeatable runs.To use, comment rng('shuffle').
% rng(0,'v5uniform') 

% CNN WEIGHTS AND BIASES.
%
% Number of layers. [cnn.NumOutputMaps] is a vector that gives the
% number of output maps in each layer. The length (numel) of this vector
% is equal to the number of layers.
Lc = numel([cnn.NumOutputMaps]);
for k = 1:Lc
   m = cnn(k).KernelSize;
   din = cnn(k).NumInputMaps;
   dout = cnn(k).NumOutputMaps;
   if ~isodd(m)
      error('Kernel dimensions must be odd')
   end
   for j = 1:cnn(k).NumOutputMaps
      % Compute fan_in and fan_out to implement the approach based on
      % the Glorot-Bengio method. fan_in is the number of input maps
      % to layer k multiplied by the area (height*width) of the
      % kernels in layer k. fan_out is the number of output maps
      % multiplied by kernel height*width.
      fan_in = din*m*m;
      fan_out = dout*m*m;
      % Initial weights.
      for i = 1:cnn(k).NumInputMaps
         cnn(k).Kernel{i}{j} = 2*(rand(m,m) - 0.5)*sqrt(6/(fan_in + fan_out));
      end
      % Initial biases.
      cnn(k).Bias{j} = 0;  
   end
end

% FCNN WEIGHTS AND BIASES.

% Number of layers.
if cnnparam.fcnnHiddenNodes == 0
   L = 2; % No hidden layers; fcnn is a linear classifier;
else
   L = 2 + numel(cnnparam.fcnnHiddenNodes);
end

% Number of nodes. The number of input nodes to the cfn is equal to the
% dimensionality of the vectorized cnn output.
inputNodes = cnn(end).NumOutputMaps*(cnn(end).OutputMapSize^2);
% The number of output nodes in the fcnn is equal to the number of
% classes.
outputNodes = cnnparam.NumClasses;
% The number of nodes/layer in the fcnn is the input nodes followed by
% the number of hidden nodes, followed by the output nodes
vector = cat(2,inputNodes, cnnparam.fcnnHiddenNodes, outputNodes);
if vector(2) == 0 % No hidden layers.
   vector = cat(2,inputNodes,outputNodes);
end
for k = 1:numel(vector)
   fcnn(k).NumNodes = vector(k);
end

% Generate initial weights and biases for the fcnn. 
for k = 2:L   
   % fan_in is the number of neurons in the previous layer. fan_out
   % is the number of neurons in the current layer.
   fan_in = fcnn(k - 1).NumNodes;
   fan_out = fcnn(k).NumNodes;
   fcnn(k).Weights = 2*(rand(fan_out,fan_in) - 0.5)*sqrt(6/(fan_out + fan_in));
   fcnn(k).Biases = zeros(fan_out,1);
end

%----------------------------------------------------------------------%

