function F = levelsetForce(type,paramcell,normcell)
%LEVELSETFORCE Scalar force field for level-set segmentation.
%   F = LEVELSETFORCE(TYPE,PARAMCELL,NORMCELL) computes a scalar force
%	 field, F, of the type specified in TYPE:
%
%         TYPE                   Equation from Table 12.1
%       'binary'                          (1)
%       'gradient'                        (2)
%       'geodesic'                        (3)
%       'chanvese'                        (4) 
%
%	 In all cases, PARAMCELL is a cell array containing all the inputs
%   required to implement the force specified in TYPE.
%
%	 NORMCELL (an optional input) is a cell array containing one of two
%	 strings: NORMCELL = {str1, str2}. String srt1 can have one of two
%	 values: 'Fn' or 'Fu'. The first string causes the force F to be
%	 normalized by dividing it by its maximum absolute value. String 'Fu'
%	 leaves F unchanged. String str2 is used only when option 'chanvese'
%	 is used. It too can have one of two values: 'Cn' or 'Cu'. The first
%	 form causes the curvature to be normalized by dividing it by its
%	 maximum absolute value. The second form leaves the curvature
%	 unchanged. If str2 is included in NORMCELL, then str1 must be
%	 included also. The defaults if NORMCELL is not included in the
%	 function call are 'Fu' and 'Cu'.
%
%	 Syntax forms for levelsetForce are as follows:
%
%   F = levelsetForce('binary',{f,a,b}, normcell) where f is a binary
%	 image with values 0 and 1, implements the following function:
%
%                       F = a*f + b*(1 - f)
%
%	 This is Eq. (1) in Table 12.1. If force normalization is required,
%	 let normcell = 'Fu'. For no normalization, do not include normcell
%	 in the function call.
%
%	 F = levelsetForce('gradient',{f,p,lambda},normcell) implements the
%	 following function:
%   
%           F = 1./(1 + lambda*(||gradient(f)||)^p)
%
%	 where ||arg|| is the vector norm of arg. This is Eq. (2) in Table
%	 12.1. If force normalization is required, let normcell = {'Fn'}. For
%	 no normalization, do not include normcell in the function call.
%
%   F = levelsetForce('geodesic',{phi,W,c},normcell) implements the
%	 following function:
%
%        F = -div2D(W.*(phi./NORM(gradient(phi)))) - c*W
%
%	 where div2D computes the 2D divergence (see the Utility Functions
%	 folder in the DIP4E Support Package). This is Eq. (3) in Table 12.1.
%	 If force normalization is required, let normcell = {'Fn'}. For no
%	 normalization, do not include normcell in the function call.
%
%	 F = levelsetForce('chanvese',{f,phi,mu,nu,lambda1,lambda2},normcell)
%	 implements the following function:
%
%       F = -mu*div2D(phi) + nu + lamda1*((f - c1).^2) ... 
%                                           - lambda2*((f - c2).^2)
%
%	 where DIPUM3E utility function div2D computes the 2D divergence
%	 (curvature) of phi, as defined in Eq. (12-59) in DIPUM3E. If nu,
%	 lambda1, and lambda2 are not included in the input argument, they
%	 default to 0, 1, and 1, respectively. If force and/or curvature
%	 normalization is desired, normcell must contain two character
%	 strings: 'Fn' or 'Fu' for the force, and 'Cn' or 'Cu' for the
%	 curvature. For example, to normalize both set normcell =
%	 {'Fn','Cn'}. If neither normalization is needed, do not include
%	 normcell in the function call.
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

% IMPLEMENT THE SELECTED FORCE.
switch type
   case 'binary'
      f = paramcell{1};
      % Make sure the image is binary.
      f = double(imbinarize(f));
      a = paramcell{2};
      b = paramcell{3};
      F = a*f + b*(1 - f);
      if nargin == 3 && isequal(normcell{1},'Fn') 
         % Force normalization requested.
         F = F./max(abs(F(:)));
      end
	case 'gradient'
      f = paramcell{1};
      p = paramcell{2};
      lambda = paramcell{3};
      [gy,gx] = gradient(f);
      fnorm = sqrt(gx.^2 + gy.^2); 
      F = 1./(1 + lambda*(fnorm.^p));
      if nargin == 3 && isequal(normcell{1},'Fn') 
         % Force normalization requested.
         F = F./max(abs(F(:)));
      end
	case 'geodesic'
      phi = paramcell{1};
      c = paramcell{2};
      W = paramcell{3};
      % gradient is a MATLAB function.
      [phiy, phix] = gradient(phi);
      phinorm = sqrt(phix.^2 + phiy.^2);
      phixN = phix./phinorm;
      phiyN = phiy./phinorm;
      % div2D is a utility function in the DIP4E Support Package.
      F = -div2D(W.*phixN, W.*phiyN) - c*W;
      if nargin == 3 && isequal(normcell{1},'Fn')
         % Force normalization requested.
         F = F./max(abs(F(:)));
      end
	case 'chanvese'
      if numel(paramcell) == 3 % Default condition.
         f = paramcell{1};
         phi = paramcell{2};
         mu = paramcell{3};
         nu = 0;
         lambda1 = 1;
         lambda2 = 1;    
      else
         f = paramcell{1};
         phi = paramcell{2};
         mu = paramcell{3};
         nu = paramcell{4};
         lambda1 = paramcell{5};
         lambda2 = paramcell{6};
      end   
      % Compute the average values of f at points inside and outside the
      % contour. In the original algorithm, phi values on or inside the
      % contour are defined as positive and values outside as negative.
      % This is the opposite of the convention used in all other
      % functions. We follow the algorithm in the book and then
      % reconcile the difference at the end by changing the sign o the
      % force.
      idxIn = find(phi >= 0);
      idxOut = find(phi < 0);
      HS = levelsetHeaviside(phi,1);
      c1 = sum(sum(f.*HS))/(length(idxIn) + eps); 
      c2 = sum(sum(f.*(1 - HS)))/(length(idxOut) + eps);
      % A simpler method that often works well is: 
      %   c1 = mean2(f(phi >= 0));
      %   c2 = mean2(f(phi < 0));
      % Compute the curvature (check to see if curvature normalization
      % is requested. Curvature normalization usually is important).
      if nargin == 3 && numel(normcell) == 2 
         mode = normcell{2};
      else
         % Normalization of curvature not requested.
         mode = 'Cu'; 
      end
      V = levelsetCurvature(phi,mode);
      % Compute the force.
      F = mu*V + nu - lambda1*(f - c1).^2 + lambda2*(f - c2).^2;
      % Change the sign of the force to correspond with our convention.
      F = -F;
      % Check to see if F should be normalized (normalization can slow
      % down convergence).
      if nargin == 3 && numel(normcell) == 2 && isequal(normcell{1},'Fn')
         F = F/max(abs(F(:)));
      end
end


        




