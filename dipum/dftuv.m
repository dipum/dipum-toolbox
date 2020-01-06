function [U,V] = dftuv(M,N)
%DFTUV Computes meshgrid frequency matrices.
%   [U,V] = DFTUV(M,N) computes meshgrid frequency matrices U and V. U
%   and V are useful for computing frequency-domain filter transfer
%   functions that can be used with function DFTFILT. U and V are both
%   of size M-by-N and of class double.
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

% Set up range of variables.
u = 0:(M - 1);
v = 0:(N - 1);

% Compute the indices for use in meshgrid.
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays. 
[V,U] = meshgrid(v,u);

