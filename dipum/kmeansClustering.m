function [L,C] = kmeansClustering(Z,k,Linit,Cinit)
%kmeansClustering Standard kmeans algorithm.
%   [L,C] = kmeansClustering(Z,k,Linit,Cinit) computes cluster labels
%   and cluster centers given the number of desired clusters, k, and
%   data vectors arranged as rows of matrix Z. If the vectors are
%   d-dimensional, and there are nv of them, matrix Z is of size
%   nv-by-d. C is a matrix of size k-by-d, each row of which is a
%   cluster center (mean vector), and L is an nv-by-1 vector, each
%   element of which gives the cluster label from the set {1,2,3,...k}
%   to which each corresponding vector in Z is assigned. For example, if
%   the ith element of L is 4, then the ith vector in Z has been
%   assigned to cluster 4, whose mean (cluster center) is C(4,:). Linit
%   and Cinit are initial labels and cluster center. If provided, the
%   algorithm begins with them. If they are not, the algorithm uses the
%   initialization discussed below. The following code implements the
%   k-means algorithm discussed in Section 11.5. This function is fully
%   vectorized and is very compact--The majority of the following lines
%   of code are comments.
%
%  We initialize the cluster centers by randomly selecting rows from Z,
%  which is appropriate for a fixed value of k. In data analysis, where
%  finding the "best" value of k is important, other methods have been
%  shown to improve performance. See, for example,
%
%  D. Arthur and S. Vassilvitskii, "k-means++: The Advantages of
%  Careful Seeding", Technical Report 2006-13, Stanford InfoLab, 2006. 
%  For an implementation of this approach, see: 
%  https://www.mathworks.com/matlabcentral/fileexchange/28804-k-means
%  
% Number of sample vectors (rows) in Z.
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
nv = size(Z,1);
% Dimension of each vector is size(Z,2).

% Initialize. 
% Seed the random number generator to produce a different random
% sequence each time it is called.
rng('shuffle');
if nargin == 4
   % Labels and cluster centers provided.
   C = Cinit;
   L = Linit;
else
   % Initialize cluster centers as k randomly selected vectors from Z.
   r = randperm(nv);
   idx = r(1:k);
   C = Z(idx,:);
   % Initialize clusterLabels;
   L = zeros(size(Z,1),1);
end

% Assign each vector in Z to the cluster center to which it is closest.
% If more than one minimum occurs, the first one is chosen. Stop when no
% more changes in the assignments occurs.
Lcurrent = ones(size(L));
while any(L ~= Lcurrent)
   % Compute the squared distance (vector norm squared) between every
   % vector in Z and every cluster center. This is needed to implement
   % Eq. (11-33). D(i,j) is the squared distance between the ith row of
   % Z and jth row of C. Because distances are used only for assigning
   % samples to their closest cluster center, working with the squared
   % distances gives the same result, but avoids having to compute
   % square roots.
   D = sqdist(Z,C);
   Lcurrent = L;
   
   % Implement the assignments in Eq. (11-33) The column location of the
   % minimum value of each row of D gives the label of the cluster
   % center closest to the vector in that row of Z.idx 
   [~,L] = min(D,[],2); 

   % Vectorize the updating of cluster centers. The idea is to create a
   % "selection" matrix, S, that chooses which rows of Z are used to
   % implement Eq. (11-34) for a particularly value of i. Vectorizing
   % means that this operation will be done for all i, instead of using
   % loops. The number of columns of S is equal to the k. The jth column
   % is a binary vector, with 1s at the locations of values of L that
   % correspond to rows of Z associated with the jth cluster center. S
   % will have a lot of 0s, so make it a sparse matrix.
   S = sparse(1:nv,L,1,nv,k); % Size nv-by-k
   
   % The product Z'*S will produce a matrix of size k-by-d, the ith row
   % of which will be a cluster center vector, before it is divided by
   % the number of vectors in that cluster. Each diagonal term of the
   % following k-by-k diagonal matrix contains 1/(number of vectors in
   % cluster):
   DIV = spdiags(1./sum(S,1)',0,k,k); % Size k-by-k.
   
   % Cluster centers.
   C = (Z'*S*DIV)';
   
end

%----------------------------------------------------------------------%
function D = sqdist(A,B)
% Computes the squared distances between each row of matrix A and each
% row of matrix B. D(i,j) is the squared distance (squared vector norm)
% between the ith row of A and the jth row of B.
%
% The vectorized method of distance computation used here is explained
% in Section 14.2.
[p,n] = size(A);
q = size(B,1);
D = sum(abs(reshape(A,p,1,n) - reshape(B,1,q,n)).^2,3);



