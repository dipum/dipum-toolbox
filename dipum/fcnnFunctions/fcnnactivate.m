function [hz,hprimez] = fcnnactivate(z,type)
%FCNNACTIVATE Activation function for FCNNs.
%   [HZ,HPRIMEZ] = FCNNACTIVATE(Z,TYPE) outputs activation values, HZ =
%   h(z), and its derivative, HPRIMEZ = h'(z), evaluated at each element
%   of z, where z is a vector or matrix (see Section 14.5 in DIPUM3E).
%   Recall that the activation value is A = h(z). The type of activation
%   function used is specified in string TYPE, valid values of which
%   are:
%
%   TYPE                            EQUATION IMPLEMENTED
%
%   'sigmoid' (the default)         h(z) = 1./(1 + exp(-z))
%                                   hprime(z) = h.*(1 - h)
%
%   'tanh'                          h(z) = tanh(z)
%                                   hprime(z) = 1 - h.^2
%
%   'ReLU'                          h(z) = max(0,z)
%                                   hprime(z) = 1 for z > 0
%                                             = 0 otherwise
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

% Set default.
if nargin == 1
   type = 'sigmoid';
end

% Set to lower case to reduce possible user case typo errors.
type = lower(type);

% Compute h and hprime as functions of z.
switch type
   case 'sigmoid'
      hz = 1./(1 + exp(-z));
      hprimez = hz.*(1 - hz);
   case 'tanh'
      hz = tanh(z);
      hprimez = 1 - hz.^2;
   case 'relu'
      % Original based on the definition of ReLU. Works well provided
      % that alpha is small enough.
      hz = max(0,z);
      hprimez = zeros(size(z));
      hprimez(z > 0) = 1;
end
