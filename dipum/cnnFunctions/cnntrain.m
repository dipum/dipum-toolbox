function cnndataout = cnntrain(cnndatain)
%CNNTRAIN Training of convolutional neural network.
%   CNNDATAOUT = CNNTRAIN(CNNDATAIN) Training of convolutional neural
%   network. Type
%
%     >> help cnninfo
%
%   at the prompt for a detailed description of all parameters.
%
%   NOTE: The custoim folder FCNNtoolbox must be in the MATLAB path.
%
%   TRAINING STARTING "FRESH." The inputs to cnntrain are the result of
%   running function cnninit: [cnn,fcnn] = cnninit(cnnparam), whose
%   outputs are the initialized cnn and fcnn. Additional inputs are as
%   listed below.
%
%   cnndatain.cnn = cnn
%   cnndatain.fcnn = fcnnn
%   cnndatain.Images  
%   cnndatain.R 
%   cnndatain.Epochs
%   cnndatain.MiniBatchSize
%   cnndatain.MSE (set to [] initially)
%   cnndatain.SmoothMSE (set to [] initially)
%
%   TRAINING IN MULTISTAGES. 
%   When training takes a long time, it is helpful to train for a
%   manageable number of epochs and then repeat the process, but starting
%   with the last results of training. For this, we make the following
%   modifications in cnndatain before starting the next training session
%   if we want to do another training session without making any changes
%   to any of the cnndatain fields.
% 
%   cnndatain = cnndataout;
%
%   If we want to make changes to any of the fields of structure
%   cnndatain, we make following the preceding line of code. For
%   example, to change the number of epochs and continue training, we
%   write:
%
%   cnndatain = cnndataout;
%   cnndatain.Epochs = some new value;
%
%   The other fields of cnndatain are not changed.
%
%   TRAINING STARTING WITH PRETRAINED CNN/FCNN If, instead of starting
%   with a freshly initialized CNN and FCNN, we want to start training
%   with previously-trained CNN and FCNN, we do it as follows. Suppose
%   that the saved the MATLAB workspace after some training session as
%   SavedCNNFCNN_200Epochs.mat. To continue training where the previous
%   training left off, we write:
%
%   load SavedCNNFCNN_200Epochs.mat 
%   cnndatain = cnndataout;
% 
%   The file SavedCNNFCNN_200Epochs.mat carries with it all the
%   parameters of the last application of cnninit and cnntrain from
%   which they were saved. Any changes in cnndatain, like the number of
%   Epochs, are implemented as explained before.
%
%   The other fields of cnndatain are not changed.
%
%
%   OUTPUTS
%   The outputs of this function in structure cnndataout, with fields: 
%
%   cnndataout.cnn         
%    The complete, trained cnn.
%
%   cnndataout.fcnn         
%    The complete, trained fully-connected net
%  
%   cnndataout.MSE        
%    A vector containing the training MSE error values as a function of
%    epoch.
%
%   cnndataout.SmoothMSE        
%    A smoothed version of cnndataout.MSE
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

% SETUP

% Check input image for size M-by-M-by-depth-by-NI, where M is the
% (square) image size, depth is the image depth (e.g., 1 for grayscale
% images and 3 for RGB images), and NI is the number of images.
if (ndims(cnndatain.Images) ~= 4)
   error('Images have to be of sizeM-by-M-by-depth-by-NI')
end

% cnn and fcnn.
cnn = cnndatain.cnn;
fcnn = cnndatain.fcnn;

% Number of cnn layers.
Lc = numel([cnn.NumLayerKernels]);
% Number of fcnn layers.
L = numel([fcnn.NumNodes]);

% Pixel values must be in the range [0,1].
if (max(cnndatain.Images(:)) > 1) || (min(cnndatain.Images(:)) < 0)
   error('Image pixels must be in the range [0,1]')
end

% The input image array of size M-by-M-by-depth-by-NI, where M is the
% (square) image size, depth is the image depth (e.g., 1 for
% grayscale images and 3 for RGB images), and NI is the number of
% images.
NI = size(cnndatain.Images,4);

% Minibatch size. Defaults to the number of patterns.
if ~isfield(cnndatain,'MiniBatchSize')
   cnndatain.MiniBatchSize = size(cnndatain.R,2);
end
MBS = cnndatain.MiniBatchSize;

% The num of images divided by the minibatch size must be an integer.
if rem(NI,MBS) ~= 0
   error('(num images)/(minibatch size) must be an integer')
end
batchReps = NI/MBS;

% Number of training epochs.
NE = cnndatain.Epochs; 

% Training errors.
MSE = cnndatain.MSE;
SmoothMSE = cnndatain.SmoothMSE;

% TRAIN THE NETWORK.

h = waitbar(0,'Training the CNN . . . .');
for t = 1:NE
   % Randomize the order of the input images.
   r = randperm(NI);
   for j = 1:batchReps
      % Extract a random imagebatch of MBS images from the input images.
      minibatch = cnndatain.Images(:,:,:,r((j - 1)*MBS + 1 : j*MBS));
      
      % Extract the corresponding columns from input.R.
      batchR = cnndatain.R(:,r((j - 1)*MBS + 1 : j*MBS));
      
      % Feedforward through the CNN.
      cnn = cnnff(cnn,minibatch);

      % Feedforward through the FCNN.
      X = cnn(Lc).OutputVectors;
      fcnn = fcnnff(fcnn,X);

      % Backprop through fully-connected net.
      R = batchR;
      fcnn = fcnnbp(fcnn,R);
      
      % Backprop through cnn.
      delback = fcnn(1).D; % del vector fedback from the fcnn.
      cnn = cnnbp(cnn,delback);
      
      % Compute average gradients for the minibatch.
      cnn = cnngradients(cnn);
      
      % Update the cnn weights.
      cnn = cnnupdateweights(cnn);
      
      % Update the fcnn weights.
      fcnn = fcnnupdateweights(fcnn);
      
      % Output error.
      fcnnerror = 0.5*(fcnn(L).A - R);

      % Mean-squared error (MSE) for the current minibatch.
      currentMSE = sum(sum((fcnnerror).^2))/size(fcnnerror,2);   
      
      % Update MSE and SmoothMSE.
      if isempty(MSE) % Initialize at beginning.
         MSE(1) = currentMSE;
         SmoothMSE(1) = currentMSE;
      end
      MSE(end + 1) = currentMSE;
      % For smoothing, you could also use MATLAB function smoothdata,
      % but it tends to be much more aggresive that the following
      % "lowpass" filter which is more local and results in a smoothed
      % function whose shape better preserves the nuances of the raw
      % data. If you prefer to use funcdtion smoothdata you can apply ot
      % externally to function cnndataout.MSE
      SmoothMSE(end + 1) = 0.9*SmoothMSE(end) + 0.1*currentMSE;
 
      waitbar(t/NE)
      
   end
   
end
close(h)

% OUTPUT THE TRAINED CNN, FCNN, AND THE MSE ERROR VECTORS.
% Save original inputs.
cnndataout = cnndatain;
% Update the parameters that changed in this function.
cnndataout.cnn = cnn;
cnndataout.fcnn = fcnn;
cnndataout.MSE = MSE;
cnndataout.SmoothMSE = SmoothMSE;
