function H = hpfilter(type,M,N,D0,n)
%HPFILTER Computes frequency domain highpass filter transfer functions.
%   H = HPFILTER(TYPE,M,N,D0,n) creates the transfer function, H, of a
%   highpass filter of the specified TYPE and size (M-by-N).
%   
%   Valid values for TYPE, D0, and n are: 
%
%    'ideal'        I deal highpass transfer function with cutoff
%                   frequency D0. n need not be supplied. D0 must be
%                   positive .
%
%    'butterworth'  Butterworth highpass transfer function of order n,
%                   and cutoff frequency D0. The default value for n is
%                   1.0. D0 must be positive.
%
%    'gaussian'     Gaussian highpass transfer function with cutoff
%                   frequency (standard deviation) D0. n need not be
%                   supplied. D0 must be positive.
%
%   H is of floating point class double. It is returned uncentered for
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

% The transfer function Hhp of a highpass filter is 1 - Hlp, where Hlp
% is the transfer function of the corresponding lowpass filter. Thus,
% we can use function lpfilter to generate highpass filters.

% Default value for n.   
if nargin == 4
   n = 1;
end

% Generate the highpass filter transfer function from the corresponding
% lowpass function (see Table 4.1).
H = 1.0 - lpfilter(type,M,N,D0,n);
