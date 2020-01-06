function d = bayesgauss(X,C,M,P)
%BAYESGAUSS Bayes classifier for Gaussian patterns.
%   D = BAYESGAUSS(X,C,M,P) computes Bayes Gaussian decision functions
%   of the n-dimensional patterns in the rows of X. C is an array of
%   size n-by-n-by-Nc containing Nc covariance matrices of size n-by-n,
%   where Nc is the number of classes. M is a matrix of size Nc-by-n,
%   whose rows are the corresponding mean vectors. A covariance matrix
%   and a mean vector must be specified for each class. X is of size
%   K-by-n, where K is the number of patterns to be classified. P is a
%   1-by-Nc vector containing the probabilities of occurrence of each
%   class. If P is not included in the argument, the classes are assumed
%   to be equally likely.
%
%   In the output, D is a column vector of length K. Its ith element is
%   the class number assigned to the ith vector in X during
%   classification.
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

% Verify the number of inputs.
narginchk(3,4) 
n = size(C,1); % Dimension of patterns.

% Protect against the possibility that the class number is included
% as an (n + 1)th element of the vectors.
X = double(X(:,1:n));
% Number of pattern classes.
Nc = size(C,3);
% Number of patterns to classify.
K = size(X,1);  
if nargin == 3
   P(1:Nc) = 1/Nc; % Classes assumed equally likely.
else
   if sum(P) ~= 1 
      error('Elements of P must sum to 1.'); 
   end
end
% Compute the determinants.
DM = zeros(1,Nc); % Preallocate memory for loop speed.
for J = 1:Nc 
   DM(J) = det(C(:,:,J)); 
end
    
% Evaluate the decision functions. Note the use of function mahalanobis
% discussed in Section 14.2.
D = zeros(K,Nc); % Preallocate memory for loop speed.
for J = 1:Nc
   Cm = C(:,:,J);
   Mm = M(J,:);
   L(1:K,1) = log(P(J));
   DET(1:K,1) = 0.5*log(DM(J));
   if P(J) == 0
      D(1:K,J) = -inf;
   else
      D(:,J) = L - DET - 0.5*mahalanobis(X,Cm,Mm);
   end
end

% Find the coordinates of the maximum value in each row. The location of
% a maximum gives the class of the corresponding pattern vector.
[i,j] = find(D == max(D,[],2));

% Re-use X. Its first element in a row is the pattern number, and the
% second is the class to which the pattern was assigned.
X = [i,j]; 

% Eliminate multiple classifications of the same patterns. Since the
% class assignment when two or more decision functions give the same
% value is arbitrary, we need to keep only one. Function unique
% eliminates duplicates and returns the array sorted by rows. This
% re-establishes the original order of the patterns.
[~,idx] = unique(X(:,1));
X = X(idx,:);
% X is now sorted, with the 2nd column giving the class of the pattern
% number in the 1st col.;  i.e., X(j,1) refers to the jth input pattern,
% and X(j,2) is its class number.

% Output the result of classification. d is a column vector with length
% equal to the total number of input patterns. The elements of d are the
% classes into which the patterns (in their original order) were
% classified.
d = X(:,2);

      
