function cnn = cnnbp(cnn,delback)
%CNNBP convolutional neural network backpropagation.
%   CNN = CNNBP(CNN,DELBACK) backpropagation through convolutional
%   neural net. DELBACK is the delta (error) vector resulting from
%   backprogation in the fully-connected net (fcnn) that follows the
%   cnn. This function computes the backprogation of the errors, which
%   are used later to obtain the gradients, and ultimately update the
%   weights (see Table 14.10 in DIPUM3E and functions cnntrain,
%   cnngradients, and cnnupdateweights).
%
%   For a full description of all parameters used in this function,
%   type:
%
%   >> help cnninfo 
%
%   at the prompt. 
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

% Number of convolutional layers. (Enclosing structure
% cnn.NumKernelVolumes with [ ] converts it to a 1-by-Lc vector.)
Lc = numel([cnn.NumLayerKernels]);

% Reshape delback into the shape of the output (pooled) maps in layer
% Lc. The result, pmDel, is the input to the cnn in the reverse
% direction. Function vectors2maps is a DIPUM3E custom function.
pmDel = vectors2maps(delback,cnn(Lc).NumOutputMaps);

% Now upsample pmDel to the size of the feature maps in layer Lc, and
% multiply the result by hprimez. This will be the error propagated back
% through layer Lc, which we denote by cnn(Lc).Del. Local function
% delupsamp does both operations. cnn(Lc).Del is the delta array that
% will be fed into layer Lc - 1 to begin backpropagation.

cnn(Lc).Del = delupsamp(cnn,Lc,pmDel);

% Backpropagate the error through the rest of the network, all the way
% back to point at the output of the first convolution layer. See the
% diagram in Section A of file cnninfo.

% Temp hold for the current error being propagated back.
upsampDel = cnn(Lc).Del; 

for k = Lc-1:-1:1
   % The input to layer k for any value of k in the loop when traveling
   % in the reverse direction is cnn(k + 1).Del, the backpropagated
   % error from layer k + 1. The location in the CNN of this error in
   % layer k + 1 is the input (in the reverse direction) to where
   % convolution is performed in layer k + 1. The next thing to do is to
   % backprop the error to the location of the output (pooled) maps in
   % layer k. That is, we have to obtain pmDel for layer k. This is done
   % by backprop convolution of cnn(k + 1).Del with the rotated kernels
   % from layer k + 1. Local function bpconv performs this operation.
   pmDel = bpconv(cnn,k,upsampDel);
   
   % Upsample pmDel and multiply it by hprime to obtain cnn(k).Del.
   cnn(k).Del = delupsamp(cnn,k,pmDel);
   
   % Update the temp hold for the current error being propagated back.
   upsampDel = cnn(k).Del;

end

%----------------------------------------------------------------------%
function outputDel = delupsamp(cnn,k,inputDel)
% This function does upsampling of the deltas in layer k and arranges
% them in the same format as the output (pooled) maps. It then
% multiplies each delta by the appropriate hprimez. This will bring the
% deltas up to the size of the feature maps in layer k, ready for input
% into backprop convolution in the layer, which is the next step to
% backpropropagate inputDel to the next layer (in the reverse
% direction).

% We are working with square arrays, so only one "zoom" factor is needed
% for replication.
zoomFactor = cnn(k).PoolSize;

% Number of output maps in layer k.
N = cnn(k).NumOutputMaps;

% Preallocate  memory space for cell array outputDel.
outputDel{N} = [];

% Upsample and multiply by cnn.hprimez, which was computed during
% feedforward. The result is cnn(k).Del, which will be the input (in the
% backward direction) to layer k - 1. Upsampling is done using DIPUM3E
% function elemdup, which in turn is based on MATLAB function repelem.
% Function elemdup duplicates the elements of an array according to
% specified zoom factors in each dimension. 

for j = 1:N
   outputDel{j} = cnn(k).hprimez{j}.* ...
                        elemdup(inputDel{j},[zoomFactor,zoomFactor,1]);                      
end

%----------------------------------------------------------------------%
function outputDel = bpconv(cnn,k,inputDel)
% The backprop convolution performed in the current layer of the cnn has
% as his inputs the deltas that have been upsampled to the size of the
% feature maps in the current layer, and the (rotated by 180 degrees)
% kernel of the current layer. The convolution is 'full' instead of
% 'valid' (as we did in feedforward) so that the output of the backprop
% convolution is of the same size and the input maps to the current
% layer. Rather than keeping track of the indices, as we do with
% equations, it is much simpler to think of convolution on a per-layer
% basis, involving the parameters of that layer. This is implemented
% knowing the value of k, and the sizes of the input and output maps for
% that value of k.

% Preallocate memory for loop speed. outputDel is a cell array.
outputDel{numel(cnn(k).OutputMaps)} = [];

% Backprop convolution.
for i = 1:numel(cnn(k).OutputMaps) 
   % Preallocate memory for the backprop convolution, z. The resulting z
   % will be of the same size as the input maps to the current layer
   % because we are doing a 'full' convolution.
   z = zeros(size(cnn(k).OutputMaps{1}));
   for j = 1:numel(cnn(k+1).FeatureMaps)
      z = z + convn(inputDel{j}, rot180(cnn(k+1).Kernel{i}{j}), 'full');
   end
   outputDel{i} = z;
end
       
%----------------------------------------------------------------------%
       
