function [X,Y,R] = im2minperpoly(I,cellsize)
%IM2MINPERPOLY Minimum perimeter polygon.
%   [X,Y,R] = IM2MINPERPOLY(I,CELLSIZE) outputs in column vectors X and
%   Y the coordinates of the vertices of the minimum perimeter polygon
%   circumscribing a single binary region or a (nonintersecting)
%   boundary contained in binary image I. The background in I must be 0,
%   and the region or boundary must have values equal to 1. If instead
%   of an image, I, a list of ordered vertices is available, link the
%   vertices using function connectpoly and then use function bound2im
%   to generate a binary image I containing the boundary.
%
%   R is the region extracted from the image, from which the MPP is
%   computed (see Figs. 13.6(c) and 13.7(e)). Displaying this region is
%   a good approach for determining interactively a satisfactory value
%   for CELLSIZE. Parameter CELLSIZE is the size of the square cells
%   that enclose the boundary of the region in I. The value of CELLSIZE
%   must be a positive integer greater than 1. The algorithm is
%   explained in DIPUM3E and in Gonzalez and Woods [2018].
%
%   The (X,Y) coordinate system is as defined in Chapter 2. It is a
%   right-handed image coordinate system with the origin at the top
%   right, positive the X-axis extending vertically down, and the Y-axis
%   extending to the right.
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
if cellsize <= 1
   error('cellsize must be an integer > 1.'); 
end
% Check to see that there is only one object in B.
[I,num] = bwlabel(I);
if num > 1
   error('Input image cannot contain more than one region.')
end

% Extract the 4-connected region encompassed by the cellular
% complex. See Fig. 13.7(e) in DIPUM3E.
R = cellcomplex(I,cellsize);

% Find the vertices of the MPP.
[X,Y] = mppvertices(R,cellsize);

%----------------------------------------------------------------------%
function R = cellcomplex(I,cellsize)
% Computes the cellular complex surrounding a single object in binary
% image I, and outputs in R the region bpounded by the cellular complex,
% as explained in DIPUM3E Figs. 13.6(c) and 13.7(e). Parameter CELLSIZE
% is as explained earlier.

% Fill the image in case it has holes and compute the 4-connected
% boundary of the result. This guarantees that will be working with a
% single 4-connected boundary, as required by the MPP algorithm. Recall
% that in function bwperim the default connetivity is 4.
I = imfill(I,'holes');
I = bwperim(I,4); 
[M,N] = size(I);

% Increase image size so that the image is of size K-by-K with (a) K >=
% max(M,N), and (b)  K/cellsize = a power of 2.
K = nextpow2(max(M,N)/cellsize);
K = (2^K)*cellsize;
    
% Increase image size to the nearest integer power of 2, by appending
% zeros to the end of the image. This will allow quadtree
% decompositions as small as cells of size 2-by-2, which is the smallest
% allowed value of cellsize.
M1 = K - M;
N1 = K - N;
I = padarray(I,[M1,N1],'post'); % I is now of size K-by-K

% Quadtree decomposition.
Q = qtdecomp(I,0,cellsize); 

% Get all the subimages of size cellsize-by-cellsize.
[vals,r,c] = qtgetblk(I,Q,cellsize);

% Find all the subimages that contain at least one black pixel. These
% will be the cells of the cellular complex enclosing the boundary.
idx = find(sum(sum(vals(:,:,:)) >= 1));
numsub = length(idx);
x = r(idx);
y = c(idx);

% [x',y'] is an numsub-by-2 array. Each member of this array  is the left,
% top corner of a black cell of size cellsize-by-cellsize. Fill the
% cells with black to form a closed border of black cells around
% interior points. These are the cells of the cellular complex.
for k = 1:numsub
   I(x(k):x(k) + cellsize - 1,y(k):y(k) + cellsize - 1) = 1;
end
BF = imfill(I,'holes');

% Extract the points interior to the cell border. This is the region, R,
% around which the MPP will be found.
I = BF & (~I);
R = I(1:M,1:N); % Remove the padding and output the region.

%----------------------------------------------------------------------%
function [X,Y] = mppvertices(R,cellsize)
%   Outputs in column vectors X and Y the coordinates of the vertices of
%   the minimum-perimeter polygon that circumscribes region R. This is
%   the region bounded by the cellular complex. It is assumed that the
%   coordinate system used is as defined in Chapter 2 of the book, in
%   which the origin is at the top, left, the positive x-axis extends
%   vertically down from the origin and the positive y-axis extends
%   horizontally to the right. No duplicate vertices are allowed.
%   Parameter CELLSIZE is as explained earlier.

% Extract the 4-connected boundary of the region. Reuse variable B.
% It will be a boundary now. See Fig. 13.7(f) in DIPUM3E.
B = bwboundaries(R,4,'noholes');
B = B{1};
% Function bwboundaries outputs the last coordinate pair equal
% to the first.  Delete it.
B = B(1:end-1,:);
                  
% Obtain the xy coordinates of the boundary. These are column
% vectors.
x = B(:,1);
y = B(:,2);

% Format the vertices in the form required by the algorithm.
L = vertexlist(x,y,cellsize);
NV = size(L,1); % Number of vertices in L.
count = 1;       % Index for the vertices in the list.
k = 1;           % Index for vertices in the MPP.
X(1) = L(1,1);   % 1st vertex, known to be an MPP vertex.
Y(1) = L(1,2);

% Find the vertices of the MPP.
% Initialize.
cMPPV = [L(1,1),L(1,2)];  % Current MPP vertex.
cV = cMPPV;               % Current vertex.
classV = L(1,3);          % Class of current vertex (+1 for convex).
cWH = cMPPV;              % Current WHITE crawler.
cBL = cMPPV;              % Current BLACK crawler.

% Process the vertices. This is the core of the MPP algorithm.
% Note: Cannot preallocate memory for X and Y because their length
% is variable.
while true
   count = count + 1;
   if count > NV + 1
      break;
   end
   % Process next vertex.
   if count == NV + 1  % Have arrived at first vertex again.
      cV = [L(1,1),L(1,2)]; 
      classV = L(1,3);
   else
      cV = [L(count,1),L(count,2)];
      classV = L(count,3);
   end
   [I,newMPPV,W,B] = mppVtest(cMPPV,cV,classV,cWH,cBL);
   if I == 1 % New MPP vertex found;
      cMPPV = newMPPV; 
      K = find(L(:,1) == newMPPV(:,1) & L(:,2) == newMPPV(:,2));
      count = K; % Restart at current location of MPP vertex.
      cWH = newMPPV;
      cBL = newMPPV;
      k = k + 1;
      % Vertices of the MPP just found.
      X(k) = newMPPV(1,1); 
      Y(k) = newMPPV(1,2);
   else
      cWH = W;
      cBL = B;
   end
end
% Convert to columns.
X = X(:);
Y = Y(:);

%------------------------------------------------------------------%
function L = vertexlist(x,y,cellsize)
%   Given a set of coordinates contained in vectors X and Y, this
%   function outputs a list, L, of the form L = [X(k) Y(k) C(k)]
%   where C(k) determines whether X(k) and Y(k) are the coordinates
%   of the apex of a convex, concave, or 180-degree angle. That is,
%   C(k) = 1 if the coordinates (x(k - 1) y(k - 1),(x(k),y(k)) and
%   (x(k + 1),y(k + 1)) form a convex angle; C(k) = -1 if the angle
%   is concave; and C(k) = 0 if the three points are collinear.
%   Concave angles are replaced by their corresponding convex angles
%   in the outer wall for later use in the minimum-perimeter polygon
%   algorithm, as explained in the book.

% Preprocess the input data. First, arrange the the points so that
% the first point is the top, left-most point in the sequence. This
% guarantees that the first vertex of the polygon is convex.
cx = find(x == min(x));
cy = find(y == min(y(cx)));
x1 = x(cx(1));
y1 = y(cy(1));
% Scroll data so that the first point in the sequence is (x1,y1)
I = find(x == x1 & y == y1);
x = circshift(x,[-(I - 1),0]);
y = circshift(y,[-(I - 1),0]);

% Next keep only the points at which a change in direction takes
% place. These are the only points that are polygon vertices. Note
% that we cannot preallocate memory for the loop because xnew and
% ynew are of variable length.
J = 1;
K = length(x);
xnew(1) = x(1);
ynew(1) = y(1);
x(K + 1) = x(1);
y(K + 1) = y(1);
for k = 2:K
   s = vsign([x(k-1),y(k-1)],[x(k),y(k)],[x(k+1),y(k+1)]);
   if s ~= 0
      J = J + 1;
      xnew(J) = x(k);
      ynew(J) = y(k);
   end
end
% Reuse x and y.
x = xnew;
y = ynew;

% The mpp algorithm works with boundaries in the ccw direction.
% Force the sequence to be in that direction. Output dir is the
% direction of the original boundary. It is not used in this
% function.
[~,x,y] = boundarydir(x,y,'ccw'); 

% Obtain the list of vertices.
% Initialize.
K = length(x);
L(:,:,:) = [x(:) y(:) zeros(K,1)]; % Initialize the list.
C = zeros(K,1); % Preallocate memory for use in a loop later.

% Do the first and last vertices separately.
% First vertex.
s = vsign([x(K) y(K)],[x(1) y(1)],[x(2) y(2)]);
if s > 0
   C(1) = 1;
elseif s < 0
   C(1) = -1;
   [rx,ry] = vreplacement([x(K) y(K)],[x(1) y(1)],... 
                        [x(2) y(2)],cellsize);
   L(1,1) = rx;
   L(1,2) = ry;
else
   C(1) = 0;
end
% Last vertex.
s = vsign([x(K - 1) y(K - 1)],[x(K) y(K)],[x(1) y(1)]); 
if s > 0
   C(K) = 1;
elseif s < 0
   C(K) = -1;
   [rx,ry] = vreplacement([x(K-1) y(K-1)],[x(K) y(K)],...
                       [x(1) y(1)],cellsize);
   L(K,1) = rx;
   L(K,2) = ry;
else
   C(K) = 0;
end

% Process the rest of the vertices.
for k = 2:K - 1 
   s = vsign([x(k - 1) y(k - 1)],[x(k) y(k)],[x(k + 1) y(k + 1)]);
    if s > 0
      C(k) = 1;
    elseif s < 0
      C(k) = -1;
       [rx,ry] = vreplacement([x(k-1) y(k-1)],[x(k) y(k)],...
                       [x(k+1) y(k+1)],cellsize);
       L(k,1) = rx;
       L(k,2) = ry;
    else
      C(k) = 0;
    end
end

% Update the list with the C's.
L(:,3)= C(:);

%------------------------------------------------------------------%
function s = vsign(v1,v2,v3)
%   This function etermines whether a vertex V3 is on the
%   positive or the negative side of straight line passing through
%   V1 and V2, or whether the three points are colinear.  V1, V2,
%   and V3 are 1-by-2 or 2-by-1 vectors containing the [x  y]
%   coordinates of the vertices.  If V3 is on the positive side of
%   the line passing through V1 and V2, then the sign is positive (S
%   > 0), if it is on the negative side of the line the sign is
%   negative (S < 0).  If the points are collinear, then S = 0.
%   Another important interpretation is that if the triplet (V1,V2,
%   V3) form a counterclockwise sequence, then S > 0; if the points
%   form a clockwise sequence then S < 0; if the points are
%   collinear, then S = 0.
%
%   The coordinate system is assumed to be the system is as defined
%   in Chapter 2 of the book.
%
%   This function is based in the result from matrix theory that if
%   we arrange the coordinates of the vertices as the matrix
%
%        A = [V1(1) V1(2) 1; V2(1) V2(2) 1; V3(1) V3(2) 1]
%
%   then, S = det(A) has the properties described above, assuming
%   the stated coordinate system and direction of travel.

% Form the matrix on which the test if based:
A = [v1(1) v1(2) 1; v2(1) v2(2) 1; v3(1) v3(2) 1];
% Compute the determinant. Round to avoid round-off errors.
s = round(det(A));

%------------------------------------------------------------------%
function [rx,ry] = vreplacement(v1,v,v2,cellsize)
%   This function replaces the coordinates V(1) and V(2) of concave
%   vertex V by its diagonal mirror coordinates [RX,RY]. The values
%   RX and RY depend on the orientation of the triplet (V1,V,V2).
%   V1 is the vertex preceding V and V2 is the vertex following it.
%   All Vs are 1-by-2 or 2-by-1 arrays containing the coordinates of
%   the vertices. It is assumed that the triplet (V1,V,V2) was
%   generated by traveling in the counterclockwise direction, in the
%   coordinate system defined in Chapter 2 of the book, in which the
%   origin is at the top left, the positive x-axis extends down and
%   the positive y-axis extends to the right. Parameter CELLSIZE is
%   as explained earlier.

% Perform the replacement.

if v(1)>v1(1) && v(2) == v1(2) && v(1) == v2(1) && v(2)>v2(2)
    rx = v(1) - cellsize; 
    ry = v(2) - cellsize;
elseif v(1) == v1(1) && v(2) > v1(2) && v(1) < v2(1) && ...
    v(2) == v2(2)
    rx = v(1) + cellsize; 
    ry = v(2) - cellsize;
elseif v(1) < v1(1) && v(2) == v1(2) && v(1) == v2(1) &&... 
    v(2) < v2(2)
    rx = v(1) + cellsize; 
    ry = v(2) + cellsize;
elseif v(1) == v1(1) && v(2) < v1(2) && v(1) > v2(1) &&...
    v(2)== v2(2)
    rx = v(1) - cellsize; 
    ry = v(2) + cellsize;
else
   % Only the preceding forms are valid arrangements of vertices.
   error('Vertex configuration is not valid.')
end

%------------------------------------------------------------------%
function [I,newMPPV,W,B] = mppVtest(cMPPV,cV,classcV,cWH,cBL)
%   This function performs tests for existence of an MPP vertex.
%   The parameters are as follows (all except I and class_c_V) are
%   coordinate pairs of the form [x y]).
%     cMPPV         Current MPP vertex (the last MPP vertex found).
%     cV            Current vertex in the sequence.
%     classcV       Class of current vertex (+1 for convex
%                   and -1 for concave).
%     cWH           The current WHITE (convex) vertex.    
%     cBL           The current BLACK (concave) vertex
%     I             If I = 1, a new MPP vertex was found
%     newMPPV       Next MPP vertex (if I = 1).
%     W             Next coordinates of WHITE.
%     B             Next coordinates of BLACK.
%
%   The details of the test are explained in Chapter 12 of the book.

% Preliminaries
I = 0;
newMPPV = [0 0];
W = cWH;
B = cBL;
sW = vsign(cMPPV,cWH,cV);
sB = vsign(cMPPV,cBL,cV);

% Perform test.
if sW > 0
   I = 1; % New MPP vertex found.
   newMPPV = cWH;
   W = newMPPV;
   B = newMPPV;
elseif sB < 0
   I = 1; % New MPP vertex found. 
   newMPPV = cBL;
   W = newMPPV;
   B = newMPPV;
elseif (sW <= 0) && (sB >= 0)
   if classcV == 1
      W = cV;
   else
      B = cV;
   end
end
