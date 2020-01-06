function D = div2D(gx,gy)
%DIV2D Computes the divergence of a 2D vector field.
%   D = DIV2D(GX,GY) computes the divergence treating GX as the
%   x-component and GY as the y-component of the a 2D vector field. if
%   GX and GY are arrays of size M-by-N, then D is an array of the same
%   size, with D(i,j) = d/dx(GX(i,j)) + d/dy(GY(i,j)).
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

% Compute the divergence using central differences for the derivatives.
% MATLAB's divergence.m function does not do a good job on the edges
% leading to innacuracies that are significant in terms of level set
% computations.

% Pad the inputs.
gxp = padarray(gx,[1,0],'symmetric','both');
gyp = padarray(gy,[0,1],'symmetric','both');

% Vectorized code of central differences using symmetric padding.
[M,N] = size(gx); % gy and gx are of the same size.
dx(1:M,:) = (gxp(3:M+2,:) - gxp(1:M,:))/2;
dy(:,1:N) = (gyp(:,3:N+2) - gyp(:,1:N))/2; 

D = dx + dy;

