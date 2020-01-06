function basisImages(A,gray,space)
%BASISIMAGES Displays the basis images of a transformation matrix.
%   BASISIMAGE(A,GRAY,SPACE) computes and displays the N^2 N x N basis
%   images of N x N orthogonal transformation matrix A. Input GRAY
%   determines the color of a 1-pixel border around each basis image;
%   SPACE is the spacing in pixels between basis images.
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

[M,N] = size(A);
if (M<2 || M~=N || space<0 || gray<0 || gray>1)
   error(['A must be square with at least 2 rows, GRAY must be ' ...
      'between 0 and 1, and SPACE must be non-negative!']);
end

% Preallocate arrays, prepare border, and compute cell size.
basisImages = ones(N*N);
display = ones(N*N+2*N+space*(N-1));
border = zeros(N+2);
border(:) = gray;
C = N+2+space;

% If A is imaginary, display the real and imaginary parts.
for part = 0:1:1-isreal(A)
   figure;
   axis off;
   
   % Compute and scale the basis images.
   for i = 1:1:N
      for j = 1:1:N
         if (part == 0)
            S = real(transpose(A(i,:))*A(j,:));
         else
            S = imag(transpose(A(i,:))*A(j,:));
         end
         x = N*i-N+1;
         y = N*j-N+1;
         basisImages(x:x+N-1, y:y+N-1) = S;
      end
   end
   basisImages = mat2gray(basisImages);
   
   % Add borders and space between basis images.
   for i = 1:1:N
      for j = 1:1:N
         display(C*(i-1)+1:C*(i-1)+N+2, C*(j-1)+1:C*(j-1)+N+2) ...
            = border;
         display(C*(i-1)+2:C*(i-1)+N+1, C*(j-1)+2:C*(j-1)+N+1) ...
            = basisImages(N*i-N+1:N*i, N*j-N+1:N*j);
      end
   end
   
   imshow(display,[ ]);
end
