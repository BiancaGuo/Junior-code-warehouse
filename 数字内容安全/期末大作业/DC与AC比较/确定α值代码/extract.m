%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all
start_time=cputime;

%% 水印提取(原图均值滤波 and 嵌入水印后图片均值滤波）


path='..\';
file_name_out=strcat(path,'lena_抽样.bmp');

pending_file_name=file_name_out;%待检测图片
[pending_file,map]=imread(pending_file_name);
file_name='lena.bmp';%原始图片
[cover_object,map]=imread(file_name);

Mc=size(cover_object,1);
Nc=size(cover_object,2);
Mw=size(pending_file,1);
Nw=size(pending_file,2);
row=floor(Mw/8);
col=floor(Nw/8);
blocksize=8;
%watermark_embed=load('watermark.txt');
k = 1;
for m = 1:row
    for n = 1:col
         x = (m-1)*blocksize+1;  
         y = (n-1)*blocksize+1;
         block_origin=cover_object(x:x+blocksize-1,y:y+blocksize-1);
         block_pending = pending_file(x:x+blocksize-1,y:y+blocksize-1);
         block_origin_dct = dct2(block_origin);
         block_pending_dct = dct2(block_pending);
         watermark_extract(k)=block_pending_dct(1,1)-block_origin_dct(1,1);%提取出的待测水印序
         block_origin = idct2(block_origin_dct);
         block_pending = idct2(block_pending_dct);
         cover_object(x:x+blocksize-1,y:y+blocksize-1) = block_origin; 
         pending_file(x:x+blocksize-1,y:y+blocksize-1) = block_pending; 
         k=k+1;
    end
end

%disp(strcat('相似度 = ',num2str(similarity)));
path_watermark='..\..\均值滤波水印提取\';
watermark_file = fopen(strcat(path_watermark,'lena_均值滤波_',num2str(i),'.txt'),'wt');%数据保存在你当前的文件夹下，文件名为Data.txt
fprintf(watermark_file,'%d\n',watermark_extract);
fclose(watermark_file);





elapsed_time=cputime-start_time

