%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all
start_time=cputime;

% 分辨率：384*384
file_name='lena.bmp';
[cover_object,map]=imread(file_name);
%imshow(cover_object,[])
Mc=size(cover_object,1);
Nc=size(cover_object,2);
row=floor(Mc/8);
col=floor(Nc/8);
model=zeros(8,8);
blocksize=8;
olddata=cover_object;

%判断T1取值
%max(n_edge)
%min(n_edge)
%figure,
%plot(count_temp)

%% 水印嵌入

%生成嵌入的水印序列 2304
watermark=normrnd(0,1,1,2304);
for i=1:2304
    if watermark(i)>0
        watermark(i)=1;
    else
        watermark(i)=-1;
    end
end

%嵌入dc
k = 1;
for m = 1:row
    for n = 1:col
         x = (m-1)*blocksize+1;  
         y = (n-1)*blocksize+1;
         block = cover_object(x:x+blocksize-1,y:y+blocksize-1);
         block_dct = dct2(block);
         block_dct(1,1) = block_dct(1,1)*(1+0.02*watermark(k));%改变DC系数
         block = idct2(block_dct);
         cover_object(x:x+blocksize-1,y:y+blocksize-1) = block; 
         k=k+1;
    end
end

watermark_file = fopen('watermark.txt','wt');%数据保存在你当前的文件夹下，文件名为Data.txt
fprintf(watermark_file,'%d\n',watermark);
fclose(watermark_file);
newdata = cover_object;
imwrite(newdata,'embed_DC.bmp','bmp');%将嵌入水印后图像写成bmp文件

%嵌入ac
k = 1;
for m = 1:row
    for n = 1:col
         x = (m-1)*blocksize+1;  
         y = (n-1)*blocksize+1;
         block = olddata(x:x+blocksize-1,y:y+blocksize-1);
         block_dct = dct2(block);
         block_dct(2,1) = block_dct(2,1)*(1+0.5*watermark(k));%改变DC系数
         block = idct2(block_dct);
         olddata(x:x+blocksize-1,y:y+blocksize-1) = block; 
         k=k+1;
    end
end


newdata = olddata;
imwrite(newdata,'embed_AC.bmp','bmp');%将嵌入水印后图像写成bmp文件

elapsed_time=cputime-start_time