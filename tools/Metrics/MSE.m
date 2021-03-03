function [result,psnr] = MSE(A,B)
 a=rgb2gray(A);
 b=rgb2gray(B);
 [H,W]=size(a);
 C=double(a)-double(b);
 D=C.*C;
 d=D./(H*W);
 e=sum(sum(d)); 
 psnr=10*log((255*255)/e);
result=e;


    
