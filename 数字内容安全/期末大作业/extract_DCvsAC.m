%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all
start_time=cputime;

%% 水印提取
pending_file_name='embed_椒盐噪声.bmp';%待检测图片
[pending_file,map]=imread(pending_file_name);
file_name='lena.bmp';%原始图片
[cover_object,map]=imread(file_name);


Mc=size(cover_object,1);
Nc=size(cover_object,2);
Mw=size(pending_file,1);
Nw=size(pending_file,2);
row=floor(Mc/8);
col=floor(Nc/8);
blocksize=8;
watermark_embed=load('watermark.txt');
k = 1;
for m = 1:row
    for n = 1:col
         x = (m-1)*blocksize+1;  
         y = (n-1)*blocksize+1;
         block_origin=cover_object(x:x+blocksize-1,y:y+blocksize-1);
         block_pending = pending_file(x:x+blocksize-1,y:y+blocksize-1);
         block_origin_dct = dct2(block_origin);
         block_pending_dct = dct2(block_pending);
         watermark_extract(k)=block_pending_dct(1,1)-block_origin_dct(1,1);%提取出的待测水印序列
         block_origin = idct2(block_origin_dct);
         block_pending = idct2(block_pending_dct);
         cover_object(x:x+blocksize-1,y:y+blocksize-1) = block_origin; 
         pending_file(x:x+blocksize-1,y:y+blocksize-1) = block_pending; 
         k=k+1;
    end
end


    
%% 计算待测水印与原始水印相似度

sum1=0;
sum2=0;
for i=1:k-1
    sum1=sum1+watermark_extract(i)*watermark_embed(i);
    sum2=sum2+watermark_extract(i)*watermark_extract(i);
end

similarity=sum1/sqrt(sum2);

disp(strcat('相似度 = ',num2str(similarity)));

elapsed_time=cputime-start_time

