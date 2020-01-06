function av = average(A)
%AVERAGE Computes the average value of a 1-D or 2-D array.
%   AV = AVERAGE(A) computes the average value of input A,
%   which must be a 1?D or 2?D array.
% Check the validity of the input.
if ndims(A) > 2
   error('The dimensions of the input cannot exceed 2.')
end
% Compute the average.
av = sum(A(:))/length(A(:));