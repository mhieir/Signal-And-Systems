clc; clear; close all;
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp','Image Files'}, 'Select image');
img = imread(fullfile(pathname, filename));
img_resized = imresize(img, [300 500]);
figure, imshow(img_resized);
title('Resized Image');
gray_img = rgb2gray(img_resized);
figure, imshow(gray_img);
title('Grayscale Image');
bin_img = ~imbinarize(gray_img, graythresh(gray_img));
figure, imshow(bin_img);
title('Binary Image');
n = 500;
background = bwareaopen(bin_img, 4000);
clean_img = bwareaopen(bin_img, n);
clean_img = clean_img & ~background;
figure, imshow(clean_img);
title('Noise Removed');
[L, num] = bwlabel(clean_img);
figure, imshow(label2rgb(L));
title('Segmented Image');
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