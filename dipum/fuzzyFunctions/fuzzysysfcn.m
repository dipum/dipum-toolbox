function F = fuzzysysfcn(inmf,outmf,vrange,op)
%FUZZYSYSFCN Fuzzy system function.
%   F = FUZZYSYSFCN(INMF,OUTMF,VRANGE,OP) creates a fuzzy system
%   function, F, corresponding to a set of rules and output membership
%   functions. INMF is an M-by-N matrix of input membership function
%   handles. M is the number of rules, and N is the number of fuzzy
%   system inputs. OUTMF is a cell array containing output membership
%   functions. numel(OUTMF) can be either M or M + 1. If it is M + 1,
%   then the "extra" output membership function is used for an
%   automatically computed "else rule." VRANGE is a two-element vector
%   specifying the valid range of input values for the output membership
%   functions. OP is a function handle specifying how to combine the
%   antecedents for each rule. OP can be either @min or @max. If OP is
%   omitted, then @min is used.
%
%  The output, F, is a function handle that computes the fuzzy system's
%  output, given a set of inputs, using the syntax: 
%  out = F(Z1,Z2,Z3,...,ZN);
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

if nargin < 4
   op = @min;
end

% The lambda functions are independent of the inputs Z1,Z2,...,ZN, so
% they can be computed in advance.
L = lambdafcns(inmf,op);

F = @fuzzyOutput;

   %-------------------------------------------------------------------%
   function out = fuzzyOutput(varargin)
      Z = varargin;
      % The implication functions and aggregation functions have to be
      % computed separately for each input value.  Therefore we have to
      % loop over each input value to determine the corresponding output
      % value. Zk is a cell array that will be used to pass scalar
      % values for each input (Z1,Z2,...,ZN) to IMPLFCNS.
      Zk = cell(1,numel(Z));
      % Initialize the array of output values to be the same size as the
      % first input,Z{1}.
      out = zeros(size(Z{1}));
      for k = 1:numel(Z{1})
         for p = 1:numel(Zk)
            Zk{p} = Z{p}(k);
         end
         Q = implfcns(L,outmf,Zk{:});
         Qa = aggfcn(Q);
         out(k) = defuzzify(Qa,vrange);
      end
   end

end
