%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all
start_time=cputime;

%% 对图像进行操作，测试水印鲁棒性

watermarked_file_name='embed.bmp';%embed.bmp & lena.bmp
watermarked_image=imread(watermarked_file_name);
Mc=size(watermarked_image,1);
Nc=size(watermarked_image,2);

% %jpeg压缩（90）
% for i=5:100
%     path='.\JPEG压缩\';
%     file_name_out=strcat(path,'lena_jpeg_压缩_',num2str(i),'.jpg');
%     imwrite(watermarked_image,file_name_out,'jpg','quality',i);
% end
% 
% 
% %高斯噪声
% for i=0.01:0.01:0.5
%     path='.\高斯噪声\';
%     file_name_out=strcat(path,'lena_高斯噪声_',num2str(i),'.bmp');
%     pic_g=imnoise(watermarked_image,'gaussian',i);
%     imwrite(pic_g,file_name_out,'bmp');
% end
% 
% %椒盐噪声
% for i=0.01:0.01:0.2
%     path='.\椒盐噪声\';
%     file_name_out=strcat(path,'lena_椒盐噪声_',num2str(i),'.bmp');
%     pic_sap=imnoise(watermarked_image,'salt & pepper',i);
%     imwrite(pic_sap,file_name_out,'bmp');
% end

%均值滤波
% 
% for i=3:2:9
%     mf_pic=mean_filter(watermarked_image,7);
%     path='.\均值滤波\';
%     file_name_out=strcat(path,'embed_均值滤波_',num2str(i),'.bmp');
%     imwrite(mf_pic,file_name_out,'bmp');
% end


%裁剪[XMIN YMIN WIDTH HEIGHT]
%四分之一
%左上角
LT = imcrop(watermarked_image,[0,0,0.5*Mc,0.5*Nc]);
path='.\剪切\';
file_name_out=strcat(path,'embed_LT','.bmp');
imwrite(LT,file_name_out,'bmp');

%右上角
LT = imcrop(watermarked_image,[0.5*Mc,0,0.5*Mc,0.5*Nc]);
path='.\剪切\';
file_name_out=strcat(path,'embed_RT','.bmp');
imwrite(LT,file_name_out,'bmp');

%左下角
LT = imcrop(watermarked_image,[0,0.5*Nc,0.5*Mc,0.5*Nc]);
path='.\剪切\';
file_name_out=strcat(path,'embed_LD','.bmp');
imwrite(LT,file_name_out,'bmp');

%右下角
LT = imcrop(watermarked_image,[0.5*Mc,0.5*Nc,0.5*Mc,0.5*Nc]);
path='.\剪切\';
file_name_out=strcat(path,'embed_RD','.bmp');
imwrite(LT,file_name_out,'bmp');


