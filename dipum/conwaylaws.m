function out = conwaylaws(nhood)
%CONWAYLAWS Applies Conway's genetic laws to a single pixel.
%   OUT = CONWAYLAWS(NHOOD) applies Conway's genetic laws to a single
%   pixel and its 3-by-3 neighborhood, NHOOD. 
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

num_neighbors = sum(nhood(:)) - nhood(2, 2);
if nhood(2, 2) == 1
   if num_neighbors <= 1
      out = 0; % Pixel dies from isolation.
   elseif num_neighbors >= 4
      out = 0; % Pixel dies from overpopulation.
   else
      out = 1; % Pixel survives.
   end
else
   if num_neighbors == 3
      out = 1; % Birth pixel.
   else
      out = 0; % Pixel remains empty.
   end
end

