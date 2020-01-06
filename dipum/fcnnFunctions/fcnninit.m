function fcnn = fcnninit(fcnnparam)
%FCNINIT Initialize fully-connected neural net.
%   FCNN = FCNINIT(FCNNPARAM) initialiaze fully-connected neural net. In
%   the input, FCNPARAM is a structure whose fields are listed below.
%
%   Type  
%
%    >> help fcninfo
%
%   at the prompt for detailed explanations of all components of the
%   fully connected neural net.
%
%   The fcnn is initialized using three (TWO!!!) input parameters:
%
%    fcnnparam.NumNodes
%    fcnnparam.ActivationFunction (defaults to {'sigmoid'}).
%    fcnnparam.Alpha (defaults to 1.0). Used to initialize the FCNN for
%      training.
% 
%   This function reformats these inputs and defines them as fields of
%   output structure fcnn. It also computes initial random weights and
%   biases and outputs them as fields of fcnn.
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
L = numel([fcnnparam.NumNodes]);

% Initialize structure fcn.NumNodes.
fcnn(L).NumNodes = 0;

% Number of nodes per layer.
for k = 1:L
   fcnn(k).NumNodes = fcnnparam.NumNodes(k);
end

% Defaults.
fcnn = fcnndefaults(fcnn,fcnnparam);

% Initial weights and biases for the fully-connected net.
fcnn = fcnninitweights(fcnn);

%----------------------------------------------------------------------%
function fcnn = fcnndefaults(fcnn,fcnnparam)
% Sets the defaults for the fully-connected net.

% Number of layers.
L = numel([fcnn.NumNodes]);

% Activation function.
if ~isfield(fcnnparam,'ActivationFunction')
   for k = 2:L
       fcnn(k).ActivationFunction = 'sigmoid';
   end
elseif numel(fcnnparam.ActivationFunction) == 1
   if ~iscell(fcnnparam.ActivationFunction)
      error('fcnsparam.ActivationFunction must be specified as a cell array')
   end
   for k = 2:L
      fcnn(k).ActivationFunction = char(fcnnparam.ActivationFunction{1});
   end
else
   if ~iscell(fcnnparam.ActivationFunction)
      error('fcnnparam.ActivationFunction must be specified as a cell array')
   end
   for k = 2:L
      fcnn(k).ActivationFunction = char(fcnnparam.ActivationFunction{k});
   end
end

% Learning rate constant.
if ~isfield(fcnnparam,'Alpha')
   fcnnparam.Alpha = 1.0;
end
for k = 1:L
   % Only one constant, but for consistency is structure notation, we
   % assign the same constant to all layers.
   fcnn(k).Alpha = fcnnparam.Alpha;
end

%----------------------------------------------------------------------%
function fcnn = fcnninitweights(fcnn)
% Initial weights and biases for fully-conected neural network.
%
% Generates random kernel weights in the range [-.5 .5]. All initial
% biases are set to 0. We use a weight scaling method suggested by
% Xavier Glorot and Yoshua Bengio for sigmoid activation: "Understanding
% the difficulty of training deep forward neural networks," Proc. 13th
% Int'l Conf. on Artificial Intellince and Statistics, pp. 249–256,
% 2010.

% For the seed used by rand to be random. 
rng('shuffle'); % Uncomment to use (but comment rng(0,'v5uniform') .
% To always start with the same seed (e.g., for repeatable runs), use
% rng(0,'v5uniform') % Uncomment to use.

% Number of layers.
L = numel([fcnn.NumNodes]);

for k = 2:L   
   % fan_in is the number of neurons in the previous layer. fan_out
   % is the number of neurons in the current layer.
   fan_in = fcnn(k - 1).NumNodes;
   fan_out = fcnn(k).NumNodes;
   fcnn(k).Weights = 2*(rand(fan_out,fan_in) - 0.5)*sqrt(6/(fan_out + fan_in));
   fcnn(k).Biases = zeros(fan_out,1);
end

