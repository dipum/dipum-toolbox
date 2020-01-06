function [nc,y] = wavecut(type,c,s,n)
%WAVECUT Zeroes coefficients in a wavelet decomposition structure.
%   [NC,Y] = WAVECUT(TYPE,C,S,N) returns a new decomposition vector
%   whose detail or approximation coefficients (based on TYPE and N)
%   have been zeroed. The coefficients that were zeroed are returned in
%   Y.
%
%   INPUTS:
%     TYPE      Coefficient category
%     -------------------------------------
%     'a'       Approximation coefficients
%     'h'       Horizontal details
%     'v'       Vertical details
%     'd'       Diagonal details
%
%     [C, S] is a wavelet data structure.
%     N specifies a decomposition level (ignored if TYPE = 'a').
%
%   See also WAVEWORK, WAVECOPY, and WAVEPASTE.
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

narginchk(3,4);
if nargin == 4   
   [nc, y] = wavework('cut',type,c,s,n);
else  
   [nc, y] = wavework('cut',type,c,s);  
end
