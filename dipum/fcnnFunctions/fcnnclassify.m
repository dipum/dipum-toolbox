function classifieroutput = fcnnclassify(fcnn,X,R)
%FCNNCLASSIFY Fully-connected neural network classifier.
%   CLASSIFIEROUTPUT = FCNNCLASSIFY(FCNN,X,R) uses a feedforward pass
%   through a fully-connected neural net, fcnn, to classify a set of
%   input pattern vectors (rows of X). If the pattern class membership
%   matrix, R, is provided, this function also outputs the percent of
%   patterns classified correctly.
%  
%   Type  
%
%   >> help fcninfo
%
%   at the prompt for detailed explanations of the components of the
%   fully-connected neural net.
%
%   classifieroutput is a structure with the following fields.
%
%   classifieroutput.Class
%    A vector whose number of elements is equal to the number of input
%    patterns. The kth element of this vector gives the number of the
%    class to which the kth vector was assigned (i.e., classified).
%
%   classifieroutput.ClassificationRate
%    A scalar that gives the percent of patterns classified correctly,
%    assuming that classifierinput.R was provided. If this is not the
%    case then classifieroutput.ClassificationRate = [].
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

% INPUTS
np = size(X,2);

% CLASSIFY PATTERNS
% Feedforward.
fcnn = fcnnff(fcnn,X);
% Find the maximum value of fcnn(L).A in each column. The location of a
% maximum in a column gives the class of the pattern corresponding to
% that column. Could also do with softmax to associate a probability
% number with each output, but the net calssificationresult would be the
% same because the largest values of each approach would still
% correspond to the same input patterns.
for j = 1:np
    idx = find(fcnn(end).A(:,j)== max(max((fcnn(end).A(:,j)))));
    classifieroutput.Class(j) = idx;
end

% IF A CLASS MEMBERSHIP MATRIX WAS PROVIDED, USE IT TO COMPUTE THE
% CORRECT CLASSIFICATION RATE.
if nargin == 3
   numErrors = 0;
   % Compute the correct classification rate.
   for j = 1:np
      idx = find(R(:,j) == 1); % Class of input pattern j.
      if ~isequal(classifieroutput.Class(j),idx)
          numErrors = numErrors + 1;
      end
   end
    classifieroutput.ClassificationRate = ((np - numErrors)/np)*100;
else
    classifieroutput.ClassificationRate = [];
end
