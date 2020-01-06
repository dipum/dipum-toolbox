function H = bandfilter(type,band,M,N,C0,W,n)
%BANDFILTER Computes frequency domain band filter transfer functions.
%   H = BANDFILTER('ideal',BAND,M,N,C0,W) computes an M-by-N ideal
%   bandpass or bandreject filter transfer function, depending on the
%   value of BAND.
%
%   H = BANDFILTER('butterworth',BAND,M,N,C0,W,n) computes an M-by-N
%   Butterworth transfer function of order n. The function is either
%   bandpass or bandreject, depending on the value of BAND. The default
%   value of n is 1.
%
%   H = BANDFILTER('gaussian',BAND,M,N,C0,W) computes an M-by-N gaussian
%   transfer function. The function is either bandpass or bandreject,
%   depending on BAND.
%
%   Valid values of BAND are:
%     'reject'  Bandreject filter transfer function.
%
%     'pass'    Bandpass filter transfer function.
%   
%    The other parameters are as follows (see Table 4.4):
%
%     M:  Number of rows in the transfer function.
%     N:  Number of columns in the transfer function.
%     C0: Radius of the center of the band.
%     W:  "Width" of the band. W is the true width only for ideal
%         transfer functions. For the other two, this parameter acts
%         more like a smooth cutoff.
%     n:  Order of the Butterworth transfer function if one is
%         specified. W and n interplay to determine the effective
%         broadness of the reject or pass band. Higher values of both
%         these parameters result in broader bands.
%
%   H is of floating point class double. It is returned uncentered for
%   consistency with the function dftfilt. To view H as an image or mesh
%   plot, it should be centered using Hc = fftshift(H).
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

% Use function dftuv to set up the meshgrid arrays needed for computing
% the required distances.
[U,V] = dftuv(M,N);

% Compute the distances D(U,V).
D = hypot(U,V);

% Determine if need to use default n.
if nargin < 7
   n = 1; % Default BW filter order.
end
 
% Begin computations. All transfer functions are computed as bandreject
% functions. At the end, they are converted to bandpass if so specified.
% Use lower(type) to protect against type being capitalized.
switch lower(type) 
   case 'ideal'
      H = idealReject(D,C0,W); 
   case 'butterworth'
      H = butterworthReject(D,C0,W,n);
   case 'gaussian'
      H = gaussReject(D,C0,W);
   otherwise
      error('Unknown filter type.')
end

% Convert to a bandpass transfer function if so specified.
if isequal(band,'pass')
   H = 1 - H;
end

%----------------------------------------------------------------------%
function H = idealReject(D,C0,W)
RI = D <= C0 - (W/2);   % Points of region inside the inner boundary of
                        % the reject band are labeled 1. All other
                        % points are labeled 0.
                         
RO = D >= C0 + (W/2);   % Points of region outside the outer boundary
                        % of the reject band are labeled 1. All other
                        % points are labeled 0.
                        
H = tofloat(RO | RI);   % Ideal bandreject transfer function.

%----------------------------------------------------------------------%
function H = butterworthReject(D,C0,W,n)
H = 1./(1 + ((D*W)./(D.^2 - C0^2)).^(2*n));

%----------------------------------------------------------------------%
function H = gaussReject(D,C0,W)
H = 1 - exp(-((D.^2 - C0^2)./(D.*W + eps)).^2);
