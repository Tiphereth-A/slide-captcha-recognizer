%% config

PATTERN_SIZE = 80;

%% read images

import_img('background.bmp');
import_img('target.bmp');

%% remove white border of target

if size(target, 1) ~= size(background, 1) || size(target, 2) ~= size(background, 2)
    l = [0 0];

    for i1 = 1:size(target, 1)
        for j1 = 1:size(target, 2)
            if target(i1,j1,:) == background(1,1,:)
                l = [i1 j1];
                break;
            end
        end

        if l
            break
        end
    end

    target = target(l(1):l(1) + size(background, 1) - 1, l(2):l(2) + size(background, 2) - 1, :);
end

% imwrite(target, 'target.bmp')

%% original

subplot(2,1,1)
imshow(target)

%% calculate difference

target = rgb2gray(target - background);
target(target > 0) = 255;
target(:, 1:PATTERN_SIZE + 5) = 0;

%% erode & dilate

se = strel('line',11,90);
target = imdilate(imerode(target, se), se);

%% calculate coordinates

p0 = [0 0];

for i = size(target, 1):-1:1
    for j = 1:size(target, 2)
        if target(i,j)
            p0 = [i, j];
            break
        end
    end

    if p0
        break;
    end
end

bx = [p0(2), p0(2) + PATTERN_SIZE, p0(2) + PATTERN_SIZE, p0(2), p0(2)];
by = [p0(1), p0(1), p0(1) - PATTERN_SIZE, p0(1) - PATTERN_SIZE, p0(1)];

% imwrite(target, 'bi_target.bmp')

subplot(2,1,2)
imshow(target)
hold on
line(bx, by, 'Color', 'r', 'LineWidth', 1)