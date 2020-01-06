function [I,R] = getMNISTimages(NI,type,order,classLabels)
%getMNISTimages Extracts images from the MNIST database.
%
%   [I,R] = getMNISTimages([], TYPE) extracts all the images of TYPE
%   ('training' or 'test') and the corresponding class membership
%   matrix, R, from the MNIST database.
%
%   [I,R] = getMNISTimages(NI,TYPE,'random') extracts NI total images of
%   TYPE ('training' or 'test') and the corresponing R, chosen at random
%   from the MNIST database.
%
%   [I,R] = getMNISTimages(NI,TYPE,START,CLASSLABELS) extracts from the
%   MNIST database NI TYPE images of each of the classes specified in
%   vector CLASSLABELS, starting at image number START. The total number
%   of images estracted is NI*numel(CLASSLABELS). If CLASSLABLES is
%   either [] or is omitted, it defaults to all ten classes. Valid
%   values of START are 1 <= START <= 60000 for images from the training
%   set and 1 <= START <= 10000 for images from the test set.
%
%   Output I contains that extracted images. It is of size
%   28-by-28-by-depth-by-NI*numel(classLabels) which is the format
%   required by the functions in the DIPUM3E CNNToolbox. The images are
%   grayscale, so depth = 1.
%
%   Output R is the membership matrix of the images in I. It is of size
%   numel(classLabels)-by-NI*numel(classLabels)
%
%   The total number of possible classes of the output images is ten,
%   with the following names and cnn classification labels:
%
%     Class Name         Classification Label
%
%      zero                      1
%      one                       2
%      two                       3
%      three                     4
%      four                      5
%      five                      6
%      six                       7
%      seven                     8
%      eight                     9
%      nine                     10
%
%
%   NOTE 0: All MNIST images are in the file mnist_uint8.mat which is
%   contained the folder MNIST_Images in the DIPUM3E Support Pakage.
%   This folder must be added to the MATLAB path.
%
%   NOTE 1: All output images are in image class double format, with
%   values in the range [0 1].
%
%   NOTE 2: As of this writing the MNIST dataset can be downloaded from
%   http://rodrigob.github.io/are_we_there_yet/build/classification_datasets_results.html.
%   The database consists of four files: ,'train_x', 'train_y',
%   'test_x', 'test_y' Place these files in the MATLAB workspace and
%   save the workspace as mnist_uint8.mat. Place this file in the MATLAB
%   path. This function will unpack the mat file and format the images
%   in a form suitable for use with the DIPUM3E CNNToolbox.
%
%   NOTE 3: If numel(classes) < 10, then R will be reformatted so that
%   its number of rows equals the number of classes, as required by the
%   definition of the class membership matrix. Thus, the meaning of the
%   original labels will be lost. For example, if classes = [2 4 8],
%   then R will have three rows, and the class labels 2,4,8 will become
%   1,2,3.
%
%   NOTE 4: HOW THE RAW MNIST DATA IS ORGANIZED.
%	 The training data in the original database is organized as a matrix,
%	 train_x, of size 60000-by-784, each column of which are the
%	 components of the 28-by-28 images of numbers. A similar matrix,
%	 train_y, of size 60000-by-10 contains the labels (class membership)
%	 of the samples. This is a binary matrix, each column of which is all
%	 0s, except at the location correponding to the pattern corresponding
%	 to that column. This is the membership matrix R discussed in Chapter
%	 14 of DIPUM3E. The testing data consists of 10000 samples, organized
%	 as above, with the names test_x and test_y.
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

% If NI = [], extract all images of the given type and return.
if isempty(NI)
   [I,R] = all_NIST_images(type); % This is a local function.
   return
end

% Load all the images of the desired type.
[Idb,Rdb] = all_NIST_images(type);

% If order = 'random', extract NI random images and the corresponding R
% and return.
if isequal(order,'random')
   NIR = randperm(NI);
   I = zeros(28,28,1,NI);
   R = zeros(10,NI);
   count = 0;
   for k = NIR
      count = count + 1;
      I(:,:,1,count) = Idb(:,:,:,k);
      R(:,count) = Rdb(:,k);
   end
   return
end

% NI images will be extracted for each of the specified classes, for a
% total of NI*numel(classLabels) images.

% Convert the columns of Rdb into numerical labels in the range [1,10].
% Function mmat2labels is a DIPUM3E utility function.
dbClassLabels = mmat2labels(Rdb);

% The starting image number is the numerical value of order.
start = order;

% Default for vector "classes" is all 10 classes.
if nargin == 3 || isempty(classLabels)
   classLabels = 1:10;
end

% Initialize.
count = 0;
I = zeros(28,28,1,NI*numel(classLabels));
R = zeros(numel(classLabels),NI*numel(classLabels));
for j = 1:numel(classLabels)
	% Find locations where labels match one of the classes specified in
   % vector "classes".
	idx = find(dbClassLabels == classLabels(j));
	% Extract labels in locations higher than "start".
	idx = idx(idx >= start);
   
	% Make sure there are at least NI labels of the specified class.
	if numel(idx) < NI
      error('Specified range has fewer than NI images of specified classes')
	end
   
	% Extract images and corresponding matrix columns for current values
	% of idx. Note that R is being reformatted so that its number of rows
	% equals the number of classes [i.e., size(R,1) = numel(classes)].
	% (See the comments in the help section of this function.)
	for k = 1:NI
      count = count + 1;
      I(:,:,:,count) = Idb(:,:,:,idx(k));
      R(j,count) = 1;
	end
end

%----------------------------------------------------------------------%
function [I,R] = all_NIST_images(type)
% Extracts all the images of type 'training' or 'test' from the MNIST
% database. R is the class membership matrix defined in Section 14.SS
% of DIPUM3E.

% Load the database. The images are in folder MNIST_Images. This folder
% must be in the MATLAB path.
load('mnist_uint8.mat','train_x','train_y','test_x','test_y');

% Arrange the training images in the format 28-by-28-by-1-by-60000, and
% the test images in the format 28-by-28-by-1-by-10000, as required by
% function cnn. Because of the way the original data is formated, we
% also have to swap (permute) the first two dimensions so that the
% images will be readable by humans.
switch type
   case 'training'
      I = reshape(train_x',28,28,1,[]);
      I = permute(I,[2 1 3 4]);
      % For the class membership matrix, all that needs to be done is
      % transpose the original data.
      R = train_y';
   case 'test'
      I = reshape(test_x',28,28,1,[]);
      I = permute(I,[2 1 3 4]);
      R = test_y';
   otherwise
      error('Unknown type')
end

% Convert images to image class double format with values in the range
% [0 1].
I = im2double(uint8(I));
R = double(R);
