%UNRAVEL Decodes a variable-length bit stream.
%   X = UNRAVEL(Y,LINK,XLEN) decodes UINT16 input vector Y based on
%   transition and output table LINK. The elements of Y are considered
%   to be a contiguous stream of encoded bits--i.e., the MSB of one
%   element follows the LSB of the previous element. Input XLEN is the
%   number code words in Y, and thus the size of output vector X (class
%   DOUBLE). Input LINK is a transition and output table (that drives a
%   series of binary searches):
%
%    1. LINK(0) is the entry point for decoding, i.e., state n = 0.
%    2. If LINK(n) < 0, the decoded output is |LINK(n)|; set n = 0.
%    3. If LINK(n) > 0, get the next encoded bit and transition to
%       state [LINK(n) - 1] if the bit is 0, else LINK(n).
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

