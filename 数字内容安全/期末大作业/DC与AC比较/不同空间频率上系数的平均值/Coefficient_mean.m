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
for i=1:8
    for j=1:8
        dct_para(i,j)=0;
    end
end
k = 1;
for m = 1:row
    for n = 1:col
         x = (m-1)*blocksize+1;  
         y = (n-1)*blocksize+1;
         block = cover_object(x:x+blocksize-1,y:y+blocksize-1);%图像8x8分块
         block_dct = dct2(block);%分块后做DCT变换
         for i=1:8
             for j=1:8
                 dct_para(i,j)=dct_para(i,j)+abs(block_dct(i,j));%保存不同空间频率上DCT系数
             end
         end
         block = idct2(block_dct);%逆DCT变换恢复图像
         cover_object(x:x+blocksize-1,y:y+blocksize-1) = block; 
         k=k+1;
    end
end
for i=1:8
    for j=1:8
        dct_para(i,j)=dct_para(i,j)/(row*col);%求在不同的空间频率上系数的平均值(平均振幅)
    end
end

surf(dct_para,'EdgeColor','None');%绘制z的3D图  
shading interp;  
elapsed_time=cputime-start_time