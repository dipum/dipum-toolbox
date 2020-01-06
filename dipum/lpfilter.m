function H = lpfilter(type,M,N,D0,n)
%LPFILTER Computes frequency domain lowpass filter transfer functions.
%   H = LPFILTER(TYPE,M,N,D0,n) generates the transfer function, H, of a
%   lowpass filter of the specified TYPE and size (M-by-N).
%
%   Valid values for TYPE, D0, and n are:
%
%    'ideal'       Ideal lowpass filter transfer function with cutoff
%                  frequency D0. n is not needed. D0 must be positive.
%
%    'butterworth' Butterworth lowpass filter transfer function of order
%                  n, and cutoff frequency D0.  The default value for n
%                  is 1.0. D0 must be positive.
%
%    'gaussian'   Gaussian lowpass filter transfer function with cutoff
%                 frequency (standard deviation) D0. n is not needed. D0
%                 must be positive.
%
%   H is floating point of class double. It is returned uncentered for
%   consistency with the filtering function dftfilt. To view H as an
%   image or mesh plot, it should be centered using Hc = fftshift(H).
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

% Protect against uppercase.
type = lower(type);

% Use function dftuv to set up the meshgrid arrays needed for computing
% the required distances.
[U,V] = dftuv(M,N);

% Compute the distances D(U,V).
D = hypot(U,V);

% Begin filter computations.
switch type
case 'ideal'
   H = double(D <= D0);
case 'butterworth'
   if nargin == 4
      n = 1;
   end
   H = 1./(1 + (D./D0).^(2*n));
case 'gaussian'
   H = exp(-(D.^2)./(2*(D0^2)));
otherwise
   error('Unknown filter type.')
end
