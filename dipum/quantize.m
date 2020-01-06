function y = quantize(x,b,type)
%QUANTIZE Quantizes the elements of a UINT8 matrix.
%   Y = QUANTIZE(X,B,TYPE) quantizes X to B bits. Truncation is used
%   unless TYPE is 'igs' for Improved Gray Scale quantization.
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

narginchk(2,3);         % Check input arguments
if ~ismatrix(x) || ~isreal(x) || ...
     ~isnumeric(x) || ~isa(x,'uint8')
   error('The input must be a UINT8 numeric matrix.');  
end

% Create bit masks for the quantization
lo = uint8(2 ^ (8 - b) - 1);
hi = uint8(2 ^ 8 - double(lo) - 1);

% Perform standard quantization unless IGS is specified
if nargin < 3 || ~strcmpi(type,'igs')
   y = bitand(x,hi);
   
% Else IGS quantization. Process column-wise. If the MSB's of the pixel
% are all 1's, the sum is set to the pixel value. Else, add the pixel
% value to the LSB's of the previous sum. Then take the MSB's of the sum
% as the quantized value.
else
   [m,n] = size(x);                            s = zeros(m,1);
   hitest = double(bitand(x,hi) ~= hi);        x = double(x);
   for j = 1:n
      s = x(:,j) + hitest(:,j) .* double(bitand(uint8(s),lo));
      y(:,j) = bitand(uint8(s),hi);
   end
end
