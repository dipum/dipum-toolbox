function [] = fcnninfo()
%FCNNINFO Parameters and notation of fully-connected neural net. 
%   Background for the terminology and parameters used in all fcnn
%   related functions can be found in Section 14.5 of DIPUM3E. In
%   paticular, see Fig. 14.15.
%
%   This function is used to reduce duplication in the documentation of
%   the various functions used to implement a fully-connected neural net.
%   In those functions, the user is asked to type
% 
%    >> help fcnninfo
%
%   at the prompt for a list of parameters and a detailed explanation of
%   the role they play in each function and in the network.
%
% PARAMETERS FOR SPECIFYING THE ARCHITECTURE OF AN FCNN.
%
%  The fully-connected neural net requires only three (TWO!!!) parameters
%  specified by a user: (1) The number of nodes per layer. (2) The
%  activation function used in each layer. (3) The learning rate
%  constant. These are specified as a structure, fcnnparam, with the
%  following fields.
%
% fcnnparam.NumNodes
%  A vector containing the number of nodes per layer. The number of
%  nodes in the first layer is equal to the dimensionality of the input
%  vectors. The number of nodes in the output layer is equal to the
%  number of pattern classes. The number of hidden layers, and the
%  number of nodes in each is arbitrary. If no hidden layers are
%  specifived, the neural net will act as a linear classifier. Example:
%  fcnnparam.NumNodes = [6 3 2] is an fcnn whose input vectors are
%  6-dimensional, it has one hidden layer with three nodes, and the
%  number of pattern classes it can recognize is two. The number of
%  layers, L, is computed as L = numel([fcnnparam.NumNodes]).
%
% fcnnparam.ActivationFunction
%  A cell array of size L - 1, the kth element of which is a character
%  string giving the activation function to be used in layer k for 2 <=
%  k <= L. Valid activation functions are: 'sigmoid', 'tanh', and
%  'ReLU'. If only one activation function is specified, that activation
%  function is used in all layers. The default when no activation is
%  specified is {'sigmoid'}.
%
% fcnnparam.Alpha
%  The learning rate constant. It defaults to 1.0.
%
% FCNN PARAMETERS COMPUTED BY VARIOUS FUNCTIONS IN THE FCNN TOOLKIT.
% THESE ARE THE VALUES THAT ARE PASSED BACK-AND-FORTH BETWEEN
% FEEDFORWARD, BACKPROPAGATION, AND WHEN THE FCNN IS ULTIMATELY USED FOR
% CLASSIFICATION.
%
%  A fully-connected neural network is defined by a structure named
%  fcnn, whose fields are as follows:
%
%  L denotes the number of layers in the fcnn. k = 1 is the input layer,
%  and k = L is the output layer. Layers 1 < k < L are hidden layers.
%
% fcnn(k).NumNodes           (formatted in func fcnninit from fcnnparam)
%  A 1-by-L vector containing the number of nodes per layer in the fcnn.
%  The number of nodes in the 1st layer, fcnn(1).NumNodes, is equal to
%  the dimension of the input pattern vectors. The number of nodes in
%  the last layer, fcnn(L).NumNodes is equal to the number of pattern
%  classes. The number L of layers is computed as L =
%  numel([fcnn.NumNodes]).
%
% fcnn(k).ActivationFunction (formatted in func fcnninit from fcnnparam)
%  The kth element of a 2-by-Lc cell array giving the type of activation
%  function used in layer k, for 2 <= k <= L. Valid activation functions
%  are: 'sigmoid', 'tanh', and 'ReLU'. If only one activation function
%  is specified in fcnnparam.ActivationFunction, that activation
%  function is used in all layers. The default when no activation is
%  specified is fcnn(k).ActivationFunction = {'sigmoid'} for k =
%  2,...,L.
%
% fcnn(k).Alpha              (formatted in func fcnninit from fcnnparam)
%  The learning rate constant. This is a scalar specified in
%  fcnnparam.Alpha, but for consistency in structure notation, it is
%  converted two a vector, all elements of which are the same:
%  fcnn(k).Alpha = fcnnparam.Alpha for for k = 1,2,...,L.
%
% fcnn(k).Weights   (computed initially in function fcnninit and updated
%                    in function fcnnbp during training)
%  For each layer k, 2 <= k <= L, fcnn(k).Weights is a matrix of size
%  fcnn(k - 1).NumNodes-by-fcnn(k).NumNodes, containing the weights
%  associated with the nodes in layer k.
%
% fcnn(k).Biases    (computed initially in function fcnninit and updated
%                     in function fcnnbp during training)
%  For each layer k, 2 < k <= L, this is a fcnn(k).NumNodes-by-1 vector
%  containing the biases associated with the nodes in layer k.
%
%  fcnn(k).HprimeZ                         (computed in function fcnnff)
%  The output of layer k before activation, 2 <= k <= L. This is a
%  matrix of size fcnn(k).NumNodes-by-NP, where NP is the number of
%  pattern vectors input into the fcnn simultaneously.
%
% fcnn(k).A                                (computed in function fcnnff) 
%  The output (activation) values of layer k, 1 <= k <= L. This is a
%  matrix of size fcnn(k).NumNodes-by-NP, where NP is the number of
%  pattern vectors input into the fcnn simultaneously. fcnn(1).A is
%  equal to the input pattern matrix, and fcnn(L).A is the matrix of
%  output values. Each colum of A are all the output activation values
%  corresponding to one input pattern vector.
%
% fcnn(k).D                                (computed in function fcnnbp)
%  This is the error matrix of layer k, 2 <= k <= L. It is computed
%  during backpropagation and its dimensions are the same as the
%  dimensions of fcnn(k).A. The error matrix and fcnn.HprimeZ are used
%  to update the weights (and biases) for the fcnn. An extra backprop
%  step is taken to generate fcnn(1).D. The extra backprop step brings
%  the backprop output (going in the reverse direction) to the same
%  location as the feedforward output of the cnn after vectorization. No
%  fcnn(1).HprimeZ is computed because this quantity is related only to
%  the fully connected net.The extra step does not affect any other fcnn
%  functions.
%
% APPLICATION-SPECIFIC INPUTS.
%
% fcnndatain.X                                        (provided by user)
%  The input training patterns. This is a matrix of size dim-by-NP where
%  dim = the dimensionality of the patterns and NP = number of pattern
%  vectors. That is, fcnndatain.X(:,k) is the kth input pattern vector.
%
% fcnndatain.R                                        (provided by user)
%  The class membership matrix. This is a matrix of size NC-by-NP, where
%  NC is the number of pattern classes. As explained in Section 14.SS,
%  column fcnndatain.R(:,k) has a 1 in the jth position if the kth
%  pattern vector belongs to class j.
%
% fcnndatain.Epochs                                   (provided by user)
%  The number of training epochs.
%
% fcnndatain.MiniBatchSize                            (provided by user)
%  The minibatch size used during training. The ratio of the number of
%  training patterns to the minibatch size must be an integer (whole
%  number). 
%
% USING THE FCNN AS A CLASSIFIER
%
%  In DIPUM3E, the objective of training a fully-connected net is to use
%  it as a pattern classifier. This task is performed by function
%  fcnnclassifier, which is called as follows:
%
%           classifieroutput = fcnnclassifier(classifierinput)
%
%  where classifierinput and classfieroutput are structures whose fields
%  are explained below.
%
% classifierinput.fcnn                                (provided by user)
%  The fully connected neural net to be used as the classfier.
%  Typically, classifierinput.fcnn = fcnn, the neural net obtained from
%  training.
%
% classifierinput.X                                   (provided by user)
%  Pattern matrix, each column of which is a pattern vector.
%
% classifierinput.R                                   (provided by user)
%  Class membership matrix for the input pattern vectors. This is an
%  optional input that, if provided, will be used to compute the correct
%  classification rate.
%
% OUTPUTS FROM THE VARIOUS FUNCTIONS IN THE fcnn TOOLBOX
%
% fcnndataout.MSE                       (computed in function fcnntrain)
%  The mean-squared error during training, computed as the sum of the output errors squared, divided by 2. This a a vector with (NumInput
%  Patterns)/(MinibactSize)*fcnndatain.Epochs elements.
%
% fcnndataout.SmoothMSE                 (computed in function fcnntrain)
%  Smoothed version of fcnndataout.MSE.
%
% classifieroutput.Class           (computed in function fcnnclassifier)
%  A vector whose nunber of elements is equal to the number of input
%  patterns. The kth element of this vector gives the class to which the
%  kth vector was assigned (i.e., classified).
%
% classifieroutput.ClassificationRate (computed in function fcnnclassifier)
%  A scalar that gives the percent of patterns classified correctly,
%  assuming that classifierinput.R was provided. If this is not the case
%  then classifieroutput.ClassificationRate = [].
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

doc fcnninfo
 




