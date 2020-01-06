function K = levelsetCurvature(phi,mode)
%levelsetCurvature Computes the curvature of a level set function.
%   K = levelsetCurvature(PHI,MODE) computes the curvature, K, of level
%   set function PHI. If MODE = 'Cu' the curvature is not normalized
%   (this is the default). If MODE = 'Cn', the curvature is normalized
%   by dividing it by its maximum value. This function is based on Eqs.
%   (12-61) and (12-62) of DIPUM3E.
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

% PRELIMINARIES
% Set default.
if nargin == 1
    mode = 'Cu';
end
[M,N] = size(phi);
phi = double(phi);

% PAD WITH 1'S TO BE ABLE TO COMPUTE THE DERIVATIVE AT IMAGE BORDERS.
phip = padarray(phi,[1 1],1,'both');

% COMPUTE THE CENTRAL DIFFERENCES.
phix = 0.5*(phip(3:end,2:N+1) - phip(1:M,2:N+1));
phiy = 0.5*(phip(2:M+1,3:end) - phip(2:M+1,1:N));
phixx = phip(3:end,2:N+1) + phip(1:M,2:N+1) - 2*phi;
phiyy = phip(2:M+1,3:end) + phip(2:M+1,1:N) - 2*phi;
phixy = 0.25.*(phip(3:end,3:end) - phip(1:M,3:end)...
                            - phip(3:end,1:N) + phip(1:M,1:N));
% COMPUTE THE CURVATURE.
DEN = (phix.^2 + phiy.^2 + eps).^1.5;
K = (phixx.*(phiy.^2) - 2*(phix.*phiy.*phixy) + phiyy.*(phix.^2))./DEN;

% CHECK FOR NORMALIZATION.
if isequal(mode,'Cn')
    K = K/max(abs(K(:)));
end
 
% COMPENSATE FOR BORDER EFFECTS BY SETTING THE FIRST AND LAST ROWS AND
% COLUMNS EQUAL TO THEIR IMMEDIATE PREDECESSORS. 
% CURVATURE 
% Rows.
K(:,1) = K(:,2);
K(:,end) = K(:,end-1);
% Columns.
K(1,:) = K(2,:);
K(end,:) = K(end-1,:);

