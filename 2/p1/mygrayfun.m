function gray_img = mygrayfun(rgb_img)
R = double(rgb_img(:,:,1));
G = double(rgb_img(:,:,2));
B = double(rgb_img(:,:,3));
gray_img = uint8(0.299*R + 0.578*G + 0.114*B);
end