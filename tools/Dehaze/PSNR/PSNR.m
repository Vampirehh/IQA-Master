tu1=imread('1.bmp');
tu2=imread('3.bmp');

tu1=im2double(tu1);
tu2=im2double(tu2);

r1=tu1(:,:,1);     %��ȡͼ���R����
g1=tu1(:,:,2);     %��ȡͼ���g����
b1=tu1(:,:,3);     %��ȡͼ���b����
r2=tu2(:,:,1);     %��ȡͼ���R����
g2=tu2(:,:,2);     %��ȡͼ���g����
b2=tu2(:,:,3);     %��ȡͼ���b����

d1=mean(mean((r1-r2).^2));                        %R������MSE
psnr1=10*log10(255*255/d1);                       %R������PSNR

d2=mean(mean((g1-g2).^2));                        %G������MSE
psnr2=10*log10(255*255/d2);                       %R������PSNR

d3=mean(mean((b1-b2).^2));                        %B������MSE
psnr3=10*log10(255*255/d3);                       %R������PSNR

psnr=(psnr1+psnr2+psnr3)/3                        %psnrΪ��������psnr�ľ�ֵ