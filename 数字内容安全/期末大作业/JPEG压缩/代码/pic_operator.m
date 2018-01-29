%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法
% JPEG压缩

clc
clear all
close all
start_time=cputime;

watermarked_file_name='embed.bmp';
watermarked_image=imread(watermarked_file_name);

original_file_name='lena.bmp';
original_image=imread(original_file_name);

Mc=size(watermarked_image,1);
Nc=size(watermarked_image,2);

%jpeg压缩
for i=5:100
    path='..\';
    file_name_out=strcat(path,'embed_jpeg_压缩_',num2str(i),'.jpg');%嵌入水印的图像压缩
    imwrite(watermarked_image,file_name_out,'jpg','quality',i);
    
    file_name_out=strcat(path,'lena_jpeg_压缩_',num2str(i),'.jpg');%未嵌入水印的图像压缩
    imwrite(original_image,file_name_out,'jpg','quality',i);
end




