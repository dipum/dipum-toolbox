function y = tifs2cv(f,m,d,q)
%TIFS2CV Compresses a multi-frame TIFF image sequence.
%   Y = TIFS2CV(F,M,D,Q) compresses multiframe TIFF F using motion
%   compensated frames, 8 x 8 DCT transforms, and Huffman coding. If
%   parameter Q is omitted or is 0, only Huffman encoding is used and
%   the compression is lossless; for Q > 0, lossy JPEG encoding is
%   performed. The inputs are:
%
%      F     A multi-frame TIFF file        (e.g., 'file.tif') 
%      M     Macroblock size                (e.g., 8)
%      D     Search displacement            (e.g., [16 8])
%      Q     JPEG quality for IM2JPEG       (e.g., 1)
%
%   Output Y is an encoding structure with fields: 
%
%      Y.blksz      Size of motion compensation blocks
%      Y.frames     The number of frames in the image sequence
%      Y.quality    The reconstruction quality
%      Y.motion     Huffman encoded motion vectors
%      Y.video      An array of MAT2HUFF or IM2JPEG coding structures
%
%   See also CV2TIFS.
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

% The default reconstruction quality is lossless.
if nargin < 4
    q = 0;
end

% Compress frame 1 and reconstruct for the initial reference frame.
if q == 0
    cv(1) = mat2huff(imread(f,1));
    r = double(huff2mat(cv(1)));
else
    cv(1) = im2jpeg(imread(f,1),q);
    r = double(jpeg2im(cv(1)));
end
fsz = size(r);

% Verify that image dimensions are multiples of the macroblock size.
if ((mod(fsz(1),m) ~= 0) || (mod(fsz(2),m) ~= 0))
    error('Image dimensions must be multiples of the block size.');
end

% Get the number of frames and preallocate a motion vector array.
fcnt = size(imfinfo(f),1);
mvsz = [fsz/m 2 fcnt];
mv = zeros(mvsz);

% For all frames except the first, compute motion conpensated
% prediction residuals and compress with motion vectors.
for i = 2:fcnt
    frm = double(imread(f,i));
    frmC = im2col(frm,[m m],'distinct');
    eC = zeros(size(frmC));
    
    for col = 1:size(frmC,2)
        lookfor = col2im(frmC(:,col),[m m],[m m],'distinct');
        
        x = 1 + mod(m * (col - 1),fsz(1));
        y = 1 + m * floor((col - 1) * m / fsz(1));
        x1 = max(1,x - d(1));
        x2 = min(fsz(1),x + m + d(1) - 1);
        y1 = max(1,y - d(2));
        y2 = min(fsz(2),y + m + d(2) - 1);
        
        here = r(x1:x2,y1:y2);
        hereC = im2col(here,[m m],'sliding');
        for j = 1:size(hereC,2)
            hereC(:,j) = hereC(:,j) - lookfor(:);
        end
        sC = sum(abs(hereC));
        s = col2im(sC,[m m],size(here),'sliding');
        mins = min(min(s));
        [sx,sy] = find(s == mins);
        
        ns = abs(sx) + abs(sy);         % Get the closest vector
        si = find(ns == min(ns));
        n = si(1);
        
        mv(1 + floor((x - 1)/m), 1 + floor((y - 1)/m), 1:2, i) = ...
            [x - (x1 + sx(n) - 1) y - (y1 + sy(n) - 1)];
        eC(:,col) = hereC(:, sx(n) + (1 + size(here,1) - m) ...
            * (sy(n) - 1));
    end

    % Code the prediction residual and reconstruct it for use in
    % forming the next reference frame.
    e = col2im(eC,[m m],fsz,'distinct');
    if q == 0
        cv(i) = mat2huff(int16(e));
        e = double(huff2mat(cv(i)));
    else
        cv(i) = im2jpeg(uint16(e + 255),q,9);
        e = double(jpeg2im(cv(i)) - 255);
    end
    
    % Decode the next reference frame. Use the motion vectors to get
    % the subimages needed to subtract from the prediction residual.
    rC = im2col(e,[m m],'distinct');
    for col = 1:size(rC,2)
        u = 1 + mod(m * (col - 1),fsz(1));
        v = 1 + m * floor((col - 1) * m / fsz(1));
        rx = u - mv(1 + floor((u - 1)/m), 1 + floor((v - 1)/m), 1, i);
        ry = v - mv(1 + floor((u - 1)/m), 1 + floor((v - 1)/m), 2, i);
        temp = r(rx:rx + m - 1,ry:ry + m - 1);
        rC(:,col) = temp(:) - rC(:,col);
    end
    r = col2im(double(uint16(rC)),[m m],fsz,'distinct');
end

y = struct;
y.blksz = uint16(m);
y.frames = uint16(fcnt);
y.quality = uint16(q);
y.motion = mat2huff(mv(:));
y.video = cv;
