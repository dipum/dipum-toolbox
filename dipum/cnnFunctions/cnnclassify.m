function cnndataout = cnnclassify(trainedCNN,trainedFCNN,Images,R)
%CNNCLASSIFY classify input images using cnn.
%   CNNDATAOUT = CNNCLASSIFY(trainedCNN,trainedFCNN,IMAGES,R) classifies
%    a set of input images.
%  
%   To see a detailed explanation of all components of the cnn used in
%   this function, type the following at the prompt:
%
%  >> help cnninfo
%  >> help fcnninfo
%
%   Inputs:
%
%   Images
%     Input images to classify. Images are of size
%     M-by-M-by-depth-by-NI, where M is the (square) image spatial size,
%     depth is the image depth (e.g., 1 for grayscale images and 3 for
%     RGB images), and NI is the number of images.
%
%   R             
%     Class membership matrix. This is an optional input that, if
%     provided, allows this function to compute the percent correct
%     classification rate achieved on the input images.
%
%   trainedCNN           
%     A trained cnn. This is the structure cnndataout.cnn out of
%     function cnntrain.
%
%   trainedFCNN          
%     A trained fcnn. This is the structure cnndataout.fcnn out of
%     function cnntrain.
%                    
%   Fields of output structure cnndataout are.
%
%   cnndataout.NeuronActivationValues
%     An NC-by-NI matrix containing the neuron activation values (output
%     of fcn) for all input images. Nc is the number of image classes
%     and NI is the number of input images. The location of the maximum
%     value in a column of this matrix gives the class membership of the
%     image corresponding to that column.
%  
%   cnndataout.ClassificationRate
%     The correct image classification rate, in percent. It can be
%     computed only if R is provided.
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

cnn = trainedCNN;
fcnn = trainedFCNN;

% Check input image for size M-by-M-by-depth-by-NI, where M is the
% (square) image size, depth is the image depth (e.g., 1 for grayscale
% images and 3 for RGB images), and NI is the number of images.
if (ndims(Images) ~= 4)
   error('Images have to be of size M-by-M-by-depth-by-NI')
end

% Number of layers in the CNN.
Lc = numel([cnn.NumLayerKernels]);
% Number of layers in fcnn
L = numel([fcnn.NumNodes]);

% Total number, NI, of images in input array Images. 
NI = size(Images,4);

% BEGIN COMPUTATIONS.

h1 = waitbar(0,'Classifying the inputs . . . .');

% Feedforward through the CNN.
cnn = cnnff(cnn,Images);

% Feedforward through the FCNN. The outputs of the FCNN will be used to
% compute the classification rate.

X = cnn(Lc).OutputVectors;
fcnn = fcnnff(fcnn,X);

% fcnn(L).A contains the neuron activation values at the output of the
% FCNN. Find the maximum value of fcnn(L).A in each of its columns. The
% location of a maximum in a column gives the class of the image
% corresponding to that column.

for jj = 1:NI
   idx = unique(find(fcnn(L).A(:,jj)== max(max((fcnn(L).A(:,jj))))));
   % In case of ties, choose the first one arbitrarily.
   cnndataout.ImageClass(jj) = idx(1);
   waitbar(jj/NI)
end
close(h1)
      
% If R was provided, compute the (correct) classification rate.
if nargin == 4
   numErrors = 0;
   h2  = waitbar(0,'Computing the classification rate . . . .');
   for jj = 1:NI
      idx = find(R(:,jj) == 1); % Class of input image jj.
      if ~isequal(cnndataout.ImageClass(jj),idx)
         numErrors = numErrors + 1;
      end
   waitbar(jj/NI)   
   end
   close(h2)
   cnndataout.ClassificationRate = ((NI - numErrors)/NI)*100;
else
   cnndataout.ClassificationRate = [];
end

% Activation values at the output of the FCNN.
cnndataout.NeuronActivationValues = fcnn(L).A;
