function fcnn = fcnnff(fcnn,X)
%FCNNFF Feedforward in a fully-connected neural net.
%   FCNN = FCNFF(FCN,X) feed forward of vectors in input X through FCNN.
%   The followinbg code implements Table 14.7.
%
%   Type
%
%   >> help fcnninfo
%
%   at the prompt for detailed explanations of the components of the
%   fully-connected neural net.
%
%   This function computes the activation values at the output of each
%   layer: fcnn(k).A for k = 1,2,...,L. fcnn(1).A is equal to the input
%   matrix, whose columns are the input vectors. fcn(L).A is a matrix,
%   each column of which is the output activation value corresponding to
%   one of the input vectors. fcn(k).A, k = 2,3,...,L - 1, are the
%   outputs (activation values) of the hidden layers.
%
%   This function also computes fcnn(k).HprimeZ, k = 2,3,...,L, the
%   derivative of the activation function for use in backpropagation.
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
L = numel([fcnn.NumNodes]);

% Initialize cell arrays B and Z.
B{L} = [];
Z{L} = [];

% STEP 1.
%
% Form A(1) from the input pattern vectors. See Fig. 14.15.
fcnn(1).A = X;
% Number of pattern vectors.
NP = size(X,2);

% STEP 2.
%
% Feedforward.
for k = 2:L
   B{k} = repmat(fcnn(k).Biases,1,NP);
   Z{k} = fcnn(k).Weights*fcnn(k - 1).A + B{k};
   % HprimeZ is used in backpropagation.
   type = char(fcnn(k).ActivationFunction);
   % Function fcnnactivate is a DIPUM3E custom function.
   [fcnn(k).A,fcnn(k).HprimeZ] = fcnnactivate(Z{k},type);   
end
