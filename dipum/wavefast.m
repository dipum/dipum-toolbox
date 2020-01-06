function [c,s] = wavefast(x,n,varargin)
%WAVEFAST Computes the FWT of a '3-D extended' 2-D array.
%   [C, L] = WAVEFAST(X, N, LP, HP, EXTMODE) computes 'PAGES' 2D N-level
%   FWTs of a 'ROWS x COLUMNS x PAGES' matrix X with respect to
%   decomposition filters LP and HP and boundary extension mode EXTMODE.
%
%   [C, L] = WAVEFAST(X, N, WNAME, EXTMODE) performs the same operation
%   but fetches filters LP and HP for wavelet WNAME using WAVEFILTER.
%
%   Scale parameter N must be less than or equal to log2 of the maximum
%   image dimension.  Filters LP and HP must be even. If EXTMODE = 'SYM'
%   (the default), X is symmetrically extended; if X = [c1 c2 c3 ... cn]
%   (in 1D), then its symmetric extension would be [... c3 c2 c1 c1 c2
%   c3 ... cn cn cn-1 cn-2 ...]. If EXTMODE = 'PER', X is periodically
%   extended to [... cn-1 cn c1 c2 c3 ... cn c1 c2 ...].
%
%   OUTPUTS:
%     Vector C is a coefficient decomposition vector:
%
%      C = [ a1(n)...ak(n) h1(n)...hk(n) v1(n)...vk(n)
%            d1(n)...dk(n) h1(n-1)... d1(1)...dk(1) ]
%
%     where ai, hi, vi, and di for i = 0,1,...k are columnwise vectors
%     containing approximation, horizontal, vertical, and diagonal
%     coefficient matrices, respectively, and k is the number of pages
%     in the 3-D extended array X. C has 3n + 1 sections where n is the
%     number of wavelet decompositions.
%
%     Matrix S is an [(n+2) x 2] bookkeeping matrix if k = 1; else it is
%     [(n+2) x 3]:
%
%      S = [ sa(n, :); sd(n, :); sd(n-1, :); ... ; sd(1, :); sx ]
%
%     where sa and sd are approximation and detail size entries.
%
%   See also WAVEBACK and WAVEFILTER.
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

% Check the input arguments for reasonableness.
extmode = 'SYM';
if ischar(varargin{1})
   [lp,hp] = wavefilter(varargin{1},'d');
   if nargin > 3
      extmode = varargin{2};
   end
else
   lp = varargin{1};   hp = varargin{2};
   if nargin > 4
      extmode = varargin{3};
   end
end

% Get the filter length, 'lp', input array size, 'sx', and number of
% pages, 'pages', in extended 2-D array x.
fl = length(lp);       sx = size(x);        pages = size(x,3);

if ((~ismatrix(x)) && (ndims(x) ~= 3)) || (min(sx) < 2) ...
      || ~isreal(x) || ~isnumeric(x)
   error('X must be a real, numeric 2-D or 3-D matrix.');
end

if (~ismatrix(lp)) || ~isreal(lp) || ~isnumeric(lp) ...
      || (~ismatrix(hp)) || ~isreal(hp) || ~isnumeric(hp) ...
      || (fl ~= length(hp)) || rem(fl,2) ~= 0
   error(['LP and HP must be even and equal length real, ' ...
      'numeric filter vectors.']);
end

if ~isreal(n) || ~isnumeric(n) || (n < 1) || (n > log2(max(sx)))
   error(['N must be a real scalar between 1 and ' ...
      'log2(max(size((X))).']);
end

% Init the starting output data structures and initial approximation.
c = [];        s = sx(1:2);
app = cell(pages, 1);
for i = 1:pages
   app{i} = double(x(:,:,i));
end

% For each decomposition ...
for i = 1:n
   % Extend the approximation.
   [app,keep] = extend(app,fl,pages,extmode);
   
   % Convolve rows with HP and downsample. Then convolve columns
   % with HP and LP to get the diagonal and vertical coefficients.
   rows = convolve(app,hp,'row',fl,keep,pages,extmode);
   coefs = convolve(rows,hp,'col',fl,keep,pages,extmode);
   c = addcoefs(c,coefs,pages);
   s = [size(coefs{1}); s];
   coefs = convolve(rows,lp,'col',fl,keep,pages,extmode);
   c = addcoefs(c,coefs,pages);
   
   % Convolve rows with LP and downsample. Then convolve columns
   % with HP and LP to get the horizontal and next approximation
   % coeffcients.
   rows = convolve(app,lp,'row',fl,keep,pages,extmode);
   coefs = convolve(rows,hp,'col',fl,keep,pages,extmode);
   c = addcoefs(c,coefs,pages);
   app = convolve(rows,lp,'col',fl,keep,pages,extmode);
end

% Append the final approximation structures.
c = addcoefs(c,app,pages);
s = [size(app{1}); s];
if ~ismatrix(x)
   s(:,3) = size(x,3);
end

%----------------------------------------------------------------------%
function nc = addcoefs(c,x,pages)
% Add 'pages' array coefficients to the wavelet decomposition vector.

nc = c;
for i = pages:-1:1
   nc = [x{i}(:)' nc];
end

%----------------------------------------------------------------------%
function [y,keep] = extend(x,fl,pages,extmode)
% Extend the 'pages' arrays of x in both dimensions and return
% 'keep' to determine the number of coefficients to keep after
% convolution and downsampling.

y = cell(pages,1);
for i = 1:pages
   if strcmpi(extmode,'SYM')
      keep = floor((fl + size(x{i}) - 1) / 2);
      y{i} = padarray(x{i},[(fl - 1) (fl - 1)],'symmetric','both');
   elseif strcmpi(extmode,'PER')
      keep = size(x{i});
      y{i} = padarray(x{i},[fl/2 fl/2],'circular','both');
   else
      error('Invalid extension mode!');
   end
end

%----------------------------------------------------------------------%
function y = convolve(x,h,type,fl,keep,pages,extmode)
% For the 'pages' 2-D arrays in x, convolve the rows or columns with
% h, downsample, and extract the section defined by 'keep'.

y = cell(pages,1);
for i = 1:pages
   if strcmp(type,'row')
      if strcmpi(extmode, 'SYM')
         y{i} = conv2(x{i},h);
         y{i} = y{i}(:,1:2:end);
         y{i} = y{i}(:,fl / 2 + 1:fl / 2 + keep(2));
      else
         y{i} = conv2(x{i},h,'valid');
         y{i} = y{i}(:, 2:2:2 * ceil(keep(2) / 2));
      end
   else
      if strcmpi(extmode,'SYM')
         y{i} = conv2(x{i},h');
         y{i} = y{i}(1:2:end,:);
         y{i} = y{i}(fl / 2 + 1:fl / 2 + keep(1), :);
      else
         y{i} = conv2(x{i},h','valid');
         y{i} = y{i}(2:2:2 * ceil(keep(1) / 2),:);
      end
   end
end
