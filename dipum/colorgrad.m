function [VG,A,PPG]= colorgrad(f,T)
%COLORGRAD Computes the vector gradient of an RGB image.
%   [VG,VA,PPG] = COLORGRAD(F,T) computes the vector gradient, VG, and
%   corresponding angle array, VA, (in radians) of RGB image F. It also
%   computes PPG, the per-plane composite gradient obtained by summing
%   the 2-D gradients of the individual color planes. Input T is a
%   threshold in the range [0,1]. If it is included in the input,
%   outputs VG and PPG are logical matrices such that VG(x,y) = 0 for
%   values <= T and VG(x,y) = 1 otherwise. Similar comments apply to
%   PPG. If T is not included in the input argument, then both output
%   gradients are scaled to the double range [0,1].
%
%  All equations on which this function is based are from Chapter 7 of
%  DIPUM3E.
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

if size(f,3) ~= 3
   error('Input image must be of size M-by-N-by-3');
end

if nargin == 2 && (T < 0 || T > 1)
   error('T must be in the range [0 1]')
end

% Compute the x and y derivatives of the three component images using
% Sobel operators.
sh = fspecial('sobel');
sv = sh';
Rx = imfilter(double(f(:,:,1)),sh,'replicate');
Ry = imfilter(double(f(:,:,1)),sv,'replicate');
Gx = imfilter(double(f(:,:,2)),sh,'replicate');
Gy = imfilter(double(f(:,:,2)),sv,'replicate');
Bx = imfilter(double(f(:,:,3)),sh,'replicate');
By = imfilter(double(f(:,:,3)),sv,'replicate');

% Compute the parameters of the vector gradient. 
gxx = Rx.^2 + Gx.^2 + Bx.^2;
gyy = Ry.^2 + Gy.^2 + By.^2;
gxy = Rx.*Ry + Gx.*Gy + Bx.*By;
A = 0.5*(atan(2*gxy./(gxx - gyy + eps)));
G1 = 0.5*((gxx + gyy) + (gxx - gyy).*cos(2*A) + 2*gxy.*sin(2*A));

% Now repeat for angle + pi/2. Then select the maximum at each point.
A = A + pi/2;
G2 = 0.5*((gxx + gyy) + (gxx - gyy).*cos(2*A) + 2*gxy.*sin(2*A));
G1 = G1.^0.5;
G2 = G2.^0.5;

% Form VG by picking the maximum at each (x,y) and then scale
% to the range [0,1] using function mat2gray.
VG = mat2gray(max(G1,G2));

% Select the corresponding angles. Where G2 is greater than G1, pick
% values from array A + pi/2. Else, use values from A, which correspond
% to G1. The angles are in radians.
A(G2 > G1) = A(G2 > G1) + pi/2;

% Compute the per-plane gradients.
RG = hypot(Rx,Ry);
GG = hypot(Gx,Gy);
BG = hypot(Bx,By);
% Form the composite by adding the individual results and scale to
% [0,1].
PPG = mat2gray(RG + GG + BG);

% If T was provided, threshold the result.
if nargin == 2
   VG = VG > T;
   PPG = PPG > T;
end
