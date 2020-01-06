% DIPUM Toolbox.
% Version 3.0.0  06-Jan-2020  
%
% Copyright 2002-2020 Gatesmark
%
% These functions are based on the theoretical and practical foundations 
% established in the book Digital Image Processing Using MATLAB, 3rd ed., 
% Gatesmark Press, 2020.
%
% Book website: http://www.imageprocessingplace.com
%
% License for most functions: 
%   https://github.com/dipum/dipum-toolbox/blob/master/LICENSE.txt
%
% Some functions are provided under a separate license. See the appropriate 
% license.txt files.
%
% Release information.
%   Readme                   - Information about current and previous versions.
%
% Intensity transforms and spatial filtering.
%   fun2hist                 - Generates a histogram from a given digital function.
%   intensityScaling         - Scale intensities of an image to the full [0 1] range.
%   intensityTransformations - Grayscale image intensity transformations.
%   manualhist               - Generates a two-mode histogram interactively.
%
% Fuzzy logic.
%   aggfcn                   - Aggregation function for a fuzzy system.
%   approxfcn                - Approximation function.
%   bellmf                   - Bell-shaped membership function.
%   defuzzify                - Output of fuzzy system.
%   fuzzyfilt                - Fuzzy edge detector.
%   fuzzysysfcn              - Fuzzy system function.
%   implfcns                 - Implication functions for a fuzzy system.
%   lambdafcns               - Lambda functions for a set of fuzzy rules.
%   makefuzzyedgesys         - Script to make MAT-file used by FUZZYFILT.
%   onemf                    - Constant membership function (one).
%   sigmamf                  - Sigma membership function.
%   smf                      - S-shaped membership function.
%   trapezmf                 - Trapezoidal membership function.
%   triangmf                 - Triangular membership function.
%   truncgaussmf             - Truncated Gaussian membership function.
%   zeromf                   - Constant membership function (zero).
%
% Frequency domain filtering.
%   bandfilter               - Computes frequency domain band filter transfer functions.
%   cnotch                   - Generates notch filter transfer functions.
%   dftfilt                  - Performs frequency domain filtering.
%   dftuv                    - Computes meshgrid frequency matrices.
%   hpfilter                 - Computes frequency domain highpass filter transfer functions.
%   lpfilter                 - Computes frequency domain lowpass filter transfer functions.
%   minusOne                 - Multiplies an input array by (-1)^x+y.
%   paddedsize               - Computes padded sizes useful for FFT-based filtering. 
%   recnotch                 - Generates axes notch filter transfer functions.
%
% Image restoration and reconstruction.
%   adpmedian                - Perform adaptive median filtering.
%   histroi                  - Computes the histogram of an ROI in an image.
%   imnoise2                 - Outputs noisy image and random matrix with given PDF.
%   imnoise3                 - 2-D sinusoidal spatial pattern.
%   spfilt                   - Performs linear and nonlinear spatial filtering.
%   statmoments              - Computes statistical central moments of image histogram.
%
% Geometric transformations.
%   geotrans                 - Make affine and projective geometric transformations.
%   imwarp2                  - 2-D geometric transformation with fixed output location.
%   pixeldup                 - Duplicates pixels of an image in both directions.
%   reprotate                - Rotate image repeatedly.
%   visgeotrans              - Visualize geometric transformation.
%
% Color.
%   chromaticityDiagram      - Plot chromaticity diagram.
%   colorgrad                - Computes the vector gradient of an RGB image.
%   colorseg                 - Performs segmentation of a color image.
%   colorMatchingFunctions   - Color-matching functions.
%   colorSwatches            - Display a set of colors on individual squares.
%   hsi2rgb                  - Converts an HSI image to RGB.
%   ice                      - Launch Interactive Color Editor.
%   iceControlPanel          - Interactive Color Editor control panel.
%   illuminant               - Spectral power distribution of common illuminants.
%   lambda2xyz               - Convert wavelength to tristimulus values.
%   rgb2hsi                  - Converts an RGB image to HSI.
%   rgbcube                  - Displays an RGB cube on the MATLAB desktop.
%   rspd2xyz                 - Convert relative spectral power density to XYZ.
%   spectrumBar              - Add visible light spectrum bar to plot.
%   spectrumColors           - RGB colors corresponding to the visible light spectrum.
%   xyy2xyz                  - Convert chromaticity coordinates to XYZ tristimulus values.
%   xyz2xyy                  - Convert XYZ tristimulus values to chromaticity coordinates.
%
% Wavelets.
%   basisImages              - Displays the basis images of a transformation matrix.
%   fwtcompare               - Compare wavedec2 and wavefast.
%   ifwtcompare              - Compare waverec2 and waveback.
%   wave2gray                - Display wavelet decomposition coefficients.
%   waveback                 - Computes inverse FWTs for multi-level decomposition [C, S].
%   wavecopy                 - Fetches coefficients of a wavelet decomposition structure.
%   wavecut                  - Zeroes coefficients in a wavelet decomposition structure.
%   wavedisplay              - Display wavelet decomposition coefficients.
%   wavefast                 - Computes the FWT of a '3-D extended' 2-D array.
%   wavefilter               - Create wavelet decomposition and reconstruction filters.
%   wavepaste                - Puts coefficients in a wavelet decomposition structure.
%   wavework                 - is used to edit wavelet decomposition structures.
%   wavezero                 - Zeroes wavelet transform detail coefficients. 
%   whtmtx                   - Generates sequency-ordered Walsh-Hadamard transformation matrix.
%
% Image compression.
%   compare                  - Computes and displays the error between two matrices.
%   cv2tifs                  - Decodes a TIFS2CV compressed image sequence.
%   huff2mat                 - Decodes a Huffman encoded matrix.
%   huffman                  - Builds a variable-length Huffman code for a symbol source.
%   im2jpeg                  - Compresses an image using a JPEG approximation.
%   im2jpeg2k                - Compresses an image using a JPEG 2000 approximation.
%   imratio                  - Computes the ratio of the bytes in two images/variables.
%   jpeg2im                  - Decodes an IM2JPEG compressed image.
%   jpeg2k2im                - Decodes an IM2JPEG2K compressed image.
%   lpc2mat                  - Decompresses a 1-D lossless predictive encoded matrix.
%   mat2huff                 - Huffman encodes a matrix.
%   mat2lpc                  - Compresses a matrix using 1-D lossles predictive coding.
%   ntrop                    - Computes a first-order estimate of the entropy of a matrix.
%   quantize                 - Quantizes the elements of a UINT8 matrix.
%   showmo                   - Displays the motion vectors of a compressed image sequence.
%   tifs2cv                  - Compresses a multi-frame TIFF image sequence.
%   unravel                  - Decodes a variable-length bit stream.
%
% Image segmentation.
%   cornerprocess            - Processes the output of function cornermetric.
%   localthresh              - Local thresholding.
%   kmeansClustering         - kmeansClustering Standard kmeans algorithm.
%   movingthresh             - Image segmentation using a moving average threshold.
%   otsuthresh               - Computes Otsu's optimum threshold from a histogram.
%   predicate                - Helper function for splitmerge.
%   regiongrow               - Image segmentation using region growing.
%   splitmerge               - Segment an image using a split-and-merge algorithm.
%
% Snakes.
%   snakeForce               - Components of external force for use in the snake algorithm.
%   snakeIterate             - Iterative solution of the snake equation.
%   snakeMap                 - Computes an edge map for use in the snake iterative algorithm.
%   snakeRespace             - Respaces the coordinates of a snake uniformly. 
%
% Level sets.
%   levelsetCurvature        - levelsetCurvature Computes the curvature of a level set function.
%   levelsetForce            - Scalar force field for level-set segmentation.
%   levelsetFunction         - Generates a level-set function.
%   levelsetHeaviside        - 2D Heaviside and impulse for level set segmentation.
%   levelsetIterate          - Iterative solution of level set equation.
%   levelsetReset            - Reinitializes a signed distance function.
%
% Boundary utilities.
%   bound2eight              - Convert 4-connected boundary to 8-connected boundary.
%   bound2four               - Convert 8-connected boundary to 4-connected boundary.
%   bound2im                 - Converts a boundary to an image.
%   boundarydir              - Determine the direction of a sequence of planar points.
%   bsubsamp                 - Subsample a boundary.
%   coord2mask               - Generates a binary mask from given coordinates.
%   uppermostLeftmost        - Uppermost, leftmost point of a closed boundary.
%   x2majoraxis              - Aligns coordinate x with the major axis of a region.
%
% Feature extraction.
%   covmatrix                - Computes the covariance matrix and mean vector.
%   diameter                 - Measure diameter and related properties of image boundaries.
%   endpoints                - Computes end points of a binary image.
%   frdescp                  - Computes Fourier descriptors.
%   freemanChainCode         - Computes the Freeman chain code of a boundary.
%   ifrdescp                 - Computes inverse Fourier descriptors.
%   im2minperpoly            - Minimum perimeter polygon.
%   invmoments               - Compute invariant moments of image.
%   myRegionProps            - Properties of a single binary region.
%   principalComponents      - Principal components of a vector population.
%   signature                - Computes the signature of a boundary.
%   specxture                - Computes spectral texture of an image.
%   statxture                - Computes statistical measures of texture in an image.
%
% Pattern classification.
%   bayesgauss               - Bayes classifier for Gaussian patterns.
%   mahalanobis              - Computes the Mahalanobis distance.
%   minDistanceClassifier    - Minimum distance classifier.
%   patternShuffle           - Shuffle pattern vectors. 
%   perceptronClassify       - Perceptron classifier for two classes.
%   perceptronTrain          - Training of two-class perceptron.
%   strsimilarity            - Similarity measure between two character vectors.
%
% Fully-connected neural networks (FCNNs).
%   fcnnactivate             - Activation function for FCNNs.
%   fcnnbp                   - Backpropagation in fully-connected neural net.
%   fcnnclassify             - Fully-connected neural network classifier.
%   fcnnff                   - Feedforward in a fully-connected neural net.
%   fcnninfo                 - Parameters and notation of fully-connected neural net. 
%   fcnninit                 - FCNINIT Initialize fully-connected neural net.
%   fcnntrain                - Train fully-connected neural net.
%   fcnnupdateweights        - Update the weights of fully-connected neural net.
%
% Convolutional neural networks (CNNs).
%   cnnactivate              - Activation function for CNNs.
%   cnnbp                    - convolutional neural network backpropagation.
%   cnnclassify              - classify input images using cnn.
%   cnnff                    - Convolutional net network feedforward.
%   cnngradients             - Computes gradients for use in cnn weight updates.
%   cnninfo                  - Parameters and notation of convolutional neural net. 
%   cnninit                  - Initializes convolutional neural network.
%   cnnpool                  - Pools (subsamples) the elements of a feature map.
%   cnntrain                 - Training of convolutional neural network.
%   cnnupdateweights         - Updates the weights and biases of a cnn.
%   maps2vectors             - Converts maps in the output of a cnn to vectors.
%   mmat2labels              - Convert membership matrix to vector of class labels.
%   vectors2maps             - Converts vectors to the format of cnn output maps.
%
% Image data type conversion.
%   changeclass              - Changes the storage class of an image.
%   tofloat                  - Converts an image to floating point.
%
% Image file I/O
%   getCIFAR10images         - getCIFAR10images Extracts images from the CIFAR10 database.
%   getMNISTimages           - getMNISTimages Extracts images from the MNIST database.
%   movie2tifs               - Creates a multiframe TIFF file from a MATLAB movie.
%   seq2tifs                 - Creates a multi-frame TIFF file from a MATLAB sequence.
%   tifs2movie               - Create a MATLAB movie from a multiframe TIFF file.
%   tifs2seq                 - Create a MATLAB sequence from a multi-frame TIFF file.
%
% Miscellaneous utility functions.
%
%   binary2rgb               - Converts high values in a binary image to one RGB color.
%   connectpoly              - Connects the vertices of a polygon with straight lines.
%   conwaylaws               - Applies Conway's genetic laws to a single pixel.
%   curveDisplay             - Display of 2-D curve.
%   curveManualInput         - Manual input of curve coordinates.
%   div2D                    - Computes the divergence of a 2D vector field.
%   elemdup                  - Duplicates the elements of an array in specified dimensions.
%   flipdims                 - Flips array in specified dimensions.
%   i2percentile             - Computes a percentile given an intensity value.
%   imcircle                 - Creates a binary image of circle.
%   imcolorcode              - Converts values in a gray or binary image to RGB color.
%   imstack2vectors          - Extracts vectors from an image stack.
%   interparc                - Interpolate points along a curve in 2 or more dimensions.
%   intline                  - Integer-coordinate line drawing algorithm.
%   iseven                   - Determines which elements of an array are even numbers.
%   isodd                    - Determines which elements of an array are odd numbers.
%   iswhole                  - True for integers(whole numbers).
%   percentile2i             - Computes an intensity value given a percentile.
%   polyangles               - Computes internal polygon angles.
%   randvertex               - Adds random noise to the vertices of a polygon.
%   rot180                   - Rotates input matrix by 180 degrees.
%   twomodegauss             - Generates a two-mode Gaussian function.
%
% Sample functions.
%   average                  - Computes the average value of a 1-D or 2-D array.
%   imblend                  - Weighted sum of two images.
%   imageStats1              - imageStats1 Sample function used in Chapter 2.
%   imageStats2              - imageStats2 Sample function used in Chapter 2.
%   imageStats3              - imageStats3 Sample function used in Chapter 2.
%   imageStats4              - imageStats4 Sample function used in Chapter 2.
%   imageStats5              - imageStats5 Sample function used in Chapter 2.
%   interactive              - Illustrates inputs from keyboard and mouse.
%   sinfun1                  - Sample function used in Chapter 2.
%   sinfun2                  - Sample function used in Chapter 2.
%   sinfun3                  - Sample function used in Chapter 2.
%   subim                    - Extracts a subimage, s, from a given image, f.
%   twodsin1                 - Sample function used in Chapter 2.
%   twodsin2                 - Sample function used in Chapter 2.
%   twodsin3                 - Sample function used in Chapter 2.
%


