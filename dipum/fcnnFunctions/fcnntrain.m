function [fcnn,fcnndataout] = fcnntrain(fcnn,fcnndatain)
%FCNNTRAIN Train fully-connected neural net.
%   FCNN = FCNNTRAIN(FCNN,FCNNDATAIN) trains a fully
%   connected neural net.
%
%   Type  
%
%    >> help fcnninfo
%
%   at the prompt for detailed explanations of the components of the
%   fully-connected neural net.
%
%   Structure fcnn can be the result of initialization using function
%   fcninit, or it can be an existing fcnn that is to be updated.
%   Structure fcnndatain is as follows (the fields are explained in
%   function fcnninfo):
%
%    fcnndatain.X
%    fcnndatain.R
%    fcnndatain.Epochs
%    fcnndatain.MiniBatchSize (defaults to the number of patterns).
%
%   The output fcnn is trained, so it contains the weights and biases
%   that resulted from training.
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

% Total number of pattern vectors.
NP = size(fcnndatain.X,2);

% Minibatch size. It defaults to the number of patterns in the training
% set.
if ~isfield(fcnndatain,'MiniBatchSize')
   MBS = NP;
else
   MBS = fcnndatain.MiniBatchSize;
end

% The ratio NP/MBS must be an integer (whole number). Function iswhole
% is a DIPUM3E utility function.
if ~iswhole(NP/MBS)
   error('The ratio (num vectors)/(minibatch size) must be an integer.')
end

% Number of training epochs.
NE = fcnndatain.Epochs;

% Begin training.
batchReps = NP/MBS;
h = waitbar(0,'Training FCNN....');

for t = 1:NE
   % Randomize the order of the input vectors.
   r = randperm(NP);
   batchCount = 1;
   for j = 1:batchReps
      % Extract a batch of MBS vectors from the input vectors.
      vectorBatch = fcnndatain.X(:,r((j - 1)*MBS + 1 : j*MBS));
      % Extract the corresponding columns from input.R.
      batchR = fcnndatain.R(:,r((j - 1)*MBS + 1 : j*MBS));
      
      % Feedforward.
      fcnn = fcnnff(fcnn,vectorBatch);
      
      % Backpropagate.
      fcnn = fcnnbp(fcnn,batchR);
      
      % Finished backpropagating the current minibatch. Update the
      % weights.
      fcnn = fcnnupdateweights(fcnn);
         
      batchCount = batchCount + MBS;
      waitbar(t/NE)
   end
      % Compute the MSE for the current epoch.
      fcnndataout.MSE(t) = trainingMSE(fcnn,fcnndatain);
end
close(h)

%----------------------------------------------------------------------%
function mse = trainingMSE(fcnn,fcnndatain)
%trainingMSE Ouput mean squared error per epoch of training.
%   MSE = trainingMSE(FCNN,FCNNDATAIN) computes the mean squared error
%   of the difference A - R, where A is a matrix containing the
%   activation values of the output neurons in the neural network for
%   all the input patterns. R is the class membership matrix for those
%   patterns. The needed quantities in structure fcnndatain are
%   fcnndatain.X and fcnndatain.R.

% If the FCNN was trained with minibatches, the final value of the
% output activation matrix, A, will be valid only for the patterns of
% the last minibatch. To get the MSE per epoch, we have run all the
% patterns through the FCNN to get the values of the output activation
% matrix for those patterns.
fcnn = fcnnff(fcnn,fcnndatain.X); 

% Compute the MSE.
errorMatrix = fcnn(end).A - fcnndatain.R;
mse = sum(sum((errorMatrix).^2))/2;






