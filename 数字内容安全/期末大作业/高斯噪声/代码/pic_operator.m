%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法
% 高斯噪声测试
clc
clear all
close all
start_time=cputime;

%% 对图像进行操作，测试水印鲁棒性

watermarked_file_name='embed.bmp';%embed.bmp & lena.bmp
watermarked_image=imread(watermarked_file_name);

original_file_name='lena.bmp';
original_image=imread(original_file_name);

Mc=size(watermarked_image,1);
Nc=size(watermarked_image,2);

%高斯噪声
for i=0.01:0.01:0.5
    path='..\';
    file_name_out=strcat(path,'embed_高斯噪声_',num2str(i),'.bmp');%嵌入水印的图像经高斯噪声
    pic_g=imnoise(watermarked_image,'gaussian',i);
    imwrite(pic_g,file_name_out,'bmp');
    
    file_name_out=strcat(path,'lena_高斯噪声_',num2str(i),'.bmp');%未嵌入水印的图像经高斯噪声
    pic_g=imnoise(original_image,'gaussian',i);
    imwrite(pic_g,file_name_out,'bmp');
end



