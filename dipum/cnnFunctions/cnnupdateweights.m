function cnn = cnnupdateweights(cnn)
%CNNUPDATEWEIGHTS Updates the weights and biases of a cnn.
%   CNN = CNNUPDATEWEIGHTS(CNN) Updates the kernel weights and biases of
%   convolutional neural net CNN.
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
Lc = numel([cnn.NumLayerKernels]);

% All the alphas are the same. 
alpha = cnn(1).Alpha; 

% Update cnn weights and biases.
for k = 1:Lc
   for j = 1:cnn(k).NumOutputMaps
      for i = 1:cnn(k).NumInputMaps
         % The following implement Eqs. (14-65) and (14-66) in DIPUM3E.
         cnn(k).Kernel{i}{j} = cnn(k).Kernel{i}{j} - alpha*cnn(k).WeightGradient{i}{j};
      end
         cnn(k).Bias{j} = cnn(k).Bias{j} - alpha*cnn(k).BiasGradient{j};
   end
end
