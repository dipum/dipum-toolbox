function L = lambdafcns(inmf,op)
%LAMBDAFCNS Lambda functions for a set of fuzzy rules.
%   L = LAMBDAFCNS(INMF,OP) creates a set of lambda functions (rule
%   strength functions) corresponding to a set of fuzzy rules. L is a
%   cell array of function handles. INMF is an M-by-N matrix of input
%   membership function handles. M is the number of rules, and N is the
%   number of fuzzy system inputs. INMF(i,j) is the input membership
%   function applied by the i-th rule to the j-th input. For example, in
%   the case of Fig. 3.24, INMF would be of size 3-by-2 (three rules and
%   two inputs).
%
%   OP is a function handle used to combine the antecedents for each
%   rule. OP can be either @min or @max. If omitted, the default value
%   for OP is @min.
%
%   The output lambda functions are called later with N inputs,
%   Z1,Z2,... ZN, to determine rule strength:
%   lambda_i = L{i}(Z1,Z2,...,ZN)
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

if nargin < 2
   % Set default operator for combining rule antecedents.
   op = @min;
end

num_rules = size(inmf,1);
L = cell(1,num_rules);

for i = 1:num_rules
   % Each output lambda function calls the ruleStrength() function with
   % i (to identify which row of the rules matrix should be used),
   % followed by all the Z input arguments (which are passed along via
   % varargin).
   L{i} = @(varargin) ruleStrength(i,varargin{:});
end

   %---------------------------------------------------------------%
   function lambda = ruleStrength(i,varargin)
      % lambda = ruleStrength(i,Z1,Z2,Z3,...)
      Z = varargin;
      % Initialize lambda as the output of the first membership function
      % of the k-th rule.
      memberfcn = inmf{i,1};
      lambda = memberfcn(Z{1});
      for j = 2:numel(varargin)
         memberfcn = inmf{i,j};
         lambda = op(lambda,memberfcn(Z{j}));
      end
   end

end
