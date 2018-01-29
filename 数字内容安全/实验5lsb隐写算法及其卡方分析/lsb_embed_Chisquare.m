%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	LSB替换算法及其卡方分析

clc
clear all
close all
start_time=cputime;


file_name=strcat('pic5.bmp');
[cover_object,map]=imread(file_name);
Mc=size(cover_object,1);	%载体Height
Nc=size(cover_object,2);	%载体Width
watermark=rand(Mc,Nc);%生成等大的水印矩阵

key = uint8(zeros(Mc,Nc));
%对矩阵进行二值化处理
for i = 1:Mc 
    for j = 1:Nc 
        if watermark(i,j)>0.5
             key(i,j)=1;
        end
        if watermark(i,j)<0.5
             key(i,j)=0;
        end
    end
end

watermarked_image=cover_object;
for i = 1:Mc
    for j = 1:Nc
        if bitget(watermarked_image(i,j),1)~=bitget(key(i,j),1)%判断最低位与水印是否相同
            watermarked_image(i,j)=bitset(watermarked_image(i,j),1,key(i,j));
        end
    end
end

imwrite(watermarked_image,'watermarked_img.bmp','bmp');
figure,imshow(watermarked_image,[]),title('lsb替换算法：嵌入水印后图像')
elapsed_time=cputime-start_time


%% 卡方分析


%计算直方图

%原图
file_name=strcat('pic5.bmp');%要进行卡方分析的图片
[cover_object,map]=imread(file_name);
gray_level=[];
for i=1:256
    gray_level(i)=0;%灰度级序列
end
cover_object=cover_object(:);
for i=1:Mc*Nc
    gray_level(cover_object(i)+1)=gray_level(cover_object(i)+1)+1;%h(i)
end

x=[50:100];
figure,bar(x,gray_level(51:101)),title('原始图像直方图')

subk=[];
j=1;
for i=1:256
    if mod(i,2)==0
       subk(j)=gray_level(i)-gray_level(i-1);%求h(2k)与h(2k+1)的差值
       j=j+1;
    end
end

figure,bar(subk),title('原始图像卡方分析')

%含水印图片
file_name=strcat('watermarked_img.bmp');
[cover_object,map]=imread(file_name);
gray_level=[];
for i=1:256
    gray_level(i)=0;
end
cover_object=cover_object(:);
for i=1:Mc*Nc
    gray_level(cover_object(i)+1)=gray_level(cover_object(i)+1)+1;
end

x=[50:100];
figure,bar(x,gray_level(51:101)),title('lsb替换：图像直方图')
        
%计算h(2k+1)和h(2k)的差
subk=[];
j=1;
for i=1:256
    if mod(i,2)==0
       subk(j)=gray_level(i)-gray_level(i-1);
       j=j+1;
    end
end

figure,bar(subk),title('lsb替换：卡方分析')