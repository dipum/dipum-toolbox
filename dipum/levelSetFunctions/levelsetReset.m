function phinew = levelsetReset(phi,niter,delT)
%levelsetReset Reinitializes a signed distance function.
%   PHINEW = levelsetReset(PHI,NITER,delT) reinitializes level set
%   function PHI so that its Euclidean norm is 1, as required of a
%   signed distance function. This is done by evolving the equation
%
%               d/dt(phi) = sign(phi)(1 - ||grad(phi)||)
%   
%   At steady state, the term ||grad(phi)|| will equal 1 at all
%   coordinates, within a stopping rule given by
%
%           sum(abs(phinew(:) - phi(:))) < delT*max(M,N)
%
%   
%   NITER is the number of iterations--It defaults to 5. DELT is the
%   time step used in iteration. Its default value is 0.5.
%
%   The method used here is based on the approach described in "A Level
%   Set Approach for Computing Solutions to Incompressible Two-Phase
%   Flow," by M. Sussman, Peter Smereka, and Stanley Osher, J. Comput.
%   Phys., vol. 114, pp. 146-149, 1994.
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

% PRELIMINARIES.
% Set defaults.
if nargin == 2
   delT = 0.5;
elseif nargin == 1
   delT = 0.5;
   niter = 5; 
end
% Size and sign of original function.
[M,N] = size(phi);
phi0 = phi;
S = sign(phi0);

% NORMALIZED GRADIENT.
[phi0y,phi0x] = gradient(phi0);
phi0 = phi0./(hypot(phi0x,phi0y) + eps);

% ITERATE
% To gain speed, the stopping rule is a modification of the one proposed
% in the paper.
for I = 1:niter
    phinew = phi - delT*S.*computeG(phi,phi0);
    if sum(abs(phinew(:) - phi(:))) < delT*max(M,N)
        break
    end
    phi = phinew;
end
   
%----------------------------------------------------------------------%
function G = computeG(phi,phi0)
% G is the gradient of all values of phi, but taking into account
% where phi was positive, negative, or zero. This is necessary so
% that movement during iteration will be in the correct direction.
% The resulting G will be of size M-by-N.

% Pad the input to handle derivative computations at border points. 
% The padding adds one row/col all around.
phi = padarray(phi,[1 1], 'replicate', 'both');

% Size of padded array.
[Mpad,Npad] = size(phi);

% For computations of derivatives, the indices will then be 2:Mpad-1
% and 2:Npad-1 on the padded result.

% The following definitions are from pg 153 of the reference. We are
% assuming a grid spacing of h = 1.
i = 2:Mpad-1; % Row indices.
j = 2:Npad-1; % Col indices.
% a, b, c, and d are of size M-by-N.
a = phi(i,j) - phi(i-1,j); % Backward difference in the x-direction.
b = phi(i+1,j) - phi(i,j); % Forward difference in the x-direction.
c = phi(i,j) - phi(i,j-1); % Backward difference in the y-direction.
d = phi(i,j+1) - phi(i,j); % Forward difference in the y-direction.

% Conditions on the derivatives to be used below.
aplus = max(a,0); aminus = min(a,0);
bplus = max(b,0); bminus = min(b,0);
cplus = max(c,0); cminus = min(c,0);
dplus = max(d,0); dminus = min(d,0);

% The conditions on G (to be defined below) depend on the sign of
% phi0.
Ap = phi0 > 0;
An = phi0 < 0;

% G is the gradient of all values of phi, but taking into account
% where phi was positive, negative, or zero. This is necessary so
% that movement during iteration will be in the correct direction.
% Note that G will be zero in locations where phi was zero.

Gp = sqrt(max(aplus.^2, bminus.^2) + max(cplus.^2, dminus.^2)) - 1;
Gn = sqrt(max(aminus.^2, bplus.^2) + max(cminus.^2, dplus.^2)) - 1;
G = Gp.*Ap + Gn.*An; 
