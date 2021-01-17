clear all;
close all;
clc;

face = imread('face10.jpg');
face = imgaussfilt(face);
[H,W,~] = size(face);

figure;
imshow(face);

ycbcr = rgb2ycbcr(face);

figure;
imshow(ycbcr);

cb = [80 140];
cr = [140 175];
result = zeros(H,W);

for i = 1:H
    for j = 1:W
        if (ycbcr(i,j,2) >= cb(1) && ycbcr(i,j,2) <= cb(2))
            if (ycbcr(i,j,3) >= cr(1) && ycbcr(i,j,3) <= cr(2))
                result(i,j) = 1;
            end
        end
    end
end

figure;
imshow(result);

%sr=strel('disk',6);
%result = imclose(result,sr);

figure;
imshow(result);

L = bwlabel(result);
B = regionprops(L,'area');
Se = [B.Area];
Sm = max(Se);

B1 = bwareaopen(result,Sm);

figure;
imshow(B1);

top = H; bot = H; left = W; right = W;

for i = 1:H
    if any(B1(i,:))
        top=i;
        break
    end
end
for i = top:H
    if B1(i,:) == 0
        bot=i;
        break
    end
end
for j = 1:W
    if any(B1(:,j))
        left=j;
        break
    end
end
for j = left:W
    if B1(:,j)==0
        right=j;
        break
    end
end
    
figure;
imshow(face);

hold on
h1=line([left right],[top top]);
h2=line([left right],[bot bot]);
h3=line([left left],[top bot]);
h4=line([right right],[top bot]);
h=[h1 h2 h3 h4];
set(h,'Color',[1 0 0],'LineWidth',2);
