%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法
% JPEG测试
clc
clear all
close all
start_time=cputime;

%% 对图像进行操作，测试水印鲁棒性

watermarked_file_name='embed.bmp';
watermarked_image=imread(watermarked_file_name);

original_file_name='lena.bmp';
original_image=imread(original_file_name);

Mc=size(watermarked_image,1);
Nc=size(watermarked_image,2);

%椒盐噪声
for i=0.01:0.01:0.2
    path='..\';
    file_name_out=strcat(path,'embed_椒盐噪声_',num2str(i),'.bmp');
    pic_sap=imnoise(watermarked_image,'salt & pepper',i);
    imwrite(pic_sap,file_name_out,'bmp');
    
    file_name_out=strcat(path,'lena_椒盐噪声_',num2str(i),'.bmp');
    pic_sap=imnoise(original_image,'salt & pepper',i);
    imwrite(pic_sap,file_name_out,'bmp');
end

elapsed_time=cputime-start_time

