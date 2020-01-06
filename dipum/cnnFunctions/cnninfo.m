function [] = cnninfo()
%CNNINFO Parameters and notation of convolutional neural net. 
%   Background for the terminology and parameters used in all cnn
%   related functions can be found in Section 14.SS of DIPUM3E. In
%   particular, see Fig. 14.FF.
%
%   This function is used to reduce duplication in the documentation of
%   the various functions used to implement a convolutional neural net.
%   In those functions, the user is asked to type
% 
%     help fcnninfo
%
%   at the prompt for a list of parameters and a detailed explanation of
%   the role they play in the network.
%
%
% CONTENTS OF THIS DOCUMENT.
%  A. Background.
%  B. Parameters for specifying the CNN.
%  C. Parameteres needed to define the fully-connected neural net (fcnn). 
%  D. Application-specific inputs.
%  E. Application-specific outputs computed by function cnntrain.
%  F. Application-specific outputs computed by function cnnclassifier.
%  G. Example
%  H. Detailed list of parameters computed by various functions in the 
%     cnn Toolbox. 
%
%
% A. BACKGROUND
%
% For purposes of indexing, we will treat each layer in our cnn
% architecture as consisting of the following elements:
%
% InputMaps->|Conv + Bias->Activation->FeatureMaps->Pooling->|OutputMaps
%            |<--   Operations performed in each layer    -->|
%
%  The input maps to the first layer are multispectral images, of which
%  grayscale images are a special case. The output maps of all layers
%  are pooled feature maps (see Section 14.6 in DIPUM3E). The input maps
%  to layer k (k > 1) are the output maps from the previous layer. The
%  output maps in the last layer are vectorized and used as the input to
%  the fully-connected neural net that follows the cnn. 
%
%  Layers for 1 < k < Lc are called hidden layers (Lc is the number of
%  convolutional layers in the cnn). Here, k refers to the kth layer,
%  including all its components as detailed in the preceding diagram.
%  The individual components of a layer are MATLAB structures. The names
%  of the structure fields identify the function performed by the
%  various components of the cnn.
%
%  Some functions in the CNN Toolkit utilize minibatch processing, in
%  the sense that they processes all the images in a minibatch at the
%  same time. For backpropagation this means that a minibatci is
%  processed before the weights and biases are processed.
%
%
% B. PARAMETERS FOR SPECIFYING THE CNN.
%
%  The complete cnn is defined by eight parameters specified by the user
%  as fields of a structure named "cnnparam," as follows.
%
%  Note: Lc denotes the number of layers in the cnn. It is computed from
%  cnnparam.NumLayerKernels, as shown below.
%
% cnnparam.ImageSize
%  A three-element vector, the first two elements of which give vertical
%  and horizontal spatial dimensions (these are always equal in this
%  implementation). The third element is the image depth (e.g., 1 for
%  grayscale images, 3 for RGB images, 6 for 6-band multispectral
%  images).
%
% cnnparam.NumClasses
%  A scalar equal to the number of image pattern classes the cnn is
%  expected to be able to classify.
%
% cnnparam.NumLayerKernels  
%  A vector of size 1-by-Lc containing the number of kernels in each
%  layer of the cnn. The length (numel) of the vector gives the number
%  of layers in the cnn: Lc = numel([cnnparam.NumLayerKernels]). In a
%  layer, the number of feature maps and pooled maps is equal to the
%  number of kernels in that layer.
%
% cnnparam.KernelSize
%  A vector of size 1-by-Lc, the kth element of which gives the (square)
%  size of the kernels in layer k. All kernels in a layer are of the
%  same (odd) size, but sizes can vary from layer to layer. Specifying a
%  single scalar sets all kernels of the cnn to that size. The default
%  is 3, indicating 3-by-3 kernels in all layers.
%
% cnnparam.ActivationFunction
%  A cell array of size 1-by-Lc, the kth element of which is a character
%  string indicating the activation function to be used in layer k for 1
%  <= k <= Lc. Valid activation functions are: 'sigmoid', 'tanh', and
%  'ReLU'. If only one activation function is specified, that activation
%  function is used in all layers. The default when no activation is
%  specified is {'sigmoid'}.  When using 'ReLU' activation,  it is
%  advisable to decrease the value used for the learning rate constant,
%  Alpha (see below).
%
% cnnparam.PoolType
%  A cell array of size 1-by-Lc, the kth element of which is a character
%  string indicating the type of pooling used in layer k. Valid values
%  are: 'average', 'max', and 'L2'. If only one string is specified, it
%  is used for all layers. The network default is 'average' for all
%  layers.
%
% cnnparam.PoolSize
%  A vector of size 1-by-Lc the kth element of which is the (square)
%  size of the pooling neighborhood used in layer k. If a single scalar
%  is specified, the same size is used for all layers. The network
%  default is 2, indicating that a 2-by-2 neighborhood is used in all
%  layers. The ratios of the size of the feature maps to their
%  corresponding pooling neighborhood sizes must be integers.  For no
%  pooling in a layer, specify a pool size of 1 for that layer.
%
% cnnparam.Alpha
%  The learning rate constant  for the cnn. It defaults to 1.0.
%
%  Note: The initial biases are set to 0, and the weights are
%  uniformly-distributed random numbers in the rangle [0,1]. By default,
%  the starting seed for the random number generator is also random. If
%  a fixed seed value is desired (e.g., to generate repeatable results),
%  the initial setting settings are well documented in function cnninit.
%  The required change only requires commenting and decommenting two
%  lines of code.
%
%
% C. PARAMETERS NEEDED TO DEFINE THE FULLY-CONNECTED NEURAL NET.
%
%  The CNN is followed by a fully-connected neural net (fcnn) (see Fig.
%  14.20 in DIPUM3E). The following three paramenteres are required to
%  do this (L is the total number of layers in the fcnn):
%
% cnnparam.fcnnHiddenNodes
%  A vector containing the number of hidden nodes per layer in the fcnn.
%  For example, letting cnnparam.fcnnHiddenNodes = [6 9 7] specifies an
%  fcnn with three hidden layers, containing respectively 6, 9, and 7
%  nodes. The total number, L, of layers is 2 + the number of hidden
%  layers. Setting cnnparam.fcnnHiddenNodes = [ ] indicates no hidden
%  layer, resulting in an fcnn that is a linear classifier. The
%  characteristics of the input and output layers are computed
%  automatically by function cnninit, depending on the architecture of
%  the cnn, and the number of image pattern classes.
%
% cnnparam.fcnnActivationFunction
%  A cell array of size L - 1, the kth element of which is a character
%  string indicating the activation function to be used in layer k, for
%  2 <= k <= L. Valid activation functions are: 'sigmoid', 'tanh', and
%  'ReLU'. If only one activation function is specified, that activation
%  function is used in all layers. The default is {'sigmoid'} in all
%  layers.
%
% cnnparam.fcnnAlpha
%  The learning rate constant for the fcnn. It defaults to 1.
%
%
% D. APPLICATION-SPECIFIC INPUTS.
%
%  Application specific inputs to the cnn are via structure cnndatain,
%  which has the following fields:
%
% cnndatain.Images
%  This is the input image array of size M-by-M-by-depth-by-NI, where M
%  is the (square) image size, depth is the image depth (e.g., 1 for
%  grayscale images and 3 for RGB images), and NI is the number of
%  images.
%
% cnndatain.R
%  The class membership matrix. This is a matrix of size NC-by-NI, where
%  NC is the number of pattern classes. As explained in Section 14.5,
%  column ccndatain.R(:,k) has a 1 in the jth position if the kth
%  pattern vector belongs to class j.
%
% cnndatain.Epochs
%  The number of training epochs.
%
% cnndatain.MiniBatchSize
%  The number, MBS, of images fed to the cnn for processing before the
%  weights and biases are updated. The ratio NI/MBS must be an integer
%  (whole number). The total number of times the weights are updated is
%  (NI/NB)*(Number of Epochs). If MBS = 1, then the weights are updated
%  after every image is presented to the network. This is called on-line
%  training (the name stochastic training is used also). If MBS = NI,
%  then the weights are updated after all the images have been fed
%  through the network one time (i.e. after one epoch is completed).
%  This is called batch training. If 1 < NB < NI, the process is called
%  mini-batch training. Typically, we choose NB << NI, subject to the
%  ratio mentioned above. The default is specs.MinibatchSize = NC, the
%  number of classes.
%
% cnndatain.MSE
%  The training MSE. It is set to [] initially or to its last value for
%  training in stages or from saved training results.
%
% cnndatain.SmoothedMSE
%  A smoothed version of cnndatain.MSE. It is set to [] initially or to
%  its last value when training in stages or from saved training
%  results.
%
% E. APPLICATION-SPECIFIC OUTPUTS COMPUTED BY FUNCTION CNNTRAIN
%
%  Application specific outputs of the cnn toolbox are organized in
%  structure cnndataout, which has the following fields.
%
% cnndataout.cnn
%  The complete cnn resulting from training.
%
% cnndataout.fcnn
%  The fully-connected neural network learned during training.
%
% cnndataout.MSE
%  A vector whose elements are the training MSE errors per epoch.
%
% cnndataout.SmoothMSE
%  A vector whose elements are the smoothed values of cnndataout.MSE,
%  using a simple running "lowpass" filter newvalue = 0.9*previousvalue +
%  0.1*currentvalue. By smoothing epoch-to-epoch irregularities,
%  smoothing gives a result that is easier to interpret graphically.
%
%
% F. APPLICATION-SPECIFIC OUTPUTS COMPUTED BY FUNCTION CNNCLASSIFY
%
% cnndataout.NeuronActivationValues
%  An NC-by-NI matrix containing the outputs (activation values) of the
%  neurons in the fully-connected net. NC is the number of image classes
%  and NI is the number of input images. The location of the maximum
%  value in a column of this matrix gives the class membership of the
%  input image corresponding to that column.
%
% cnndataout.ClassificationRate
%  The image classification rate, in percent. It can be computed only if
%  cnndatain.R is provided.
%
%
% H. DETAILED LIST OF PARAMETERS COMPUTED BY VARIOUS FUNCTIONS IN
%    THE CNN TOOLKIT.
%
%  The convolutional neural network implemented by this code is a
%  structure named cnn, whose fields are as follows.
%
% cnn(k).NumLayerKernels       (formatted in func cnninit from cnnparam)
%  The kth element of a vector of size 1-by-Lc containing the number of
%  kernels in layer k. The length (numel) of the vector gives the number
%  of layers in the cnn: Lc = numel([cnn.NumLayerKernels]). In a layer,
%  the number of feature maps and pooled maps is equal to the number of
%  kernels in that layer.
%
% cnn(k).KernelSize            (formatted in func cnninit from cnnparam)
%  The kth element of a vector of size 1-by-Lc. Scalar cnn(k).KernelSize
%  gives the (square) size of the kernels in layer k. All kernels in a
%  layer are of the same (odd) size, but sizes can vary from layer to
%  layer. Specifying a single scalar sets all kernels of the cnn to that
%  size. The default is 3, indicating 3-by-3 kernels in all layers.
%
% cnn(k).ActivationFunction    (formatted in func cnninit from cnnparam)   
%  The kth element of a 1-by-Lc cell array giving the type of activation
%  function used in layer k. Valid values are: 'sigmoid', 'tanh', and
%  'ReLU'. If only one string is specified, it is used for all layers.
%  The network default is {'sigmoid'}. The same type of activation is
%  used in all computations in a layer, but the activation can be
%  different from layer to layer.
% 
% cnn(k).PoolType              (formatted in func cnninit from cnnparam)
%  The kth element of a 1-by-Lc cell array of strings defining the type
%  of pooling used in layer k. Valid values are: 'average', 'max', and
%  'L2'. If only one string is specified, it is used for all layers. The
%  network default is {'average'} for all layers. This pooling type runs
%  significantly faster than the other two in our implementation.
%
% cnn(k).PoolSize              (formatted in func cnninit from cnnparam)
%  The kth element of a vector of size 1-by-Lc containing the (square)
%  size of the pooling neighborhood in all layers. Thus, cnn(k).PoolSize
%  is a scalar equal to the size of the pooling neighborhood in layer k.
%  If a single scalar is specified, the same size is used for all
%  layers. The network default is 2, indicating that a 2-by-2
%  neighborhood is used in all layers. The ratios of the size of the
%  feature maps to their corresponding pooling neighborhood sizes must
%  be integers (whole numbers).  For no pooling in any layer, specify a
%  pooling size of 1 for that layer.
%
% cnn(k).Alpha                 (formatted in func cnninit from cnnparam)
%  The learning rate constant (defaults to 1.0) used by the cnn. It is
%  specified as a single constant for the entire cnn but it is expressed
%  as a vector for consistency in the notation used for structures.
%
% cnn(k).Kernel{i}{j}            (computed initially in function cnninit 
%                                 and updated in function cnnbp)
%  The kernel that is convolved with the ith pooled map in layer k - 1,
%  to produce the jth feature map in layer k.
%   
% cnn(k).Bias{j}                 (computed initially in function cnninit 
%                                 and updated in function cnnbp)
%  A scalar equal to the bias for the jth feature map in layer k. There
%  is a single scalar bias for each feature map. All biases are set to 0
%  initially.
%
% cnn(k).hz{j}                              (computed in function cnnff)              
%  The result of activation that results in the jth feature map in layer
%  k. This is a matrix of the same size as the feature maps. Computed
%  during feedforward.
%   
% cnn(k).hprimez{j}                         (computed in function cnnff)   
%  The derivative of cnn(k).hz{j}. cnn(k).hprimez{j} is of the same size
%  as cnn(k).hz{j}. Computed during feedforward for use in
%  backpropagation.
%
% cnn(k).FeatureMaps{j}                     (computed in function cnnff)          
%  The maps in kayer k, computed during feedforward for each image in
%  the input minibatch. Here, j ranges from 1 to the number of images in
%  the minibatch. That is, we compute all the feature maps corresponding
%  to all the images in the minibatch.
%
% cnn(k).FeatureMapSize                   (computed in function cnninit)
%  A scalar for each value of k, equal to the size of the square feature
%  maps (FM's) in layer k. All FM's in a layer are of the same size.
%
% cnn(k).OutputMaps{j}                      (computed in function cnnff)
%  The output maps are pooled feature maps, obtained by subsampling
%  cnn(k).FeatureMaps{j} using the pooling type and neighborhood size
%  specified in cnn(k).PoolType and cnn(k).PoolSize, respectively. The
%  number of output maps is equal to the number of feature maps.
%                      
% cnn(k).OutputMapSize                    (computed in function cnninit)
%  A scalar for each value of k, equal to the size of the square pooled
%  maps (PMs) in layer k. All PM's in a layer are of the same size.
%
% cnn(k).InputMaps                        (computed in function cnninit)
%  When k = 1, the input maps are the input images and the output maps
%  are the pooled maps of layer 1. For k > 1, the inputs are the pooled
%  maps of layer k - 1 and the output maps are the pooled feature maps
%  of layer k. 
%
% cnn(k).OutputMapSize                    (computed in function cnninit)
%  A scalar for each value of k equal to the size of the output maps for
%  layer k. The ouput maps of any layer are the pooled feature maps for
%  that layer.
%
% cnn(end).OutputVectors                    (computed in function cnnff)               
%  Vectorized form of the components of the last PM's, as explained in
%  Fig. 14.20 of DIPUM3E. There is one output vector for each image
%  in the minibatch. These vectorS are input into the fully-connected
%  neural (fcnn) net that follows the cnn.
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

doc cnninfo
