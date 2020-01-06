function H = cnotch(type,notch,M,N,C,D0,n)
%CNOTCH Generates notch filter transfer functions.
%   H = CNOTCH(TYPE,NOTCH,M,N,C,D0,n) generates a notch transfer
%   function of size M-by-N. C is a K-by-2 matrix, each row of which
%   contains the (u,v) [i.e., (row,col)] coordinates in the frequency
%   domain, of the center of one notch. The corresponding symmetric
%   notch pair is generated automatically by the function. The notch
%   coordinates are with respect to the standard origin, at the top left
%   of the transform. The function registers them with respect to the
%   center of the frequency rectangle automatically. Each pair of
%   coordinates, (u,v), gives the location of one notch. D0 is the
%   radius (cut-off frequency) of the notches. It can be specified as a
%   scalar, in which case it is used in all K notch pairs, or it can be
%   a vector of length K, containing an individual cutoff value for each
%   notch pair. n is the order of the Butterworth transfer function if
%   one is specified.
%
%   Valid values of TYPE are:
%
%      'ideal'        Ideal notch filter transfer function. n is not
%                     used.
%
%      'butterworth'  Butterworth notch filter transfer function of
%                     order n. The default value of n is 1.
%
%      'gaussian'     Gaussian notch filter transfer function. n is not
%                     used.
%
%   Valid values of NOTCH are:
%  
%      'reject'       Notchreject transfer function.
%
%      'pass'         Notchpass transfer function.
%
%   One of these two values must be specified for NOTCH.
%
%   H is of class double. It is returned uncentered for consistency with
%   the function dftfilt. To view H as an image or mesh plot, it should
%   be centered using Hc = fftshift(H).
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
if nargin < 7
   n = 1; % Default for Butterworth transfer function.
end

% Define tha largest array of odd dimensions that fits in H. This is
% required to preserve symmetry in the transfer function. If necessary,
% a row and/or column is (are) added to the transfer function at the
% end.
MO = M;
NO = N;
if iseven(M)
   MO = M - 1;
end
if iseven(N)
   NO = N - 1;
end

% Center of the transfer function:
center = [floor(MO/2) + 1, floor(NO/2) + 1];

% Number of notch pairs.
K = size(C,1);
% Cutoff values.
if numel(D0) == 1
      D0(1:K) = D0; % All cut offs are the same.
end
                       
% Shift the notch centers so that they are with respect to the center of
% the frequency rectangle.
center = repmat(center,size(C,1),1);
C = C - center;

% Begin computations. All transfer functions are computed as notchreject
% functions. At the end, they are changed to notchpass transfer
% functions if it is so specified in parameter NOTCH.
H = rejectFilter(type,MO,NO,D0,K,C,n);

% Finished. Format the output.
H = processOutput(notch,H,M,N,center);

%------------------------------------------------------------------%
function H = rejectFilter(type,MO,NO,D0,K,C,n)
% Initialize H to be an "all pass" filter transfer function. This
% constant is then multiplied by the notchreject transfer function
% placed at the locations in C with respect to the center of the
% frequency rectangle.
H = ones(MO,NO);

% Generate transfer function.
for I = 1:K
   % Place a notch at each location. Function hpfilter returns the
   % transfer functions uncentered. Use fftshit to center them at each
   % location. The transfer functions are made larger than M-by-N to
   % simplify indexing in function placeNotches.
   Usize = MO + 2*abs(C(I, 1));
   Vsize = NO + 2*abs(C(I, 2));
   filt = fftshift(hpfilter(type,Usize,Vsize,D0(I),n));
   % Insert FILT in H.
   H = placeNotches(H,filt,C(I,1),C(I,2));
end

%------------------------------------------------------------------%
function P = placeNotches(H,filt,delu,delv)
% Places in H the notch contained in FILT.

[M,N] = size(H);
U = 2*abs(delu);
V = 2*abs(delv);

% The following calculations are to determine the (common) area of
% overlap between array H and the notch filter transfer function FILT.
% The Q's are quadrants.
if delu >= 0 && delv >= 0
   filtCommon = filt(1:M,1:N); % Displacement is in Q1.
elseif delu < 0 && delv >= 0
   filtCommon = filt(U + 1:U + M,1:N); % Displacement is in Q2.
elseif delu < 0 && delv < 0
   filtCommon = filt(U + 1:U + M, V + 1:V + N); % Q3
elseif delu >= 0 && delv <= 0
   filtCommon = filt(1:M, V + 1:V + N); % Q4
end

% Compute the product of H and filtCommon. They are registered. 
P = ones(M,N).*filtCommon;

% The conjugate notch location is determined by rotating P 180 degress.
% The product of P and its rotated version contain FILT and its
% conjugate.
P = P.*(rot90(P,2));
P = H.*P; % A new notch and its conjugate were inserted.

%------------------------------------------------------------------%
function Hout = processOutput(notch,H,M,N,center)
% At this point, H is an odd array in both dimensions (see comments at
% the beginning of the function). In the following, we insert a row if M
% is even, and a column if N is even. The new row and column have to be
% symmetric about their center to preserve symmetry in the transfer
% function. They are created by duplicating the first row and column of
% H and then making them symmetric.
centerU = center(1,1);
centerV = center(1,2);
newRow = H(1,:); 
newRow(1:centerV - 1) = fliplr(newRow(centerV + 1:end)); % Symmetric.
newCol = H(:,1);
newCol(1:centerU - 1) = flipud(newCol(centerU + 1:end)); % Symmetric.
% Insert the new row and/or column if appropriate.
if iseven(M) && iseven(N)
   Hout = cat(1,newRow,H);
   newCol = cat(1,H(1,1),newCol);
   Hout = cat(2,newCol,Hout);
elseif iseven(M) && isodd(N)
   Hout = cat(1,newRow,H);
elseif isodd(M) && iseven(N)
   Hout = cat(2,newCol,H);
else
   Hout = H;
end
   
% Uncenter the transfer function, as required for filtering with
% dftfilt.
Hout = ifftshift(Hout);

% Generate a notchpass transfer function if so specified.
if isequal(notch,'pass')
   Hout = 1 - Hout;
end
