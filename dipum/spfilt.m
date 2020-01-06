function f = spfilt(g,type,varargin)
%SPFILT Performs linear and nonlinear spatial filtering.
%   F = SPFILT(G,TYPE,VARARGIN) performs spatial filtering of image
%	 G using a TYPE filter of size m-by-n. The output image F is of the
%	 same class as the input. Valid calls to SPFILT are as follows:
%
%     F = SPFILT(G,'amean',m,n)          Arithmetic mean filtering.
%     F = SPFILT(G,'gmean',m,n)          Geometric mean filtering.
%     F = SPFILT(G,'hmean',m,n)          Harmonic mean filtering.
%     F = SPFILT(G,'chmean',m,n,Q)       Contraharmonic mean
%                                        filtering of order Q. The
%                                        default value of Q is 1.5.
%     F = SPFILT(G,'median',m,n)         Median filtering.
%     F = SPFILT(G,'max',m,n)            Max filtering.
%     F = SPFILT(G,'min',m,n)            Min filtering.
%     F = SPFILT(G,'midpoint',m,n)       Midpoint filtering.
%     F = SPFILT(G,'atrimmed',m,N,n)     Alpha-trimmed mean 
%                                        filtering. Parameter D must 
%                                        be a nonnegative even 
%                                        integer; its default value 
%                                        is 2.
%
%   The default values when only G and TYPE are input are m = n = 3,
%   Q = 1.5, and D = 2. 
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

% Process inputs using the local function parseInputs.
[m,n,Q,d] = parseInputs(varargin{:});

% Do the filtering using Toolbox or local functions.
switch type
case 'amean'
   w = fspecial('average',[m n]);
   f = imfilter(g,w,'replicate');
case 'gmean'
   f = gmean(g,m,n);
case 'hmean'
   f = harmean(g,m,n);
case 'chmean'
   f = charmean(g,m,n,Q);
case 'median'
   f = medfilt2(g,[m n],'symmetric');
case 'max'
   f = imdilate(g,ones(m,n));
case 'min'
   f = imerode(g,ones(m,n));
case 'midpoint'
   f1 = ordfilt2(g,1,ones(m,n),'symmetric');
   f2 = ordfilt2(g,m*n,ones(m,n),'symmetric');
   f = imlincomb(0.5,f1,0.5,f2);
case 'atrimmed'
   f = alphatrim(g,m,n,d);
otherwise
   error('Unknown filter type.')
end

%----------------------------------------------------------------------%
function f = gmean(g,m,n)
%  Implements a geometric mean filter.
[g,revertClass] = tofloat(g);
f = exp(imfilter(log(g),ones(m,n),'replicate')).^(1/m/n);
f = revertClass(f);

%----------------------------------------------------------------------%
function f = harmean(g,m,n)
%  Implements a harmonic mean filter.
[g,revertClass] = tofloat(g);
f = m*n ./ imfilter(1./(g + eps),ones(m,n),'replicate');
f = revertClass(f);

%----------------------------------------------------------------------%
function f = charmean(g,m,n,q)
%  Implements a contraharmonic mean filter.
[g,revertClass] = tofloat(g);
f = imfilter(g.^(q+1),ones(m,n),'replicate');
f = f ./ (imfilter(g.^q,ones(m,n),'replicate') + eps);
f = revertClass(f);

%----------------------------------------------------------------------%
function f = alphatrim(g,m,n,d)
%  Implements an alpha-trimmed mean filter.

if (d <= 0) || (d/2 ~= round(d/2))
   error('d must be a positive, even integer.')
end

[g,revertClass] = tofloat(g);
f = imfilter(g,ones(m,n),'symmetric');
for k = 1:d/2
   f = f - ordfilt2(g,k,ones(m,n),'symmetric');
end
for k = (m*n - (d/2) + 1):m*n
   f = f - ordfilt2(g,k,ones(m,n),'symmetric');
end
f = f/(m*n - d);
f = revertClass(f);

%----------------------------------------------------------------------%
function [m,n,Q,d] = parseInputs(varargin)

m = 3;
n = 3;
Q = 1.5;
d = 2;

if nargin > 0
   m = varargin{1};
end

if nargin > 1
   n = varargin{2};
end

if nargin > 2
   Q = varargin{3};
   d = varargin{3};
end


