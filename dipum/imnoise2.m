function [fn,R] = imnoise2(f,type,a,b)
%IMNOISE2 Outputs noisy image and random matrix with given PDF.
%   [Fn,R] = IMNOISE2(F,TYPE,A,B) generates a noise matrix, R, of the
%   same size as input grayscale image F, whose elements are random
%   numbers of the specified TYPE, with parameters A and B. The output
%   noisy image is formed either by adding R to it or, in the case of
%   salt and pepper, by modifying F based on the values of R, as
%   explained in Section 5.2 of DIPUM3E. The noisy image Fn is of class
%   double, scaled to the full range [0,1]. The input image can be of
%   any valid grayscale class.
%  
%   Valid values for TYPE and parameters A and B are:
% 
%     'uniform'        Uniform random numbers in the interval (a,b). The
%                      default values are (0,1).
%
%     'gaussian'       Gaussian random numbers with mean a and standard
%                      deviation b. The default values are a = 0, b = 1;
%
%     'salt & pepper'  Salt and pepper random numbers of value 1 (salt)
%                      with probability Ps = a, and value 0 (pepper)
%                      with probability Pp = b. The default values are
%                      Ps = Pp = 0.05. The noise matrix R is assigned
%                      three values: R(x,y) = 1 (white), for salt noise
%                      at coordinates (x,y); R(x,y) = 0 (black) for
%                      pepper noise at coordinates (x,y); and R(x,y) =
%                      0.5 for no noise at coordinates (x,y). Therefore,
%                      R is not simply added to an image to make it
%                      noisy. Instead, we assign to the image a value of
%                      0 or 1 at the corresponding locations in R with
%                      values of 0 or 1. The image is unchanged at the
%                      coordinates where the values of R are 0.5.
%
%     'lognormal'      Lognormal random numbers with offset a and shape
%                      parameter b. The defaults are a = 1 and b = 0.25.
%
%     'rayleigh'       Rayleigh random numbers with parameters a and b.
%                      The default values are a = 0 and b = 1.
%
%     'exponential'    Exponential random numbers with parameter a. The
%                      default is a = 1.
%
%     'erlang'         Erlang (gamma) random numbers with parameters a
%                      and b. a must be a positive integer. The defaults
%                      are a = 2 and b = 5. Erlang random numbers are
%                      approximated as the sum of b exponential random
%                      numbers.
%
%    To generate only a matrix R of size M-by-N whose elements are from
%    any of the preceding PDFs, use the syntax
%
%       [~,R] = imnoise2(ones(M,N),type,a,b)
%
%   To generate a single random number from any of the preceding PDFs,
%   use the syntax
%
%       [~,R] = imnoise2(1,type,a,b)
%
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
 
f = im2double(f);
[M,N] = size(f);
 
% Begin processing. Use lower(type) to protect against input being
% capitalized. 
switch lower(type)
case 'uniform'
   if nargin == 2
      a = 0;
      b = 1;
   end
   R = a + (b - a)*rand(M,N);
   fn = f + R;  
case 'gaussian'
   if nargin == 2
      a = 0;
      b = 1;
   end
   R = a + b*randn(M,N);
   fn = f + R;  
case 'salt & pepper'
   if nargin == 2
      a = 0.05;
      b = 0.05;
   end
   R = saltpepper(M,N,a,b);
   % Form the noisy image using the values of R.
   fn = f;
   fn(R == 1) = 1; % Salt.
   fn(R == 0) = 0; % Pepper.
   % Other values of R are 0.5, for which fn should be equal to f, which
   % it is already, so nothing else needs to be done.   
case 'lognormal'
   if nargin == 2
      a = 1;
      b = 0.25;
   end
   R = exp(b*randn(M,N) + a);
   fn = f + R;   
case 'rayleigh'
   if nargin == 2
      a = 0;
      b = 1;
   end
   R = a + (-b*log(1 - rand(M,N))).^0.5;
   fn = f + R;  
case 'exponential'
   if nargin == 2
      a = 1;
   end
   R = exponential(M,N,a);
   fn = f + R;
case 'erlang'
   if nargin == 2
      a = 2;
      b = 5;
   end
   R = erlang(M,N,a,b);
   fn = f + R;
otherwise
   error('Unknown distribution type.')
end
 
% Scale the noisy image to the range [0,1] without changing its
% tonality.
fn = max(min(fn,1),0);
 
%----------------------------------------------------------------------%
function R = saltpepper(M,N,a,b)
% Check to make sure that Ps + Pp is not > 1.
if (a + b) > 1
   error('The sum (a + b) must not exceed 1.')
end
 
R(1:M,1:N) = 0.5;
% Generate an M-by-N array of uniformly-distributed random numbers in
% the range (0,1). Then, Pp*(M*N) of them will have values <= b. The
% coordinates of these points we call 0 (pepper noise). Similarly,
% Ps*(M*N) points will have values in the range > b and <= (a + b).
% These we call 1 (salt noise).
X = rand(M,N);
R(X <= b) = 0;
R(X > b & X <= a + b) = 1;
 
%----------------------------------------------------------------------%
function R = exponential(M,N,a)
if a <= 0
   error('Parameter a must be positive for exponential type.')
end
k = -1/a;
R = k*log(1 - rand(M,N));
 
%----------------------------------------------------------------------%
function R = erlang(M,N,a,b)
if (b ~= round(b) || b <= 0)
   error('Param b must be a positive integer for Erlang.')
end
k = -1/a;
R = zeros(M,N);
for j = 1:b
   R = R + k*log(1 - rand(M,N));
end
