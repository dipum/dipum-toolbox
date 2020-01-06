function h = fun2hist(fun,S)
%FUN2HIST Generates a histogram from a given digital function.
%   H = FUN2HIST(FUN,S) generates histogram H from a 1-D input
%   function FUN (a vector). The number of bins in H is equal to the
%   number of elements of FUN. If only FUN is provided in the input,
%   then H is normalized so that the sum of its components equals 1.
%   If S (a scalar) is provided, H is unnormalized, in the sense
%   that the sum of its components is equal to S. This is useful,
%   for example, if it is required that the sum of the components of
%   the histogram equal the number of pixels in an image. In this
%   case, the value of S would be S=M*N, where M and N are the
%   number of rows and columns in the image, respectively.
%
%   When S is specified, the elements of H are converted to
%   integers, so there is likely to be small roundoff errors between
%   the shapes of FUN and H. The reason for converting to integers
%   is that the sum of the components of an unnormalized histogram
%   has to equal the number of pixels (an integer) in the
%   corresponding image, as noted above.
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

% Preliminaries
% Set defaults.
mode = 'u';
if nargin == 1
   mode = 'n';
end
% Number of bins (intensity levels in the histogram).
L = numel(fun);
% Initialize histogram.
h(1:L) = 0;
% Get index of the elements of fun that are not 0. These will be the
% populated bins in H.
idx = find(fun ~= 0);
IDXL = numel(idx);

% Generate the histogram from input function fun.
switch mode
   case 'n'
      h = fun/sum(fun);
   case 'u'
      % Convert to integers.
      h = round(S*(fun/sum(fun)));
      % Most likely, sum(H) will not equal S because of rounding.
      % If sum(H) is less than S, distribute the difference
      % between S and sum(H) equally (i.e., by increments of 1)
      % among elements of the populated histogram bins, starting
      % from the left and proceesing to the right. If sum(H) > S,
      % then take away 1 pixel from the populated bins.
      D = sum(h) - S;
      if D < 0
         count = abs(D);
         % Loop through the histogram, adding elements to the
         % populated bins until all D elements have been added.
         while count
            K = IDXL;
            if count < IDXL
               K = count;
            end
            for I = 1:K
               % Add counts to the populated bins only.
               h(idx(I)) = h(idx(I)) + 1; 
               count = count - 1;
            end
         end
      elseif D > 0
         count = D;
         % Loop through the histogram, subtracting elements until
         % all D elements have been subtracted.
         while count
            K = IDXL;
            if count < IDXL
               K = count;
            end
            for I = 1:K
               % Subtract counts from the populated bins only.
               % But make sure they don't go negative.
               h(idx(I)) = h(idx(I)) - 1;
               if h(idx(I)) < 0
                  % Restore the amount subtracted.
                  h(idx(I)) = h(idx(I)) - 1;
                  % And reduce count so that the count will be
                  % subtracted elsewhere.
                  count = count + 1; % As if nothing had happened. 
               end
            count = count - 1;
            end  
         end
      end
end


        
