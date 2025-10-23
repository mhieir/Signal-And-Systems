clc; clear; close all;
vidName = 'video.mp4';
vObj = VideoReader(vidName);
fps = vObj.FrameRate;
timeStep = 1 / fps;
fprintf('Loaded "%s" [%.2f frames/sec]\n', vidName, fps);
firstFrame = readFrame(vObj);
grayPrev = rgb2gray(firstFrame);
motionCenters = [];
frameIndex = 1;
storedFrames = {};
maxShow = 14; 
colsPerRow = 7;
while hasFrame(vObj)
    frameRGB = readFrame(vObj);
    grayCurr = rgb2gray(frameRGB);
    diffImg = imabsdiff(grayCurr, grayPrev);
    motionMask = diffImg > 50;       
    motionMask = bwareaopen(motionMask, 180);
    motionMask = imfill(motionMask, 'holes');
    regions = regionprops(motionMask, 'Centroid', 'Area', 'BoundingBox');
    fTemp = figure('Visible','off');
    imshow(grayCurr); hold on;
    if ~isempty(regions)
        [~, biggestIdx] = max([regions.Area]);
        bbox = regions(biggestIdx).BoundingBox;
        centerPt = regions(biggestIdx).Centroid;
        motionCenters = [motionCenters; centerPt];
        rectangle('Position', bbox, 'EdgeColor', 'cyan', 'LineWidth', 2);
        plot(centerPt(1), centerPt(2), 'y+', 'MarkerSize', 10, 'LineWidth', 1.5);
    end
    title(sprintf('Frame #%d', frameIndex));
    frameGrab = getframe(gca);
    storedFrames{end+1} = frameGrab.cdata;
    close(fTemp);
    grayPrev = grayCurr;
    frameIndex = frameIndex + 1;
end
fprintf('Total processed frames: %d\n', frameIndex);
if size(motionCenters,1) < 2
    error('Not enough tracked points for motion estimation.');
end
verticalShift = diff(motionCenters(:,2));
pixelVelocity = verticalShift / timeStep;
averageVelocity = mean(pixelVelocity, 'omitnan');
fprintf('Average pixel velocity: %.2f pixels/sec\n', averageVelocity);
nShow = min(maxShow, numel(storedFrames));
figure;
for i = 1:nShow
    subplot(ceil(nShow/colsPerRow), colsPerRow, i);
    imshow(storedFrames{i});
    title(sprintf('Frame %d', i));
end
sgtitle('Motion Tracking Sequence');
