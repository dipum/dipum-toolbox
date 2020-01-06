function [out, revertClass] = tofloat(in)
%TOFLOAT Converts an image to floating point.
%   [OUT, REVERTCLASS] = TOFLOAT(IN) converts the input image IN to
%   floating-point. If IN is a double or single image, then OUT
%   equals IN.  Otherwise, OUT equals IM2DOUBLE(IN).  REVERTCLASS is
%   a function handle that can be used to convert back to the class
%   of IN.
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

identity = @(x) x;

todouble = @im2double;

converter_table = {'uint8',   todouble, @im2uint8
   'uint16',  todouble, @im2uint16
   'int16',   todouble, @im2int16
   'logical', todouble, @logical
   'double',  identity, identity
   'single',  identity, identity};

classIndex = find(strcmp(class(in), converter_table(:, 1)));

if isempty(classIndex)
   error('Unsupported input image class.');
end

out = converter_table{classIndex, 2}(in);

revertClass = converter_table{classIndex, 3};
