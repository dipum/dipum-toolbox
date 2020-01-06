function y = im2jpeg(x,quality,bits) 
%IM2JPEG Compresses an image using a JPEG approximation.
%   Y = IM2JPEG(X,QUALITY) compresses image X based on 8 x 8 DCT
%   transforms, coefficient quantization, and Huffman symbol coding.
%   Input BITS is the bits/pixel used for the unsigned integer input;
%   QUALITY determines the amount of information that is lost and
%   compression achieved.  Y is an encoding structure containing fields:
%
%      Y.size      Size of X
%      Y.bits      Bits/pixel of X
%      Y.numblocks Number of 8-by-8 encoded blocks
%      Y.quality   Quality factor (as percent)
%      Y.huffman   Huffman encoding structure, as returned by MAT2HUFF
%
%   See also JPEG2IM.
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

narginchk(1,3);             % Check input arguments
if ~ismatrix(x) || ~isreal(x) || ~isnumeric(x) || ~isinteger(x)
   error('The input image must be unsigned integer.');  
end
if nargin < 3    
   bits = 8;      % Default value for quality.
end       
if bits < 0 || bits > 16
    error('The input image must have 1 to 16 bits/pixel.');
end
if nargin < 2    
   quality = 1;   % Default value for quality.
end       
if quality <= 0
   error('Input parameter QUALITY must be greater than zero.');
end

m = [16  11  10  16  24  40  51  61       % JPEG normalizing array
     12  12  14  19  26  58  60  55       % and zig-zag redordering
     14  13  16  24  40  57  69  56       % pattern.
     14  17  22  29  51  87  80  62
     18  22  37  56  68  109 103 77
     24  35  55  64  81  104 113 92
     49  64  78  87  103 121 120 101
     72  92  95  98  112 100 103 99] * quality;

order = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
        41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
        43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
        45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
        62 63 56 64];

[xm,xn] = size(x);                        % Get input size.
x = double(x) - 2^(round(bits) - 1);      % Level shift input
t = dctmtx(8);                            % Compute 8 x 8 DCT matrix

% Compute DCTs of 8x8 blocks and quantize the coefficients.
fun = @(block_struct)blkdct(block_struct.data,t);
y = blockproc(x,[8 8],fun);
fun = @(block_struct)blkzero(block_struct.data,m);
y = blockproc(y,[8 8],fun);

y = im2col(y,[8 8],'distinct');    % Break 8x8 blocks into columns
xb = size(y,2);                    % Get number of blocks
y = y(order,:);                    % Reorder column elements

eob = max(y(:)) + 1;               % Create end-of-block symbol
r = zeros(numel(y) + size(y,2),1);
count = 0;
for j = 1:xb                       % Process 1 block (col) at a time
   i = find(y(:,j),1,'last' );     % Find last non-zero element
   if isempty(i)                   % No nonzero block values
      i = 0;
   end
   p = count + 1;
   q = p + i;
   r(p:q) = [y(1:i,j); eob];       % Truncate trailing 0's, add EOB,
   count = count + i + 1;          % and add to output vector
end

r((count + 1):end) = [];           % Delete unusued portion of r
   
y           = struct;
y.size      = uint16([xm xn]);
y.bits      = uint16(bits);
y.numblocks = uint16(xb);
y.quality   = uint16(quality * 100);
y.huffman   = mat2huff(r);

%----------------------------------------------------------------------%
% DCT matrix multiplications
function y = blkdct(x,a)
y = a * x * a';

%----------------------------------------------------------------------%
% Truncate coefficients
function y = blkzero(x,m)
y = round(x ./ m);
