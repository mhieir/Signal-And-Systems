clc; clear; close all;
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp','Image Files'}, 'Select image');
img = imread(fullfile(pathname, filename));
img_resized = imresize(img, [300 500]);
figure, imshow(img_resized);
title('Resized Image');
gray_img = mygrayfun(img_resized);
figure, imshow(gray_img);
title('Grayscale Image');
threshold = 127; 
bin_img = ~mybinaryfun(gray_img, threshold);
figure, imshow(bin_img);
title('Binary Image');
n = 250;
clean_img = myremovecom(bin_img, n);
figure, imshow(clean_img);
title('Noise Removed');
[L, num] = mysegmentation(clean_img);
figure, imshow(L);
title('Segmented Image');
files=dir('Map Set\');
len = length(files) - 2;
train = cell(2, len);
for i = 1 : len
   img = imread(fullfile('Map Set', files(i + 2).name));
   label =files(i+2).name(1);
   train{1, i} = img;
   train{2, i} = label;
end
save('train.mat','train');
load train;
all_letters=size(train,2);
figure
final_result=[];
for n = 1 : num
    [r, c] = find(L == n);
    Y = L(min(r) : max(r), min(c) : max(c));
    imshow(Y)
    Y=imresize(Y, [42,24]);
    imshow(Y)
    pause(0.2)
    ro=zeros(1, all_letters);
    for k = 1 : all_letters   
        ro(k) = corr2(train{1,k}, Y);
    end
    [MAXRO,pos] = max(ro);
    if MAXRO>.47
        out=cell2mat(train(2,pos));       
        final_result=[final_result out];
    end
end
disp(final_result);
type('answer.txt');