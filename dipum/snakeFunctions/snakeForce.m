function [Fx,Fy] = snakeForce(emap,mode,mu,niter)
%SNAKEFORCE Components of external force for use in the snake algorithm.
%   [Fx,Fy] = SNAKEFORCE(EMAP,MODE,MU,NITER) uses input edge map, EMAP,
%   to compute the force component images Fx and Fy. These images are of
%   the same size as EMAP and contain the values of Fx and Fy at all
%   points of EMAP. For example, Fx(i,j) is the x-component of the
%   force at coordinates (i,j) of EMAP. If MODE = 'MOG' (the default),
%   force components Fx and Fy of the gradient of EMAP are computed
%   (remember, the gradient is a 2D vector). This mode does not require
%   MU nor NITER. If MODE = 'gvf' then the force is based on the
%   gradient vector flow of the edge map. Option 'gvf' requires that MU
%   and the number of iterations, NITER, be provided.
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
% Default.
if nargin == 1
	mode = 'MOG';
end
% Work with lower case.
mode = lower(mode);

% COMPUTE THE FORCE COMPONENTS.
% Note that MATLAB function gradient works with (c,r) intead of (r,c)
% coordinates, as we do in the book.
switch mode
	case 'mog'
      % Unnormalized gradient of the edge map.
      [Fy,Fx] = gradient(emap);
	case 'gvf'
      % Gradient vector flow of the edge map.
      % Compute the magnitude of the gradient squared. 
      [egy,egx] = gradient(emap);
      gradMagSq = (egx.^2 + egy.^2); % To be used later.
      % Initialize GVF to the gradient of the edge map.
      vx = egx;
      vy = egy;
      % Iterate to find vx and vy.
      for I = 1:niter
         % The 4 in the following expressions cancels the 1/4 in the
         % kernel used by the MATLAB Laplacian function del2.
         vx = vx + mu*4*del2(vx) - gradMagSq.*(vx - egx); 
         vy = vy + mu*4*del2(vy) - gradMagSq.*(vy - egy);
      end
      % Set the forces equal to the components of the gradient vector
      % flow [see Eq. (12-17)].
      Fx = vx;
      Fy = vy;
end
