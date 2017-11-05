clear;
clc;
% Load images
im0 = imread('pepsi_left.tif');
%im0 = imadjust(im0);
%im0 = imresize(im0, 0.5);
%im0 = imread('shapessm.jpg');
%im1 = imrotate(im0, 90);
im1 = imread('pepsi_right.tif');

% Run harris function for both images
[cim0, r0, c0] = harris(im0, 2, 1000, 10, 0);
[cim1, r1, c1] = harris(im1, 2, 1000, 10, 0);

% Useful variables
nk0 = size(r0,1);               % Number of keypoints
nk1 = size(r1,1);
rs = 17;                        % Region size
hrs = floor(rs/2);              % Half of region size     

% Create figure
mainFigure = figure;
set(mainFigure,'Renderer','painters');  % Change renderer
for i = 1:nk0
    % Position for the left image rectangle (and patch)
    pos0 = [c0(i)-hrs, r0(i)-hrs, rs, rs];
    % Crop patch
    patch = imcrop(im0, pos0);
    % Correlation between patch and right image
    C = normxcorr2(patch, im1);
    % Obtain and store correlation of each keypoint
    kc = zeros(nk1, 1);
    for j=1:nk1
        kc(j) = C(r1(j) + hrs, c1(j) + hrs);
    end
    % Position of max correlation element in vector
    [~, mc] = max(kc);
    % Position for the right image rectangle
    pos1 = [c1(mc)-hrs, r1(mc)-hrs, rs, rs];
    % Right image most correlated keypoint
    mk = kc(mc);
    
    handler1 = subplot(2,2,1);
        imshow(im0); 
        hold on;
            plot(c0,r0,'ro');       % Red circles in each keypoint
            rectangle('Position', pos0, 'EdgeColor', 'g');  % Rectangle
        hold off;
    handler2 = subplot(2,2,2);
        imshow(im1); 
        hold on;
            plot(c1, r1, 'mo');     % Magenta circles in each keypoint
            rectangle('Position', pos1, 'EdgeColor', 'g');  % Rectangle
        hold off;
    handler3 = subplot(2,2,3);
        imshow(patch);              % Show region cropped
    handler4 = subplot(2,2,4);
        hold on;                    % NCC values and maximum
            plot((1:nk1), kc, 'r.');          
            plot(mc, mk, 'g*');
        hold off;
    pause;
    delete(handler1);
    delete(handler2);
    delete(handler3);
    delete(handler4);
end