function Qa = aggfcn(Q)
%AGGFCN Aggregation function for a fuzzy system.
%   QA = AGGFCN(Q) creates an aggregation function, QA, from a set of
%   implication functions, Q. Q is a cell array of function handles as
%   returned by IMPLFCNS. QA is a function handle that can be called
%   with a single input V using the syntax: q = QA(V).
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

Qa = @aggregate;

    function q = aggregate(v)
        q = Q{1}(v);
        for i = 2:numel(Q)
            q = max(q, Q{i}(v));
        end
    end

end
