function z = frdescp(s)
%FRDESCP Computes Fourier descriptors.
%   Z = FRDESCP(S) computes the Fourier descriptors of S, which is an
%   np-by-2 sequence of ordered boundary coordinates.
%
%   Because of symmetry requirements, the number of points in S must be
%   even if Z is to be used later to compute the inverse. If the number
%   of points is odd, FRDESCP duplicates the last point. If a different
%   treatment is desired, the sequence must be processed externally so
%   that it has an even number of points.
%
%   See function IFRDESCP for computing the inverse descriptors. 
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
[np,nc] = size(s);
if nc ~= 2 
  error('S must be of size np-by-2.'); 
end
if np/2 ~= round(np/2)
  s(end + 1,:) = s(end,:);
  np = np + 1;
end

% Create an alternating sequence of 1s and -1s for use in centering the
% transform (see Gonzalez and Woods [2018]).
x = 0:(np - 1);
m = ((-1).^ x)';
 
% Multiply the input sequence by alternating 1s and -1s to center the
% transform.
s(:,1) = m.*s(:,1);
s(:,2) = m.*s(:,2);

% Convert coordinates to complex numbers.
s = s(:,1) + 1i*s(:,2);

% Compute the descriptors.
z = fft(s);
