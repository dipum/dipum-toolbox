function output = perceptronTrain(input)
%perceptronTrain Training of two-class perceptron.
%   OUTPUT = perceptronTrain(INPUT) training of two-class perceptron. The
%   input and output parameters of are structures defined as follows.
%
%   Parameter input is a structure with the following fields:
%    
%   input.X             A matrix of size n-by-np whose columns are
%                       n-dimensional input pattern vectors, and np is
%                       the number of such vectors. For example, for a
%                       set of 100, 3-element patterns, matrix inputs.X
%                       would be of size 3-by-100. The function augments
%                       the patterns by appending a 1 at the end of all
%                       pattern vectors.
%
%   input.r             Class membership vector of size 1-by-np whose 
%                       kth value is 1 if the pattern vector in the kth
%                       column of X belongs to class c1; otherwise the
%                       kth value of input.r is -1.
%
%   input.Alpha         Learning rate positive scalar that defaults to
%                       0.5.
%                      
%   input.W0            Initial augmented weight vector of size 
%                       (n + 1)-by-1. Its components default to uniform
%                       random numbers in the range [0,1].
%
%   input.NumEpochs     The number of training epochs. Defaults to 100.  
%
%
%   Parameter output is a structure with the following fields.
%  
%   output.W            (n + 1)-by-1 weight vector at completion of
%                       training. This may or not be a solution that
%                       separates the two classes, depending on the
%                       number of epochs specified and whether the
%                       classes are linearly separable.
%
%   output.Convergence  True (1) if training converged and false (0)
%                       otherwise.
%
%   output.ActualEpochs The actual number of epochs of training
%                       executed.
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

% AUGMENT THE PATTERN VECTORS.
% Number of patterns.
np = size(input.X,2);
% Augment the pattern vectors.
X = cat(1,input.X,ones(1,np));

% SET DEFAULTS.
if ~isfield(input,'Alpha')
   input.Alpha = 0.5;
end
if ~isfield(input,'NumEpochs')
   input.NumEpochs = 100;
end   
if ~isfield(input,'W0')
   rng('shuffle');
   input.W0 = rand(size(X,1),1);
end

% INITIALIZATION.
% Make sure that input.W0 is a column vector.
input.W0 = input.W0(:);
% Initial values for loop.
w_last = input.W0;
w = input.W0;
output.ActualEpochs = 0;

% ITERATE.
for I = 1:input.NumEpochs
   output.ActualEpochs = output.ActualEpochs + 1;
   output.Convergence = true;
   for J = 1:np
      % An error has been committed for the Jth pattern if the sign of
      % w'*input.X(:,J) does not match the sign of input.r
      if sign(w'*X(:,J)) ~= input.r(J)
         w = w_last + input.r(J)*input.Alpha*X(:,J);
         output.Convergence = false;
         w_last = w;
      end
   end
   % Exit if convergence was not set to false for an entire epoch.
    if output.Convergence
      output.W = w_last;
      output.ActualEpochs = I;
      break
    end
end
output.ActualEpochs = I;
output.W = w_last;

