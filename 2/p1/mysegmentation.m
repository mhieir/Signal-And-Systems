function [segpic , N] = mysegmentation(pic)
pic = logical(pic);
A = pic;
segpic = zeros(size(A));
N = 0;
se = strel('square',3);
while any(A(:))
    [r,c] = find(A,1);
    mask = false(size(A));
    mask(r,c) = true;
    done = false;
    while ~done
        oldmask = mask;
        mask = imdilate(mask,se) & A;
        done = isequal(mask,oldmask);
    end
    N = N + 1;
    segpic(mask) = N;
    A(mask) = 0;
end
end
