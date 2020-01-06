function [I,R] = getCIFAR10images(NI,type,order,classLabels)
%getCIFAR10images Extracts images from the CIFAR10 database.
%
%   [I,R] = getCIFAR10images([], TYPE) extracts all the images of TYPE
%   ('training' or 'test') and the corresponding class membership
%   matrix, R, from the CIFAR10 database.
%
%   [I,R] = getCIFAR10images(NI,TYPE,'random') extracts a total of NI
%   TYPE ('training' or 'test') images and the corresponing R, chosen at
%   random from the CIFAR10 database.
%
%   [I,R] = getCIFAR10images(NI,TYPE,START,CLASSLABELS) extracts from
%   the CIFAR10 database NI TYPE ('training' or 'test') images of each
%   of the classes specified in vector CLASSLABELS, starting at image
%   number START. The total number of images extracted is
%   NI*numel(CLASSLABELS). If CLASSLABLES is either [] or is omitted, it
%   defaults to all ten classes. Valid values of START are 1 <= START <=
%   50000 for images from the training set and 1 <= START <= 10000 for
%   images from the test set.
%  
%   The classes in the CIFAR10 database have following names and class
%   labels:
%
%     Class Name              Class Label
%
%      airplane                   1
%      automobile                 2
%      bird                       3
%      cat                        4
%      deer                       5
%      dog                        6
%      frog                       7
%      horse                      8
%      ship                       9
%      truck                     10
%
%   NOTE 1: All output images are RGB images in class double format,
%   with values in the range [0 1].
%
%   NOTE 2: As of this writing, the The CIFAR10 image database can be
%   downloaded from https://www.cs.toronto.edu/~kriz/cifar.html. The
%   dabase consists of seven .mat files and a readme file. These files
%   should be placed in a folder called CIFAR10_Images. This folder must
%   be included in the MATLAB path.
%
%   NOTE 3: If numel(classes) < 10, then R will be reformatted so that
%   its number of rows equals the number of classes, as required by the
%   definition of the class membership matrix. Thus, the meaning of the
%   original labels will be lost. For example, if classLabels = [2 4 8],
%   then R will have three rows, and the class labels 2,4,8 will become
%   1,2,3.
%
%   NOTE 4: The CIFAR10 image database must be in a folder called
%   CIFAR10_Images. This folder is in the DIPUM3E Support Package and
%   must be added to the MATLAB path.
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
   [I,R] = all_CIFAR10_images(type); % This is a local function.
   return
end

% Load all the images of the desired type.
[Idb,Rdb] = all_CIFAR10_images(type);

% If order = 'random', extract NI random images and the corresponding R,
% and return.
if isequal(order,'random')
   NIR = randperm(NI);
   I = zeros(32,32,3,NI);
   R = zeros(10,NI);
   count = 0;
   for k = NIR
      count = count + 1;
      I(:,:,:,count) = Idb(:,:,:,k);
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

% Default for vector "classLabels" is all 10 classes.
if nargin == 3 || isempty(classLabels)
   classLabels = 1:10;
end

% Initialize.
count = 0;
I = zeros(32,32,3,NI*numel(classLabels));
R = zeros(numel(classLabels),NI*numel(classLabels));
for i = 1:numel(classLabels)
	% Find locations where labels match one of the classes specified in
   % vector "classes".
	idx = find(dbClassLabels == classLabels(i));
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
      R(i,count) = 1;
	end
end

%----------------------------------------------------------------------%
function [I,R] = all_CIFAR10_images(type)
% Extracts all the images of type 'training' or 'test' from the CIFAR10
% database. R is the class membership matrix.

% The CIFAR10 image database should be in a folder called
% CIFAR10_Images. This folder must be in the MATLAB path.

if isequal(type,'test')
   % Load the test images using the following command:
   load('test_batch.mat','data','labels');
   numImages = size(labels,1);
   
   % Initialize:
   I = zeros(32,32,3,numImages);
   R = zeros(10,numImages);

   for idx = 1:numImages 
      % RGB Components. All three components are in one row of array
      % 'data'. Each row has 3072 columns.
      Red = data(idx,1:1024);
      Green = data(idx,1025:2048);
      Blue = data(idx,2049:3072);
   
      % As above for training images:
      I(:,:,1,idx) = permute(reshape(Red,[32,32]),[2,1]);
      I(:,:,2,idx) = permute(reshape(Green,[32,32]),[2,1]);
      I(:,:,3,idx) = permute(reshape(Blue,[32,32]),[2,1]);
   
      % Extract the corresponding class labels. The class labels in the
      % database are 0-9 instead of 1-10, so add 1.
      imageLabel = labels(idx) + 1;
      R(imageLabel,idx) = 1;
   end
   % Scale to image class double with values in the range [0 1].
   I = im2double(uint8(I));
   return
end

% Type is not 'test'. Confirm that category 'training' was specified
% correctly.
if ~isequal(type,'training')
   error('Unknown Type')
end

% Extract the training set of images. There are 5 batches of 10000
% training images each. Each training batch of 10000 images is
% extracted using the command load('data_batch_x.mat') where x is an
% integer between 1 and 5. The images are stored in array 'data', and
% the labels in array 'labels'.

% Initialize:
I = zeros(32,32,3,50000);
R = zeros(10,50000);
trainImageNum = 1;
h = waitbar(0,'Extracting images from the CIFAR10 database ....');
for t = 1:5
   batchName = strcat('data_batch_',num2str(t),'.mat');
   load(batchName,'data','labels');
   for idx = 1:10000
      % RGB Components. All three components are in one row of array
      % 'data'.
      Red = data(idx,1:1024);
      Green = data(idx,1025:2048);
      Blue = data(idx,2049:3072);
      
      % Because of the way the RGB components are organized in the
      % database, we use reshape to convert them to 32-by-32 images, and
      % permute to align the axes so that the images are oriented
      % correctly.
      I(:,:,1,trainImageNum) = permute(reshape(Red,[32,32]),[2,1]);
      I(:,:,2,trainImageNum) = permute(reshape(Green,[32,32]),[2,1]);
      I(:,:,3,trainImageNum) = permute(reshape(Blue,[32,32]),[2,1]);
      
      % Extract the corresponding class labels. The class labels in the
      % database are 0-9 instead of 1-10, so add 1.
      imageLabel = labels(idx) + 1;
      R(imageLabel,trainImageNum) = 1;
      
      % Next image number.
      trainImageNum = trainImageNum + 1;
   end
   waitbar(t/5)
end 
close (h)

% Make sure images are in the range [0 1].
I = im2double(uint8(I)); 

