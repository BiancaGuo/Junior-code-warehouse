%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

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

%均值滤波

path='..\';
file_name_out=strcat(path,'embed_抽样.bmp');
I=watermarked_image(1:2:end,1:2:end);  
imwrite(I,file_name_out,'bmp');

file_name_out=strcat(path,'lena_抽样.bmp');
I=original_image(1:2:end,1:2:end);  
imwrite(I,file_name_out,'bmp');


elapsed_time=cputime-start_time




