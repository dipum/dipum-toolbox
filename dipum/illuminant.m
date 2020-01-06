function T = illuminant(type)
%illuminant Spectral power distribution of common illuminants.
%
%   illuminant(type) returns a table containing the spectral power
%   distribution of the specified type of illuminant. The input
%   argument, type, can be 'D50', 'D55', 'D65', 'D75', 'A', or 'C'.
%
%   See Table T.1, Relative spectral power distributions of CIE
%   illuminants, CIE 15:2004, Technical Report on Colorimetry.
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

type = upper(type);
if ~ismember(type,{'D50','D55','D65','D75','A','C','F7'})
    error('Unrecognized illuminant type: %s',type)
end

T = readtable('Illuminants.xlsx','UseExcel',false,...
    'Sheet',type);

        
