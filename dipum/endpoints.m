function g = endpoints(f)
%ENDPOINTS Computes end points of a binary image.
%   G = ENDPOINTS(F) computes the end points of the binary image F
%   and returns them in the binary image G. 
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

persistent lut

if isempty(lut)
   lut = makelut(@endpoint_fcn, 3);
end

g = applylut(f,lut);

%------------------------------------------------------------------%
function is_end_point = endpoint_fcn(nhood)
%   Determines if a pixel is an end point.
%   IS_END_POINT = ENDPOINT_FCN(NHOOD) accepts a 3-by-3 binary
%   neighborhood, NHOOD, and returns a 1 if the center element is an
%   end point; otherwise it returns a 0. 

interval1 = [0  1  0; -1  1 -1; -1 -1 -1];
interval2 = [1 -1 -1; -1  1 -1; -1 -1 -1];

% Use bwhitmiss to see if the input neighborhood matches either
% interval1 or interval2, or any of their 90-degree rotations.
for k = 1:4
   % rot90(A, k) rotates the matrix A by 90 degrees k times.
   C = bwhitmiss(nhood, rot90(interval1, k));
   D = bwhitmiss(nhood, rot90(interval2, k));
   if (C(2,2) == 1) || (D(2,2) == 1)
      % Pixel neighborhood matches one of the end-point
      % configurations, so return true.
      is_end_point = true;
      return
   end
end

% Pixel neighborhood did not match any of the end-point
% configurations, so return false.
is_end_point = false;

