function PQ = paddedsize(AB,CD,PARAM)
%PADDEDSIZE Computes padded sizes useful for FFT-based filtering. 
%   PQ = PADDEDSIZE(AB), where AB is a two-element vector, computes the
%   two-element vector PQ = 2*AB.
%
%   PQ = PADDEDSIZE(AB,'PWR2') computes the vector PQ such that PQ(1) =
%   PQ(2) = 2^nextpow2(2*m), where m is MAX(AB).
%
%   PQ = PADDEDSIZE(AB,CD), where AB and CD are two-element size vectors,
%   computes the two-element size vector PQ. The elements of PQ are the
%   smallest even integers greater than or equal to AB + CD - 1.
%
%   PQ = PADDEDSIZE(AB,CD,'PWR2') computes the vector PQ such that PQ(1)
%   = PQ(2) = 2^nextpow2(2*m), where m is MAX([AB,CD]).
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

if nargin == 1
   PQ  = 2*AB;
elseif nargin == 2 && ~ischar(CD)
   PQ = AB + CD - 1;
   PQ = 2*ceil(PQ/2);
elseif nargin == 2
   m = max(AB); % Maximum dimension.
   
   % Find power-of-2 at least twice m.
   P = 2^nextpow2(2*m);
   PQ = [P,P];
elseif (nargin == 3) && strcmpi(PARAM,'pwr2')
   m = max([AB,CD]); % Maximum dimension.
   P = 2^nextpow2(2*m);
   PQ = [P,P];
else 
   error('Wrong number of inputs.')
end
