%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法
% 高斯噪声测试
clc
clear all
close all
start_time=cputime;

%% 对图像进行操作，测试水印鲁棒性
AC_watermarked_file_name='embed_AC.bmp';
AC_watermarked_image=imread(AC_watermarked_file_name);
DC_watermarked_file_name='embed_DC.bmp';
DC_watermarked_image=imread(DC_watermarked_file_name);
Mc=size(DC_watermarked_file_name,1);
Nc=size(DC_watermarked_file_name,2);
%高斯噪声
for i=0.01:0.01:0.5
    path='.\高斯噪声图片\';
    file_name_out=strcat(path,'embed_高斯噪声_ac',num2str(i),'.bmp');%水印嵌入AC系数的载体图像
    pic_g=imnoise(AC_watermarked_image,'gaussian',i);%高斯噪声
    imwrite(pic_g,file_name_out,'bmp');
    
    file_name_out=strcat(path,'embed_高斯噪声_dc',num2str(i),'.bmp');%水印嵌入DC系数的载体图像
    pic_g=imnoise(DC_watermarked_image,'gaussian',i);%高斯噪声
    imwrite(pic_g,file_name_out,'bmp');
end



