function phin = levelsetIterate(phi,F,delT)
%levelsetIterate Iterative solution of level set equation.
%   PHIN = levelsetIterate(PHI,F,delT) computes the iterative solution
%   (see Eq. (12-55) in DIPUM3E) to the levelset equation. PHIN is the
%   new value of the level set function PHI; F is the force term, and
%   delT is the time increment, assumed to be in the range 0 < delT <=
%   1. If delT is not included in the arguments, it defaults to delT =
%   0.5*(1/max(F(:)). This function does one iteration, so generally it
%   is called numerous times in a loop.
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

% SET DEFAULTS.
if nargin == 2
    delT = 0.5*(1/max(F(:))); 

else
% Check to make sure deltT is valid.
    if delT > 1 || delT <=0
        warning('delT should be in the range 0 < delT <= 1')
    end
end

% COMPUTE UPWIND DERIVATIVES (EQ. (12-58) IN DIPUM3E.
[Dxplus,Dxminus,Dyplus,Dyminus] = upwindDerivatives(phi);
    
% COMPUTE THE UPWIND GRADIENT MAGNITUDES (EQ. (12-57) IN DIPUM3E).
[gMagPlus,gMagMinus] = upwindMagGrad(Dxplus,Dxminus,Dyplus,Dyminus);

% UPDATE PHI (EQ. (12-55) IN DIPUM3E).
phin = phi - delT*(max(F,0).*gMagPlus + min(F,0).*gMagMinus);

%----------------------------------------------------------------------%
function [Dxplus,Dxminus,Dyplus,Dyminus] = upwindDerivatives(phi)
%upwindDerivatives Computes first order upwind derivatives.
%   [Dxplus,Dxminus,Dyplus,Dyminus] = upwindDerivatives(PHI)
%   computes the upwind derivatives of level set function PHI using
%   first-order approximations. The equations used are:
%
%   Dxplus  = phi(x + 1, y) - phi(x, y)
%   Dxminus = phi(x, y) - phi(x - 1,y)
%   Dyplus  = phi(x, y + 1) - phi(x,y)
%   Dyminus = phi(x, y) - phi(x, y - 1)
%
%   The code is vectorized by using function circshift to perform
%   the shifts required to implement the preceding expressions for
%   all values of phi.

% Use function circshift to displace coordinates for speedy
% computation of the derivatives. Pad with a 1-pixel border of zeros
% to prevent the derivatives from wrapping around as a result of the
% circshift. Strip the border after the derivatives are computed.

phi = padarray(phi, [1 1], 0 ,'both');

Dxplus  = circshift(phi, 1, 1) - phi;
Dxminus = phi - circshift(phi, -1, 1);
Dyplus  = circshift(phi, 1, 2) - phi;
Dyminus = phi - circshift(phi, -1, 2);

% Strip out the border. Don't have to strip phi because it is not
% passed back.
Dxplus  = Dxplus(2:end-1, 2:end-1);
Dxminus = Dxminus(2:end-1, 2:end-1);
Dyplus  = Dyplus(2:end-1, 2:end-1);
Dyminus = Dyminus(2:end-1, 2:end-1);

%----------------------------------------------------------------------%
function [gMagPlus,gMagMinus] = upwindMagGrad(Dxplus,Dxminus,Dyplus,...
   Dyminus)
%upwindMagGrad computes the upwind gradient magnitude.
%   [gMagPlus,gMagMinus] = upwindMagGrad(Dxplus,Dxminus, Dyplus,
%   Dyminus) computes the two components of the upwind normalized
%   gradient of a level set function given the upwind derivatives
%   Dxplus, Dxminus, Dyplus, and Dyminus of the function. These
%   derivatives can be computed using function upWindDerivatives.

gMagPlus  = sqrt((max(Dxminus,0).^2) + (min(Dxplus,0).^2) ...
               + (max(Dyminus,0).^2) + (min(Dyplus,0).^2)); 
      
gMagMinus = sqrt((max(Dxplus,0).^2) + (min(Dxminus,0).^2) ...
               + (max(Dyplus,0).^2) + (min(Dyminus,0).^2));
           
%------------------------------------------------------------------------%
    
