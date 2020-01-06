function G = approxfcn(F,range)
%APPROXFCN Approximation function.
%   G = APPROXFCN(F,RANGE) returns a function handle, G, that
%   approximates the function handle F by using a lookup table. RANGE is
%   an M-by-2 matrix specifying the input range for each of the M inputs
%   to F.
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

num_inputs = size(range,1);
max_table_elements = 10000;
max_table_dim = 100;
table_dim = min(floor(max_table_elements^(1/num_inputs)), ...
   max_table_dim);

% Compute the input grid values.
inputs = cell(1,num_inputs);
grid = cell(1,num_inputs);
for k = 1:num_inputs
   grid{k} = linspace(range(k,1),range(k,2),table_dim);
end

if num_inputs > 1
   [inputs{:}] = ndgrid(grid{:});
else
   inputs = grid;
end

% Initialize the lookup table.
table = zeros(size(inputs{1}));

% Initialize the waitbar.
bar = waitbar(0,'Working...');

% Initialize the cell array used to pass inputs to F.
Zk = cell(1,num_inputs);
L = numel(inputs{1});
% Update the progress bar at 2% intervals.
waitbar_update_interval = ceil(0.02 * L);

for p = 1:L
   for k = 1:num_inputs
      Zk{k} = inputs{k}(p);
   end
   table(p) = F(Zk{:});
   if (rem(p,waitbar_update_interval) == 0)
      % Update the progress bar.
      waitbar(p/L);
   end
end
close(bar)

G = @tableLookupFcn;

   %-------------------------------------------------------------------%
   function out = tableLookupFcn(varargin)
      if num_inputs > 1
         out = interpn(grid{:},table,varargin{:});
      else
         out = interp1(grid{1},table,varargin{1});
      end
   end

end
