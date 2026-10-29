clc; clear; close all;
videoFile = '1-1.mp4';
vid = VideoReader(videoFile);

outputFile = 'target_tracking.mp4';
outputVideo = VideoWriter(outputFile);
outputVideo.FrameRate = vid.FrameRate;
open(outputVideo);

firstFrame = readFrame(vid);
firstGray = rgb2gray(firstFrame);
figure; imshow(firstFrame);
title('select, after that enter');

mask = false(size(firstGray));
hold on;
rects = {};
while true
    h = drawrectangle('Color', 'cyan');
    wait(h);
    rect = round(h.Position);
    if isempty(rect)
        break;
    end
    rects{end+1} = rect;
    mask(rect(2):(rect(2)+rect(4)), rect(1):(rect(1)+rect(3))) = true;
    answer = questdlg('Continue?', ...
    'Region Selection', 'Yes', 'No', 'No');

    if strcmp(answer, 'No')
        break;
    end
end
hold off;
close;

figure; imshow(mask);
frame1_gray = firstGray;
frame1_gray(mask) = 0;
frame1_gray = mat2gray(frame1_gray);

while hasFrame(vid)
    frame2 = readFrame(vid);
    frame2_gray = rgb2gray(frame2);
    frame2_gray(mask) = 0;
    frame2_gray = mat2gray(frame2_gray);
    diffFrame = imabsdiff(frame2_gray, frame1_gray);

    bw = diffFrame > 0.05;
    bw = imgaussfilt(double(bw), 2) > 0.1;
    bw = bwareaopen(bw, 5);

    stats = regionprops(bw, 'BoundingBox', 'Centroid');

    frameOut = frame2;
    
    for k = 1:length(stats)
        bbox = stats(k).BoundingBox;
        x = round(bbox(1)); y = round(bbox(2)); w = round(bbox(3)); h = round(bbox(4));
        red = [255, 0, 0];
        frameOut(y:y+1, x:x+w, 1) = red(1);
        frameOut(y:y+1, x:x+w, 2) = red(2);
        frameOut(y:y+1, x:x+w, 3) = red(3);
        frameOut(y+h-1:y+h, x:x+w, 1) = red(1);
        frameOut(y+h-1:y+h, x:x+w, 2) = red(2);
        frameOut(y+h-1:y+h, x:x+w, 3) = red(3);
        frameOut(y:y+h, x:x+1, 1) = red(1);
        frameOut(y:y+h, x:x+1, 2) = red(2);
        frameOut(y:y+h, x:x+1, 3) = red(3);
        frameOut(y:y+h, x+w-1:x+w, 1) = red(1);
        frameOut(y:y+h, x+w-1:x+w, 2) = red(2);
        frameOut(y:y+h, x+w-1:x+w, 3) = red(3);
        centroid = round(stats(k).Centroid);
        cx = centroid(1); cy = centroid(2);
        yellow = [255, 255, 0];
        frameOut(cy-5:cy+5, cx, 1) = yellow(1);
        frameOut(cy-5:cy+5, cx, 2) = yellow(2);
        frameOut(cy-5:cy+5, cx, 3) = yellow(3);
        frameOut(cy, cx-5:cx+5, 1) = yellow(1);
        frameOut(cy, cx-5:cx+5, 2) = yellow(2);
        frameOut(cy, cx-5:cx+5, 3) = yellow(3);
    end
    imshow(frameOut);
    title('detecting airplain');
    drawnow;
    writeVideo(outputVideo, frameOut);
    frame1_gray = frame2_gray;
end
disp('end of detecting');
close(outputVideo);
disp(['output file: ', outputFile]);