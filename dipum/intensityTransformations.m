function g = intensityTransformations(f,method,varargin)
%intensityTransformations Grayscale image intensity transformations.
%   G = intensityTransformations(F,'neg') computes the negative of the
%   input image F.
% 
%   G = intensityTransformations(F,'log',C,CLASS) computes C*log(1 + F)
%   and multiplies the result by (positive) constant C. If the last
%   parameters is omitted, C defaults to 1. Because the log is used
%   frequently to display Fourier spectra, parameter CLASS offers the
%   option to specify the class of the output as 'uint8' or 'uint16'. If
%   parameter CLASS is omitted, the output is of the same class as the
%   input.
%
%   G = intensityTransformations(F,'gamma',GAM) performs a gamma
%   transformation on the input image using parameter GAM (a required
%   input).
%
%   G = intensityTransformations(F,'stretch',M,E) computes a contrast
%   stretching transformation using the expression 1./(1 + (M./F).^E).
%   Parameter M must be in the range [0,1]. The default value for M is
%   mean2(tofloat(F)), and the default value for E is 4.
%
%   G = intensityTransformations(F,'specified',TXFUN) performs the
%   intensity transformation s = TXFUN(r) where r are input intensities,
%   s are output intensities, and TXFUN is an intensity transformation
%   (mapping) function, expressed as a vector with values in the range
%   [0,1]. TXFUN must have at least two values.
%
%   For the 'neg', 'gamma', 'stretch' and 'specified' transformations,
%   floating-point input images whose values are outside the range [0,1]
%   are scaled first using MAT2GRAY. Other images are converted to
%   floating point using TOFLOAT. For the 'log' transformation,
%   floating-point images are transformed without being scaled; other
%   images are converted to floating point first using TOFLOAT.
%
%   The output is of the same class as the input, except if a different
%   class is specified for the 'log' option.
%
%   This function utilizes DIPUM3E utility function TOFLOAT.  
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

% Verify that the number of inputs is between two and four.
narginchk(2,4)

if isequal(method,'log')
   % The log transformation handles image classes differently than the
   % other transformations, so let the logTransform function handle that
   % and then return.
   g = logTransform(f,varargin{:});
   return;
end

% If f is floating point, check to see if it is in the range [0 1]. If
% it is not, force it to be using function mat2gray.
if isfloat(f) && (max(f(:)) > 1 || min(f(:)) < 0)
   f = mat2gray(f);
end
[f,revertclass] = tofloat(f); % Store class of f for use later.

% Perform the intensity transformation specified.    
switch method
case 'neg' 
   g = imcomplement(f); 

case 'gamma'
   g = gammaTransform(f,varargin{:});
   
case 'stretch'
   g = stretchTransform(f,varargin{:});
   
case 'specified'
   g = specifiedTransform(f,varargin{:});
   
otherwise
   error('Unknown enhancement method.')
end

% Convert to the class of the input image.
g = revertclass(g);

%----------------------------------------------------------------------%
function g = gammaTransform(f,gamma)
g = imadjust(f,[ ],[ ],gamma);

%----------------------------------------------------------------------%
function g = stretchTransform(f,varargin)
if isempty(varargin)
   % Use defaults.
   m = mean2(f);
   E = 4.0;
elseif length(varargin) == 2
   m = varargin{1};
   E = varargin{2};
else
   error("Incorrect number of inputs for the 'stretch' method.")
end
g = 1./(1 + (m./f).^E);

%----------------------------------------------------------------------%
function g = specifiedTransform(f,txfun)
% f is floating point with values in the range [0 1].
txfun = txfun(:); % Force it to be a column vector.
if any(txfun) > 1 || any(txfun) <= 0
   error('All elements of txfun must be in the range [0 1].')
end
T = txfun;
X = linspace(0,1,numel(T))';
g = interp1(X,T,f); 

%----------------------------------------------------------------------%
function g = logTransform(f,varargin)
[f,revertclass] = tofloat(f);
if numel(varargin) >= 2
   if strcmp(varargin{2},'uint8')
      revertclass = @im2uint8;
   elseif strcmp(varargin{2},'uint16')
      revertclass = @im2uint16;
   else
      error("Unsupported CLASS option for 'log' method.")
   end
end
if numel(varargin) < 1
   % Set default for C.
   C = 1;
else
   C = varargin{1};
end
g = C * (log(1 + f));
g = revertclass(g);
