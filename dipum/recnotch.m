function H = recnotch(notch,mode,M,N,W,S)
%RECNOTCH Generates axes notch filter transfer functions.
%   H = RECNOTCH(NOTCH,MODE,M,N,W,S) generates an M-by-N notch filter
%   transfer function consisting of symmetric pairs of rectangles of
%   width W placed on the vertical and/or horizontal axes of the
%   (centered) frequency rectangle. W must be an odd integer
%   to preserve the symmetry of the filtered Fourier transform.
%
%   NOTCH can be:
%
%      'reject'    Notchreject filter transfer function.
%
%      'pass'      Notchpass filter transfer function.
%
%   MODE can be:
%
%      'vertical'     Filtering on vertical axis only.
%
%      'horizontal'   Filtering on horizontal axis only. 
%
%      'both'         Filtering on both axes.
%
%   If MODE is 'vertical', then vertical rectangles start at +/- S
%   pixels from the center of the frequency rectangle along the vertical
%   axis and extend to both ends of that axis. Similarly, if MODE is
%   'horizontal', then horizontal rectangles start at +/- S pixels from
%   the center and extend to both ends of that axis. If MODE is 'both',
%   then rectangles are placed in both directions starting at +/- S.
%   Alternatively, if MODE is 'both', then S can be a two-element
%   vector, [SV SH], specifying the starting rectangle locations in both
%   directions.
%
%   H = RECNOTCH(NOTCH,MODE,M,N) uses W = 3 and S = 1.
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

% Defaults.
if nargin < 6
   S = 1;
end
if nargin < 5
   W = 3;
end
if ~isodd(W)
   error('W must be odd.')
end

% AV and AH are rectangle amplitude values for the vertical and
% horizontal rectangles: 0 for notchreject and 1 for notchpass. The
% transfer functions are computed initially as reject transfer functions
% and then changed to pass if so specified in NOTCH.
if isequal(mode,'vertical')
   % Reject only along vertical axis.
   AV = 0;
   AH = 1; 
   SV = S;
   SH = 1;
elseif isequal(mode,'horizontal')
   % Reject only along horizontal axis.
   AV = 1;  
   AH = 0;
   SH = S;
   SV = 1;
elseif isequal(mode,'both')
   % Reject along both axes.
   AV = 0;
   AH = 0;
   if numel(S) == 1
      SV = S;
      SH = S;
   else
      SV = S(1);
      SH = S(2);
   end
else
   error('Unknown mode')
end
   
% Begin computation. The transfer function is generated as a 'reject'
% function. At the end, it is changed to a 'pass' function if it is so
% specified in parameter NOTCH.
H = rectangleReject(M,N,W,SV,SH,AV,AH);

% Finished computing the rectangle notch transfer function. Format the
% output so it is returned uncentered for use in function dftfilt, and
% change H to a 'pass' function if so specified.
H = ifftshift(H);
if isequal(notch,'pass')
   H = 1 - H;
end
    
%----------------------------------------------------------------------%
function H = rectangleReject(M,N,W,SV,SH,AV,AH)
% Preliminaries.
H = ones(M,N);
% Center of frequency rectangle.
UC = floor(M/2) + 1;
VC = floor(N/2) + 1;
% Width limits.
WL = (W - 1)/2;
% Compute rectangle notches with respect to center.
% Left, horizontal rectangle.
H(UC-WL:UC+WL, 1:VC-SH) = AH;
% Right, horizontal rectangle.
H(UC-WL:UC+WL, VC+SH:N) = AH;
% Top vertical rectangle.
H(1:UC-SV, VC-WL:VC+WL) = AV;
% Bottom vertical rectangle.
H(UC+SV:M, VC-WL:VC+WL) = AV;




