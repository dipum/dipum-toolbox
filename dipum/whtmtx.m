function A = whtmtx(N)
%WHTMTX Generates sequency-ordered Walsh-Hadamard transformation matrix.
%   A = WHTMTX(N) returns the sequency-ordered transformation matrix for
%   a Walsh-Hadamard transform of dimension N, where N is a power of 2.
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

bits = log2(N);
if rem(bits,1) > 0
   error('N must be a power of 2!');
end

% Scale MATLAB's naturally ordered Hadamard functions
H = hadamard(N) ./ sqrt(N);

% Create a vector of row numbers in binary. Subtract character '0' to make
% the vector of type logical rather than character.
rows = dec2bin(0:N-1,bits) - '0';

% Gray code the row numbers. Note that we are working from the most to
% least significant bit. That is, column 1 of gray contains the MSB.
gray = rows;
for i = 2:1:bits
   gray(:,i) = xor(rows(:,i),rows(:,i-1));
end

% Bit-reverse the gray coded row numbers and convert to new decimal row
% numbers. Then rearrange the rows.
rows = fliplr(gray) * pow2((bits-1:-1:0)');
A = H(rows+1,:);
