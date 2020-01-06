function [Xran,Rran,order] = patternShuffle(X,R,mode)
%patternShuffle Shuffle pattern vectors. 
%   [Xran,Rran,order] = patternShuffle(X,R,MODE). X is an n-by-np
%   pattern vector matrix, where n is the dimensionality of the
%   patterns, and np is the number of patterns. R is the class
%   membership matrix of size nc-by-np, where nc is the number of
%   pattern classes. The columns of R are binary vector of all 0s,
%   execept that the jth element of the kth column of R is 1 if the kth
%   pattern (column) of X belons to class j. For two-class percetrons, R
%   is a 1-by-np vector whose elements are 1 for class 1 and -1 for
%   class 2.The columns of X and R are shuffled in the same way so that
%   class membership is preserved. If MODE = 'repeat', the pattterns are
%   shuffled in the same manner each time. This is used to repeat
%   results. If MODE  = 'random', the shuffle is different each time the
%   function is called (this is the default). NOTE: The pattern vectors
%   cannot be augmented (i.e., patterns cannot have a 1 appended at the
%   end). To shuffle augmented patterns, remove the appended 1, shuffle,
%   and reintroduce the 1.
%
%   The random ordering is reversible using output parameter order:
%
%   Xrancol(:,order) = Xrancol; 
%
%   This means that we can input X and call the randomnized output also
%   X. Then, if desired, we can recover X from its randomnized version
%   after the latter has been used by setting X(:,order) = X. The same
%   is true for R. Ouput parameter order makes this possible.
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

if nargin == 2 || isequal(mode,'random')
    rng('shuffle')
elseif isequal(mode,'repeat')
    % To reproduce results, set rng to rng(1) or other integer.
    rng(1)
else
    error('Unknown mode')
end
    
% Start processing.  
np = size(X,2);
order = randperm(np);
Xran = X(:,order);
Rran = R(:,order);


