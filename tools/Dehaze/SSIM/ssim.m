 img1=imread('E:\ͼ����������\TID���ݼ�\TID2013\tid2013������\reference_images\b(1).bmp') ;         %reference image
 img2=imread('E:\ͼ����������\TID���ݼ�\TID2013\tid2013������\distorted_images\a(1).bmp') ;         %test image
 img1=rgb2gray(img1);
 img2=rgb2gray(img2) ;           %color image convert to gray  image
  K=[0.01 0.03];
  L=255;
  window=fspecial('gaussian', 11, 1.5)  ;      
  [mssim,ssim_map] = ssim_index(img1, img2, K, window, L)