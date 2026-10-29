symbol_list = ['a':'z' ' ' '.' ',' '!' ';'];
binary_codes = cell(1, length(symbol_list));

for k = 1:length(symbol_list)
    binary_codes{k} = dec2bin(k-1, 5);
end

Mapset = cell(2, length(symbol_list));
for k = 1:length(symbol_list)
    Mapset{1,k} = symbol_list(k);
    Mapset{2,k} = binary_codes{k};
end
disp("Mapset:");
disp(Mapset(:, 1:8));

[file_name, file_path] = uigetfile({'*.png;*.jpg;*.bmp','Image Files'}, 'Select Image');
if isequal(file_name,0)
    error('No image selected.');
end

input_img = imread(fullfile(file_path, file_name));
encoded_img = coding('moon;', Mapset, input_img, 30);

figure;
subplot(1,2,1), imshow(input_img), title('Original Image');
subplot(1,2,2), imshow(encoded_img), title('Encoded Image');

imwrite(encoded_img, 'encoded_output.png');

decoded_text = decoding(encoded_img, Mapset, 30);
fprintf('Decoded message: %s\n', decoded_text);

img_difference = imabsdiff(input_img, encoded_img);
figure;
imshow(img_difference * 100);
title('Amplified Difference Image');
colorbar;
