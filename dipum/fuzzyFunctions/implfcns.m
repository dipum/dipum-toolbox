function Q = implfcns(L,outmf,varargin)
%IMPLFCNS Implication functions for a fuzzy system.
%   Q = IMPLFCNS(L,OUTMF,Z1,Z2,...,ZN) creates a set of implication
%   functions from a set of lambda functions L, a set of output member
%   functions OUTMF, and a set of fuzzy system inputs Z1, Z2, ..., ZN. L
%   is a cell array of rule-strength function handles as returned by
%   LAMBDAFCNS. OUTMF is a cell array of output membership functions.
%   The number of elements of OUTMF can either be numel(L) or
%   numel(L)+1. If numel(OUTMF) is numel(L) + 1, then the "extra"
%   membership function is applied to an automatically computed "else
%   rule." (See Section 3.6). The inputs Z1, Z2, etc., can all be
%   scalars, or they can all be vectors of the same size (i.e., these
%   vectors would contain multiple values for each of the inputs).
%
%   Q is a 1-by-numel(OUTMF) cell array of implication function handles.
%
%   Call the i-th implication function on an input V using the 
%   syntax: q_i = Q{i}(V)
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

Z = varargin;

% Initialize output cell array.
num_rules = numel(L);
Q = cell(1,numel(outmf));
lambdas = zeros(1,num_rules);

for i = 1:num_rules
   lambdas(i) = L{i}(Z{:});
end

for i = 1:num_rules
   % Each output implication function calls implication() with i (to
   % identify which lambda value should be used), followed by V.
   Q{i} = @(v) implication(i,v);
end

if numel(outmf) == (num_rules + 1)
   Q{num_rules + 1} = @elseRule;
end

   %-------------------------------------------------------------------%
   function q = implication(i,v)
      q = min(lambdas(i),outmf{i}(v));
   end

   %-------------------------------------------------------------------%
   function q = elseRule(v)
      lambda_e = min(1 - lambdas);
      q = min(lambda_e,outmf{end}(v));
   end

end
