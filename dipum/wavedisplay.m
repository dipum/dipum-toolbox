function w = wavedisplay(c,s,scale,border)
%WAVEDISPLAY Display wavelet decomposition coefficients.
%   W = WAVEDISPLAY(C,S,SCALE,BORDER) displays and returns a wavelet
%   coefficient image.
%
%   EXAMPLES:
%     wavedisplay(c, s);                     Display w/defaults.
%     foo = wavedisplay(c, s);               Display and return.
%     foo = wavedisplay(c, s, 4);            Magnify the details.
%     foo = wavedisplay(c, s, -4);           Magnify absolute values.
%     foo = wavedisplay(c, s, 1, 'append');  Keep border values.
%
%   INPUTS/OUTPUTS:
%     [C, S] is a wavelet decomposition vector and bookkeeping matrix.
%
%     SCALE       Detail coefficient scaling
%     ----------------------------------------------------------
%     0 or 1      Maximum range (default)
%     2,3...      Magnify default by the scale factor
%     -1, -2...   Magnify absolute values by abs(scale)
%     
%     BORDER      Border between wavelet decompositions
%     ----------------------------------------------------------
%     'absorb'    Border replaces image (default)
%     'append'    Border increases width of image
%     
%     Image W:   ------- ------ ------------ -------------------
%                |      |      |            |
%                | a(n) | h(n) |            |
%                |      |      |            |
%                ------- ------     h(n-1)  |
%                |      |      |            |
%                | v(n) | d(n) |            |        h(n-2)
%                |      |      |            |
%                ------- ------ ------------
%                |             |            |        
%                |    v(n-1)   |   d(n-1)   |
%                |             |            |
%                -------------- ------------ -------------------
%                |                          |
%                |          v(n-2)          |        d(n-2) 
%                |                          |
%     
%     Here, n denotes the decomposition step scale and a, h, v, d are
%     approximation, horizontal, vertical, and diagonal detail
%     coefficients, respectively.
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

% Check input arguments for reasonableness.
narginchk(2,4);
 
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

if (nargin > 2) && (~isreal(scale) || ~isnumeric(scale))
   error('SCALE must be a real, numeric scalar.'); 
end
 
if (nargin > 3) && (~ischar(border))
  error('BORDER must be character string.');  
end

if nargin == 2 
   scale = 1;  % Default scale. 
end          

if nargin < 4 
   border = 'absorb';  % Default border.
end   
  
% Scale coefficients and determine pad fill.
absflag = scale < 0;
scale = abs(scale);   
if scale == 0 
   scale = 1; 
end

[cd,w] = wavecut('a',c,s);   w = mat2gray(w);
cdx = max(abs(cd(:))) / scale;
if absflag 
   cd = mat2gray(abs(cd),[0, cdx]);   fill = 0;
else 
   cd = mat2gray(cd,[-cdx, cdx]);   fill = 0.5;   
end
  
% Build gray image one decomposition at a time.
for i = size(s, 1) - 2:-1:1
   ws = size(w);
   
   h = wavecopy('h',cd,s,i);
   pad = ws - size(h);     frontporch = round(pad / 2);
   h = padarray(h,frontporch,fill,'pre');
   h = padarray(h,pad - frontporch,fill,'post');
   
   v = wavecopy('v',cd,s,i);
   pad = ws - size(v);     frontporch = round(pad / 2);
   v = padarray(v,frontporch,fill,'pre');
   v = padarray(v,pad - frontporch,fill,'post');
   
   d = wavecopy('d',cd,s,i);
   pad = ws - size(d);     frontporch = round(pad / 2);
   d = padarray(d,frontporch,fill,'pre');
   d = padarray(d,pad - frontporch,fill,'post');
   
   % Add 1 pixel white border and concatenate coefficients.
   switch lower(border)
   case 'append'
      w = padarray(w,[1 1],1,'post');    
      h = padarray(h,[1 0],1,'post');
      v = padarray(v,[0 1],1,'post');
   case 'absorb'
      w(:,end,:) = 1;   w(end,:,:) = 1;   
      h(end,:,:) = 1;   v(:,end,:) = 1;
   otherwise
      error('Unrecognized BORDER parameter.');
   end   
   w = [w h; v d];
end

% Display result. If the reconstruction is an extended 2-D array
% with 2 or more pages, display as a time sequence. 
if nargout == 0
   if size(s,2) == 2
      imshow(w);
   else
      implay(w);
   end
end
