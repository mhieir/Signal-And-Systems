function cleanpic = myremovecom(pic, thresh)
    [rows, cols] = size(pic);
    A = pic;
    segpic = zeros(rows, cols);
    N = 0;
    dirs = [ -1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1 ];
    for i = 1:rows
        for j = 1:cols
            if A(i,j) == 1
                N = N + 1;
                stack = [i, j];
                while ~isempty(stack)
                    r = stack(end,1);
                    c = stack(end,2);
                    stack(end,:) = [];
                    if r<1 || r>rows || c<1 || c>cols
                        continue;
                    end
                    if A(r,c) == 0
                        continue;
                    end
                    A(r,c) = 0;
                    segpic(r,c) = N;
                    for k = 1:8
                        rr = r + dirs(k,1);
                        cc = c + dirs(k,2);
                        if rr>=1 && rr<=rows && cc>=1 && cc<=cols
                            if A(rr,cc)==1
                                stack = [stack; rr, cc];
                            end
                        end
                    end
                end
            end
        end
    end
    componentAreas = zeros(1, N);
    for label = 1:N
        componentAreas(label) = sum(segpic(:) == label);
    end
    validLabels = find(componentAreas >= thresh);
    cleanpic = ismember(segpic, validLabels);
end
