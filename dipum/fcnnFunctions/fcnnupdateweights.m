function fcnn = fcnnupdateweights(fcnn)
%FCNNUPDATEWEIGHTS Update the weights of fully-connected neural net.
%   FCNN = FCNUPDATEWEIGHTS(FCNN]) updates the weights of the
%   fully-connected net, FCNN. The following code implements Step 4 in
%   Table 14.9.
%
%   Type  
%
%    >> help fcninfo
%
%   at the prompt for detailed explanations of the components of the
%   fully-connected neural net.
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
L = numel([fcnn.NumNodes]);

% Learning rate constant.
alpha = fcnn(L).Alpha;

% Update the weights.
for k = 2:L
   fcnn(k).Weights = fcnn(k).Weights - alpha*(fcnn(k).D)*(fcnn(k - 1).A');
   fcnn(k).Biases = fcnn(k).Biases - alpha*sum(fcnn(k).D,2);  
end
