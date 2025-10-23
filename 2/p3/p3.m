[file, path] = uigetfile({'*.jpg;*.bmp;*.png;*.tif'}, 'Select image');
imagePath = fullfile(path, file);
carImg = imread(imagePath);
figure; imshow(carImg); title('Car');
targetSize = [500 800];
carImg = imresize(carImg, targetSize);
figure; imshow(carImg); title('Resized Image');
redCh   = carImg(:,:,1);
greenCh = carImg(:,:,2);
blueCh  = carImg(:,:,3);
blueMask = (blueCh > 100) & (blueCh > 1.25 * redCh) & (blueCh > 1.15 * greenCh);
figure; imshow(blueMask); title('Blue');
minBlobSize = 60;
blueMask = bwareaopen(blueMask, minBlobSize);
figure; imshow(blueMask); title('Filtered Blue');
[labeledMask, regionCount] = bwlabel(blueMask);
regions = regionprops(labeledMask, 'BoundingBox', 'Area');
potentialIdx = [];
for i = 1:regionCount
    bbox = regions(i).BoundingBox;
    width  = bbox(3);
    height = bbox(4);
    aspectRatio = height / width;
    if aspectRatio > 1.6 && aspectRatio < 6 && ...
       width > 10 && height > 25 && ...
       bbox(1) < size(carImg,2)/1.8
        potentialIdx = [potentialIdx i];
    end
end
[~, chosenIdx] = max([regions(potentialIdx).Area]);
stripBox = regions(potentialIdx(chosenIdx)).BoundingBox;
figure;
imshow(carImg);
hold on;
rectangle('Position', stripBox, 'EdgeColor', 'y', 'LineWidth', 2);
title('Detected');
hold off;
x0 = stripBox(1);
y0 = stripBox(2);
bw = stripBox(3);
bh = stripBox(4);
plateWidthFactor = 12;
plateHeightFactor = 2;
plateW = bw * plateWidthFactor;
plateH = bh * plateHeightFactor;
plateX = x0;
plateY = y0 - (plateH - bh) / 2;
plateX = max(plateX, 1);
plateY = max(plateY, 1);
if plateX + plateW > size(carImg, 2)
    plateW = size(carImg, 2) - plateX - 1;
end
if plateY + plateH > size(carImg, 1)
    plateH = size(carImg, 1) - plateY - 1;
end
img = imcrop(carImg, [plateX, plateY, plateW, plateH]);
img_resized = imresize(img, [300 500]);
figure, imshow(img_resized); title('Resized Image');
gray_img = rgb2gray(img_resized);
figure, imshow(gray_img); title('Grayscale Image');
bin_img = ~imbinarize(gray_img, graythresh(gray_img));
figure, imshow(bin_img); title('Binary Image');
n = 500;
background = bwareaopen(bin_img, 4000);
clean_img = bwareaopen(bin_img, n);
clean_img = clean_img & ~background;
figure, imshow(clean_img); title('Noise Removed');
[L, num] = bwlabel(clean_img);
figure, imshow(label2rgb(L)); title('Segmented Image');
files = dir('Map Set\');
len = length(files) - 2;
train = cell(2, len);
for i = 1 : len
   img = imread(fullfile('Map Set', files(i + 2).name));
   if ndims(img) == 3
       img = rgb2gray(img);
   end
   label = files(i + 2).name(1);
   train{1, i} = img;
   train{2, i} = label;
end
all_letters = size(train, 2);
figure
final_result = [];
for n = 1 : num
    [r, c] = find(L == n);
    Y = L(min(r) : max(r), min(c) : max(c));
    imshow(Y)
    Y = imresize(Y, [42, 24]);
    imshow(Y)
    pause(0.2)

    ro = zeros(1, all_letters);
    for k = 1 : all_letters   
        ro(k) = corr2(train{1,k}, Y);
    end
    [MAXRO, pos] = max(ro);
    if MAXRO > 0.47
        out = cell2mat(train(2, pos));       
        final_result = [final_result out];
    end
end

disp(final_result);
fid = fopen('answer.txt','w');
fprintf(fid,'%s\n',final_result);
fclose(fid);
type('answer.txt');
