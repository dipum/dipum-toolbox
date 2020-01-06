function fcnn = fcnnbp(fcnn,Rsubset)
%FCNNBP Backpropagation in fully-connected neural net.
%   FCN = FCNNBP(FCNN,Rsubset) backropagation through fully-conected
%   neural network, FCNN. Rsubset is a subset of datain.R determined in
%   training based on the size of the minibatch. The following code
%   implements Step 3 in Table 14.8.
%
%   Type  
%
%   >> help fcninfo
%
%   at the prompt for detailed explanations of the components of the
%   fully-connected neural net.
%  
%   This function computes the backpropagation of the output error. The
%   result is fcnn(k).D, for k = L-1:-1:2. An extra backprop step is
%   taken to generate fcnn(1).D. The extra backprop step brings the
%   backprop output (going in the reverse direction) to the same
%   location as the feedforward output of the fcnn after vectorization.
%   The extra step does not affect any other fcnn functions.
%
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

% Compute fcnn(L).D.
fcnn(L).D = (fcnn(L).A - Rsubset).*fcnn(L).HprimeZ;

% Backpropagation.
for k = L-1:-1:2
   fcnn(k).D = (fcnn(k + 1).Weights'*fcnn(k + 1).D).*fcnn(k).HprimeZ;
end 

% Backprop one more layer (see comments in the help section). Note that
% there is no fcnn(1).HprimeZ because this quantity is related only to
% the fully connected net. This extra step does not affect any other fcn
% functions.
fcnn(1).D = fcnn(2).Weights'*fcnn(2).D;

