%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all

start_time=cputime;

%%  计算不同攻击操作后psnr(攻击后的图与原图）和 提取水印的相似度
%jpeg压缩
file_name='lena.bmp';
cover_object=imread(file_name);
Mc=size(cover_object,1);
Nc=size(cover_object,2);
k=1;
for i=5:100
   
% 计算psnr值
    path='..\'; 
    %含水印
    file_name_out=strcat(path,'embed_jpeg_压缩_',num2str(i),'.jpg');
    compress_image=imread(file_name_out);
    image_psnr=psnr(cover_object,compress_image,Mc,Nc);
    PSNR(k) = image_psnr;%x轴
    %不含水印
    file_name_out2=strcat(path,'lena_jpeg_压缩_',num2str(i),'.jpg');
    compress_image2=imread(file_name_out2);
    image_psnr2=psnr(cover_object,compress_image2,Mc,Nc);
    PSNR2(k) = image_psnr2;%x轴
   
	%计算提取水印相似度
    path_watermark='..\..\JPEG压缩水印提取\';
    %含水印
    file_name_out=strcat(path_watermark,'embed_jpeg_压缩_',num2str(i),'.txt');%待测水印序列
    watermark_file='watermark.txt';%原始水印序列
    watermark_extract=load(file_name_out);
    watermark_embed=load(watermark_file);
    sum1=0;
    sum2=0;
    for v=1:length(watermark_extract)
        sum1=sum1+watermark_extract(v)*watermark_embed(v);
        sum2=sum2+watermark_extract(v)*watermark_extract(v);
    end
    similarity(k)=sum1/sqrt(sum2);%求得相似度
    
    %不含水印
    file_name_out=strcat(path_watermark,'lena_jpeg_压缩_',num2str(i),'.txt');
    watermark_extract2=load(file_name_out);
    sum1=0;
    sum2=0;
    for v=1:length(watermark_extract2)
        sum1=sum1+watermark_extract2(v)*watermark_embed(v);
        sum2=sum2+watermark_extract2(v)*watermark_extract2(v);
    end
    similarity2(k)=sum1/sqrt(sum2);%y轴
    k=k+1;
end

%% 绘制PSNR~similarity图
ma=zeros(length(PSNR),1)+5;
figure,
plot(PSNR,similarity,'b-','linewidth',2);
hold on;
plot(PSNR2,similarity2,'r-','linewidth',2);
plot(PSNR2,ma,'k--','linewidth',1);
legend('With Watermark','No Watermark');
xlabel('PSNR/dB');%x轴标记
ylabel('Similarity');%y轴标记
title(strcat('JPEG压缩 PSNR ~ Similarity图'));%标题

elapsed_time=cputime-start_time

