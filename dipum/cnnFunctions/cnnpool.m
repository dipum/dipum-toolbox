function ap = cnnpool(a,type,m)
%CNNPOOL Pools (subsamples) the elements of a feature map.
%   AP = CNNPOOL(A,TYPE,m) pools (subsamples) the elements of the
%   feature maps in A over non-overlapping neighborhoods of size
%   m-by-m. Array A is of size sv-by-sh, resulting from convolution
%   and activation. TYPE determines the type of pooling performed:
%   'average', 'max', 'L2', or 'none'. Inputting only A results in
%   'average' pooling over nonoverlapping neighborhoods of size
%   2-by-2. Inputting A and TYPE results in pooling neighborhoods of
%   size 2-by-2.
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

% Defaults.
if nargin == 1
   m = 2;
   type = 'average';
elseif nargin == 2
   m = 2;
end

% Number of 2D feature maps.
lastdim = ndims(a);
if lastdim == 2 % single feature map.
   numFeatureMaps = 1;
else
   numFeatureMaps = size(a,lastdim);
end


% Obtain the pooled feature maps. Use Image Processing Toolbox
% function blockproc to do the processing of nonoverlapping
% neighborhoods.

% Preallocate space for loop speed.
M = size(a,1)/m;
ap = zeros(M,M,numFeatureMaps);

switch type
   case 'average'
      % Implementation using block processing.
      % myfunction = @(block_struct) mean2(block_struct.data);
      % for i = 1:numFeatureMaps
      %   a2D = a(:,:,i);
      %  ap(:,:,i) = blockproc(a2D,[m m],myfunction);
      % end
      % But it runs much faster using convolution. Here we use a box
      % lowpass filter kernel.
      ap = convn(a,ones(m)/m^2,'valid');
      % Subsample.
      ap = ap(1:m:end,1:m:end,:);
   case 'max'
      myfunction = @(block_struct) max(max(block_struct.data));
      for i = 1:numFeatureMaps
         a2D = a(:,:,i);
         ap(:,:,i) = blockproc(a2D,[m m],myfunction);
      end
   case 'L2'
      % L2 pooling is the square root of the sum of the elements
      % in the neighborhood squared.
      myfunction = @(block_struct) sqrt(sum(sum((block_struct.data).^2)));
      for i = 1:numFeatureMaps
         a2D = a(:,:,i);
         ap(:,:,i) = blockproc(a2D,[m m],myfunction);
      end
   case 'none'
      ap = a;
end


