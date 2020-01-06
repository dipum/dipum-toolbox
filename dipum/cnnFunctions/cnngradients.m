function cnn = cnngradients(cnn)
%CNNGRADIENTS Computes gradients for use in cnn weight updates.
%   CNN = CNNGRADIENTS(CNN) Computes the gradients in Eq. (14-EE); that
%   is, it computes the partial derivatives of the output error with
%   respect to the weights in each layer of the cnn. It also computes
%   the partial derivative of the output error with respect to the
%   biases in each layer (Eq. (14-EE) in DIPUM3E).
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

% NOTE: DIPUM3E utility function flipdims(X) used below flips (rotates
% by 180 degrees) X in all its dimensions. The gradient equations in
% Table 14.11 call for rotation of the input by 180 degrees in the two
% spatial dimensions only. There is no convolution in the third
% dimension, as explained in Section 14.6. However, function conv flips
% its input in all dimensions automatically, as expected in convolution.
% To counteract the auto rotation in the third dimension, we flip the
% input in all dimensions.

% Number of layers.
Lc = numel([cnn.NumLayerKernels]);

% Compute the gradients for the cnn.
for k = 1:Lc
   for j = 1:cnn(k).NumOutputMaps
      for i = 1:cnn(k).NumInputMaps
         % The number of weight and bias gradients is equal to the
         % number of kernel weights and biases, respectively. Because an
         % entire minibatch is being processed, we need to compute the
         % average value of the gradients to be used in updating the
         % weights. This is the reason for the division by
         % size(cnn.Del,3).
         cnn(k).WeightGradient{i}{j} = convn(flipdims(cnn(k).InputMaps{i}),...
                           cnn(k).Del{j},'valid')/size(cnn(k).Del{j},3);
      end
      cnn(k).BiasGradient{j} = sum(cnn(k).Del{j}(:))/size(cnn(k).Del{j},3);
   end
end


