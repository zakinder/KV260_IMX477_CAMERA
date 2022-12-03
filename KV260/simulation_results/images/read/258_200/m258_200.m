RGB = imread('258_200.bmp');
HSV = rgb2hsv(RGB)
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);
ax1 = subplot(2,2,1);
imshow(HSV)
ax2 = subplot(2,2,2);
imshow(H)

ax3 = subplot(2,2,3);
imshow(S)

ax4 = subplot(2,2,4);
imshow(V)
