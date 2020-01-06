function I = colorseg(varargin)
%COLORSEG Performs segmentation of a color image.
%   S = COLORSEG('EUCLIDEAN',F,T,M) performs segmentation of color image
%   F using a Euclidean measure of similarity. M is a 1-by-3 vector
%   representing the average color used for segmentation (this is the
%   center of the sphere in Fig. 7.39 of DIPUM3E). T is the threshold
%   against which the distances are compared.
%
%   S = COLORSEG('MAHALANOBIS',F,T,M,C) performs segmentation of color
%   image F using the Mahalanobis distance as a measure of similarity. C
%   is the 3-by-3 covariance matrix of the sample color vectors of the
%   class of interest. See function covmatrix for the computation of C
%   and M.
%
%   S is the segmented image (a binary matrix) in which 1s denote object
%   points and 0s denote the background.
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

% Preliminaries.
% Recall that varargin is a cell array.
f = varargin{2};
if (ndims(f) ~= 3) || (size(f,3) ~= 3)
   error('Input image must be RGB.');
end
M = size(f,1); N = size(f,2);
% Convert f to vector format using the custom function imstack2vectors.
f = imstack2vectors(f);
f = double(f);
% Initialize I as a column vector. It will be reshaped later into an
% image.
I = zeros(M*N,1); 
T = varargin{3};
m = varargin{4};
m = m(:)'; % Make sure that m is a row vector.

if length(varargin) == 4 
   method = 'euclidean';
elseif length(varargin) == 5 
   method = 'mahalanobis';
else 
   error('Wrong number of inputs.');
end

switch method
   case 'euclidean'
      % Compute the Euclidean distance between all rows of X and m. See
      % Section 14.2 of DIPUM3 for an explanation of the following
      % expression. D(i) is the Euclidean distance between vector X(i,:)
      % and vector m. 
      D = sqrt(sum(abs(f - m).^2,2));
   case 'mahalanobis'
      C = varargin{5};
      D = mahalanobis(f,C,m);
   otherwise 
      error('Unknown segmentation method.')
end

% Set to 1 the locations in I at which D <= T. These are the segmented
% color pixels.
I(D <= T) = 1;

% Reshape I into an M-by-N image.
I = reshape(I,M,N);  
