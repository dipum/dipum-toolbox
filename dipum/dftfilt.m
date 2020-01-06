function g = dftfilt(f,H,padMethod,classOut)
%DFTFILT Performs frequency domain filtering.
%   g = DFTFILT(f,H,padMethod,classOut) filters f in the frequency
%   domain using the filter transfer function H. The output, g, is the
%   filtered image, which is of the same size as f. padMethod and
%   classOut are explained below. Any intermediate arguments that are
%   not specified should be replaced by []. For example, if classOut is
%   specified but padMethod is not, we use g = dftfilt(f,H,[],classOut).
%   Non-specified arguments are replaced by their default values.
%
%   Valid values of classOut are:
%
%   'same'      The output will be of the same class as the input. 
%              
%   'floating'  The output will be floating point of class double. This 
%               is the default.
%
%   Valid values of padMethod are: 
%
%   'zeros'     Pads the input image with 0s using the 'post' option in
%               the Toolbox function padarray. This is the default.
%   'symmetric' Pads the image using the 'symmetric' and 'post' options
%               in the Toolbox function padarray
%   'replicate' Pads the image using the 'replicate' and 'post' options 
%               in the Toolbox function padarray.
%   'circular'  Pads the image using the 'circular' and 'post' options
%               in the Toolbox function padarray.
%  
%   DFTFILT automatically pads f to be the same size as H. Both f and H
%   must be real. H must be an uncentered, symmetric filter transfer
%   function, as illustrated in Fig. 4.2(a). (You can uncenter a centered
%   transfer function using function fftshift.)
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

% Set Defaults. Note: Function padarray used below does not recognize a
% padvalue specified as 'zeros', which we use for notational consistency
% in the input to function dftfilt. A padvalue of 'zeros' is converted
% to the numerical zero (0);

if (nargin < 4) || isempty(classOut)
   classOut = 'floating';
end

if (nargin < 3) || isempty(padMethod) || isequal(padMethod,'zeros')
   padMethod = 0;
end

% Convert the input to floating point. Will need revertClass later.
[f,revertClass] = tofloat(f);
[M,N] = size(f);

% Pad f to the size of the transfer function, using the default or
% specified padmethod.
f = padarray(f, [size(H,1) - M, size(H,2) - N], padMethod, 'post');

% Obtain the FFT of the input image. The image was already padded to be
% of the same size as the filter transfer function.
F = fft2(f);

% Perform filtering. 
g = ifft2(H.*F);

% Crop to original size.
g = g(1:M,1:N);

% The output is double at this point, which is the default, so nothing
% has to be done unless classout was specified as 'same'.
if isequal(classOut,'same')
   g = revertClass(g);
end

