function [varargout] = waveback(c,s,varargin)
%WAVEBACK Computes inverse FWTs for multi-level decomposition [C, S].
%   [VARARGOUT] = WAVEBACK(C, S, VARARGIN) performs a 2D N-level partial
%   or complete wavelet reconstruction of decomposition structure [C,
%   S].
%
%   SYNTAX:
%   Y = WAVEBACK(C, S, 'WNAME', 'EXTMODE');  Output inverse FWT matrix Y 
%   Y = WAVEBACK(C, S, LR, HR, 'EXTMODE');   using lowpass and highpass 
%                                            reconstruction filters (LR
%                                            and HR) or filters obtained
%                                            by calling WAVEFILTER with
%                                            'WNAME'. 
%
%   [NC, NS] = WAVEBACK(C, S, 'WNAME', 'EXTMODE', N); Output new wavelet 
%   [NC, NS] = WAVEBACK(C, S, LR, HR, 'EXTMODE', N);  decomposition
%                                                     structure [NC, NS]
%                                                     after N step 
%                                                     reconstruction.
%
%   See also WAVEFAST and WAVEFILTER.
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

% Check the input and output arguments for reasonableness.
if (~ismatrix(c)) || (size(c,1) ~= 1)
   error('C must be a row vector.');   
end
  
if (~ismatrix(s)) || ~isreal(s) || ~isnumeric(s) || ...
        ((size(s,2) ~= 2) && (size(s,2) ~= 3))
   error('S must be a real, numeric two- or three-column array.');   
end
  
elements = prod(s,2);
if (length(c) < elements(end)) || ...
      ~(elements(1) + 3 * sum(elements(2:end - 1)) >= elements(end))
   error(['[C S] must be a standard wavelet ' ...
         'decomposition structure.']); 
end

% Maximum levels in [C, S].
nmax = size(s,1) - 2;

% Get third input parameter and init check flags.
wname = varargin{1};  filterchk = 0;   nchk = 0;
  
switch nargin
case 3
   if ischar(wname)   
      [lp,hp] = wavefilter(wname,'r');   n = nmax;
   else 
      error('Undefined filter.');  
   end
   if nargout ~= 1 
      error('Wrong number of output arguments.');  
   end
   extmode = 'SYM';
case 4
   if ischar(wname)
      [lp,hp] = wavefilter(wname,'r');   
      if ischar(varargin{2})
          extmode = varargin{2};    n = nmax;
      else
          n = varargin{2};	extmode = 'SYM';
      end
   else
      lp = varargin{1};   hp = varargin{2};   
      filterchk = 1;      n = nmax;     extmode = 'SYM';
      if nargout ~= 1 
         error('Wrong number of output arguments.');  
      end
   end
case 5
   if ischar(wname)
      [lp,hp] = wavefilter(wname,'r');
      extmode = varargin{2};    n = varargin{3};    nchk = 1;
   else
      lp = varargin{1};   hp = varargin{2};   filterchk = 1;
      if ischar(varargin{3})
          extmode = varargin{3};    n = nmax;
      else
          n = varargin{3};  extmode = 'SYM';
      end
   end
case 6
   lp = varargin{1};   hp = varargin{2};   filterchk = 1;
   extmode = varargin{3};   n = varargin{4};    nchk = 1;
otherwise
   error('Improper number of input arguments.');     
end
  
fl = length(lp);
if filterchk                                    % Check filters.
   if (~ismatrix(lp)) || ~isreal(lp) || ~isnumeric(lp) ...
         || (~ismatrix(hp)) || ~isreal(hp) || ~isnumeric(hp) ...
         || (fl ~= length(hp)) || rem(fl,2) ~= 0
      error(['LP and HP must be even and equal length real, ' ...
         'numeric filter vectors.']);
   end
end

if nchk && (~isnumeric(n) || ~isreal(n))        % Check scale N.
   error('N must be a real numeric.'); 
end
if (n > nmax) || (n < 1)
   error('Invalid number (N) of reconstructions requested.');    
end
if (n ~= nmax) && (nargout ~= 2) 
   error('Not enough output arguments.'); 
end
  
nc = c;    ns = s;    nnmax = nmax;            % Init decomposition.
for i = 1:n
   % Compute a new approximation.
   a = convup(wavecopy('a',nc,ns),lp,lp,fl,ns(3,:),extmode) + ...
       convup(wavecopy('h',nc,ns,nnmax), ...
                 hp,lp,fl,ns(3,:),extmode) + ...
       convup(wavecopy('v',nc,ns,nnmax), ...
                 lp,hp,fl,ns(3,:),extmode) + ...
       convup(wavecopy('d',nc,ns,nnmax), ...
                 hp,hp,fl,ns(3,:),extmode);
      
   % Update decomposition.
   nc = nc(4 * prod(ns(1,:)) + 1:end);     nc = [a(:)' nc];
   ns = ns(3:end,:);                       ns = [ns(1,:); ns];
   nnmax = size(ns,1) - 2;
end

% For complete reconstructions, reformat output as 2-D.
if nargout == 1
   a = nc;   nc = zeros(ns(1,:));     nc(:) = a;    
end
  
varargout{1} = nc;
if nargout == 2 
   varargout{2} = ns;  
end

%----------------------------------------------------------------------%
function w = convup(x,f1,f2,fln,keep,extmode)
% Upsample rows and convolve columns with f1; upsample columns and
% convolve rows with f2; then extract center assuming symmetrical
% extension.

% Process each "page" (i.e., 3rd index) of an extended 2-D array
% separately; if 'x' is 2-D, size(x, 3) = 1.
% Preallocate w.
zi = fln - 1:fln + keep(1) - 2;
zj = fln - 1:fln + keep(2) - 2;
w = zeros(numel(zi),numel(zj),size(x,3));
for i = 1:size(x,3)
   if strcmpi(extmode,'SYM')
       y = zeros([2 1] .* size(x(:,:,i)));
       y(1:2:end,:) = x(:,:,i);
       y = conv2(y,f1');
       z = zeros([1 2] .* size(y));      z(:,1:2:end) = y;
       z = conv2(z,f2);
       z = z(zi,zj);
   else
       y = zeros([2 1] .* size(x));      y(1:2:end,:) = x;
       y = padarray(y,[length(f1)/2 0],'circular','both');
       y = conv2(y,f1','full');
       z = zeros([1 2] .* size(y));      z(:,1:2:end) = y;
       z = padarray(z,[0 length(f2)/2],'circular','both');
       z = conv2(z,f2,'full');
       z = z(fln:fln+keep-1,fln:fln+keep-1);
   end
   w(:,:,i) = z;
end


