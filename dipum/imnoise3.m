function [r,F,S] = imnoise3(M,N,C,A,B)
%IMNOISE3 2-D sinusoidal spatial pattern.
%   [r,F,S] = IMNOISE3(M,N,C,A,B), generates a spatial sinusoidal
%   pattern, r, of size M-by-N, and its Fourier transform, F, and
%   spectrum, S.
%   
%   The input parameters C, A, and B, are as follows:
%
%   C is a K-by-2 matrix each row of which contains the frequency domain
%   coordinates, (u,v), for one of K impulses. The conjugate of each
%   impulse is generated automatically. The coordinates are integers in
%   units of frequency with respect to the center of the M-by-N
%   frequency rectangle (see Fig. 4.2(b)). Therefore, u and v determine
%   the number of cycles of the sine wave along the u- and v-axis for
%   each impulse. Example: For a frequency rectangle of size 512-by-512,
%   the center is computed to be at (257,257) (see Section 4.2). If we
%   specify C = [1 1], the impulse and its conjugate will be placed at
%   points (258,258) and (256,256), which are in the 2nd and 4th
%   quadrants of the centered transform, very close to its centered
%   origin. The result will be a sine wave of very low frequency because
%   of the proximity of the impulse pair with respect to the origin. The
%   2-D sine wave will be oriented in the direction of the vector (1,1),
%   (i.e., +45 degrees). This is because this vector is in the
%   +45-degree direction with respect to the (+u,+v) axes (see Fig.
%   4.2(b)). The specified impulse locations must lie within one of the
%   four quadrants of the centered rectangle.
%
%   A is a 1-by-K vector containing the amplitude of each of the K
%   impulse pairs. If A is not included in the argument it defaults to 1
%   for each impulse. B is then automatically set to 0. To include B and
%   use the default values for A, include A as the empty matrix, [], in
%   the input.
%
%   B is a K-by-2 matrix containing the Bx and By phase components for
%   each impulse pair. The values can be positive or negative floating
%   point numbers. Positive values cause displacement of the sine wave
%   in the direction of the positive axis, and conversely for negative
%   values. The default value for B is zeros(K,2).
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

% Number of impulses.
K = size(C,1);

% Check that the locations of the impulses are inside the frequency
% rectangle and that they are whole numbers.
if any(abs(C(:,1)) > floor(M/2)) || any(abs(C(:,2)) > floor(N/2)) || ...
      any(floor(C(:)) ~= C(:))
   error(['Impulses must be inside the frequency rectangle and ' ...
      'be whole numbers.'])
end

% Process the input parameters.
if nargin == 3
   A = ones(1,K);
   B = zeros(K,2);
elseif nargin == 4 && ~isempty(A)
   B = zeros(K,2);
end

% (row,col) center of the frequency rectangle.
ucenter = floor(M/2) + 1;
vcenter = floor(N/2) + 1;

% Initialize the Fourier transform.
F = zeros(M,N);

% Insert in F the impulses and their conjugates, multiplied by the
% exponentials carrying the phase values. See Eq. (5-9).
for k = 1:K
   % Fourier transform coordinates for a given impulse.
   u1 = ucenter + C(k,1);
   v1 = vcenter + C(k,2);
   % Coordinates of the conjugate.
   u2 = ucenter - C(k,1);
   v2 = vcenter - C(k,2);
   % Form the Fourier transform.
   F(u1,v1) = 1i*M*N*(A(k)/2) * exp(-1i*2*pi*(u1*B(k,1)/M ...
                 + v1*B(k,2)/N));
   F(u2,v2) = -1i*M*N*(A(k)/2) * exp(1i*2*pi*(u2*B(k,1)/M ...
               + v2*B(k,2)/N));
end

% Compute the spectrum and spatial sinusoidal pattern.
S = abs(F);
r = real(ifft2(ifftshift(F)));
