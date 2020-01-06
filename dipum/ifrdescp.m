function s = ifrdescp(z,nd)
%IFRDESCP Computes inverse Fourier descriptors.
%   S = IFRDESCP(Z,ND) computes the inverse Fourier descriptors of of Z,
%   which is a sequence of Fourier descriptors obtained, for example, by
%   using function FRDESCP. ND is the number of descriptors used to
%   compute the inverse; ND must be an even integer no greater than
%   length(Z), and length(Z) must be even also. If ND is omitted, it
%   defaults to length(Z). The output, S, is matrix of size
%   length(Z)-by-2 containing the coordinates of a closed boundary.
%
%   See function FRDESCP for computing the descriptors.
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
np = length(z);
% Check inputs.
if nargin == 1 
  nd = np; 
end
if np/2 ~= round(np/2)
  error('length(z) must be an even integer.')
elseif nd/2 ~= round(nd/2)
  error('nd must be an even integer.')
end

% Create an alternating sequence of 1s and -1s for use in centering the
% transform (see Gonzalez and Woods [2018]).
x = 0:(np - 1);
m = ((-1) .^ x)';

% Use only nd descriptors in the inverse.  Because the descriptors are
% centered, (np - nd)/2 terms from each end of the sequence are set to
% 0.
d = (np - nd)/2; 
z(1:d) = 0;
z(np - d + 1:np) = 0;

% Compute the inverse and convert back to obtain the boundary
% coordinates.
zz = ifft(z);
s(:,1) = real(zz);
s(:,2) = imag(zz);

% Multiply by alternating 1 and -1s to undo the centering done in
% function frdescp..
s(:,1) = m.*s(:,1);
s(:,2) = m.*s(:,2);
