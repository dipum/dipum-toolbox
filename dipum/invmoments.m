function phi = invmoments(f)
%INVMOMENTS Compute invariant moments of image.
%   PHI = INVMOMENTS(F) computes the moment invariants of the image F.
%   PHI is a seven-element row vector containing the moment invariants
%   as defined in DIPUM3E, Table 13.8.
%
%   F must be a 2-D, real, nonsparse, numeric or logical matrix.
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


if ~ismatrix(f) || issparse(f) || ~isreal(f) || ... 
         ~isnumeric(f) || islogical(f)
   error(['F must be a 2-D, real, nonsparse, numeric or logical ' ...
          'matrix.']); 
end

f = double(f);

phi = compute_phi(compute_eta(compute_m(f)));
  
%----------------------------------------------------------------------%
function m = compute_m(f)

[M,N] = size(f);
[x,y] = meshgrid(1:N,1:M);
  
% Turn x,y, and F into column vectors to make the summations a bit
% easier to compute in the following.
x = x(:);
y = y(:);
f = f(:);
  
% DIPUM3E equation (13-27)
m.m00 = sum(f);
% Protect against divide-by-zero warnings.
if (m.m00 == 0)
   m.m00 = eps;
end
% The other central moments:  
m.m10 = sum(x .* f);
m.m01 = sum(y .* f);
m.m11 = sum(x .* y .* f);
m.m20 = sum(x.^2 .* f);
m.m02 = sum(y.^2 .* f);
m.m30 = sum(x.^3 .* f);
m.m03 = sum(y.^3 .* f);
m.m12 = sum(x .* y.^2 .* f);
m.m21 = sum(x.^2 .* y .* f);

%----------------------------------------------------------------------%
function e = compute_eta(m)

% DIPUM3E equations (13-28) through (13-30).

xbar = m.m10 / m.m00;
ybar = m.m01 / m.m00;

e.eta11 = (m.m11 - ybar*m.m10) / m.m00^2;
e.eta20 = (m.m20 - xbar*m.m10) / m.m00^2;
e.eta02 = (m.m02 - ybar*m.m01) / m.m00^2;
e.eta30 = (m.m30 - 3 * xbar * m.m20 + 2 * xbar^2 * m.m10) / ...
            m.m00^2.5;
e.eta03 = (m.m03 - 3 * ybar * m.m02 + 2 * ybar^2 * m.m01) / ...
            m.m00^2.5;
e.eta21 = (m.m21 - 2 * xbar * m.m11 - ybar * m.m20 + ...
           2 * xbar^2 * m.m01) / m.m00^2.5;
e.eta12 = (m.m12 - 2 * ybar * m.m11 - xbar * m.m02 + ...
           2 * ybar^2 * m.m10) / m.m00^2.5;

%----------------------------------------------------------------------% 
function phi = compute_phi(e)

% DIPUM3E Table 13.8.

phi(1) = e.eta20 + e.eta02;
phi(2) = (e.eta20 - e.eta02)^2 + 4*e.eta11^2;
phi(3) = (e.eta30 - 3*e.eta12)^2 + (3*e.eta21 - e.eta03)^2;
phi(4) = (e.eta30 + e.eta12)^2 + (e.eta21 + e.eta03)^2;
phi(5) = (e.eta30 - 3*e.eta12) * (e.eta30 + e.eta12) * ...
         ( (e.eta30 + e.eta12)^2 - 3*(e.eta21 + e.eta03)^2 ) + ...
         (3*e.eta21 - e.eta03) * (e.eta21 + e.eta03) * ...
         ( 3*(e.eta30 + e.eta12)^2 - (e.eta21 + e.eta03)^2 );
phi(6) = (e.eta20 - e.eta02) * ( (e.eta30 + e.eta12)^2 - ...
                                 (e.eta21 + e.eta03)^2 ) + ...
         4 * e.eta11 * (e.eta30 + e.eta12) * (e.eta21 + e.eta03);
phi(7) = (3*e.eta21 - e.eta03) * (e.eta30 + e.eta12) * ...
         ( (e.eta30 + e.eta12)^2 - 3*(e.eta21 + e.eta03)^2 ) + ...
         (3*e.eta12 - e.eta30) * (e.eta21 + e.eta03) * ...
         ( 3*(e.eta30 + e.eta12)^2 - (e.eta21 + e.eta03)^2 );
