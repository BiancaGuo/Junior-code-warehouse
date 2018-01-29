%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	LSB替换算法及其卡方分析

clc
clear all
close all
start_time=cputime;

file_name=strcat('pic5.bmp');
[cover_object,map]=imread(file_name);
% watermark_name=strcat('key.bmp');
% watermark=imread(watermark_name);
% watermark_=watermark; 
% watermark=double(watermark);
% watermark=fix(watermark./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
% watermark=uint8(watermark);
%         
Mc=size(cover_object,1);	%载体Height
Nc=size(cover_object,2);	%载体Width
        
% Mm=size(watermark,1);	        %水印图像Height
% Nm=size(watermark,2);	        %水印图像Width
watermark=rand(Mc,Nc);

key = uint8(zeros(Mc,Nc));
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

template=rand(Mc,Nc);%随机生成大小为Height*Width的随机数矩阵，每个数的范围为0~1
watermarked_image=cover_object;
for i = 1:Mc
    for j = 1:Nc
        if bitget(watermarked_image(i,j),1)~=bitget(key(i,j),1) %若最低位与待嵌入水印位不同
           if template(i,j)>0.5 %对该位像素值加1
               watermarked_image(i,j)=watermarked_image(i,j)+1;
           end
           if template(i,j)<0.5 %对该位像素值减1
               watermarked_image(i,j)=watermarked_image(i,j)-1;
           end
        end
    end
end

imwrite(watermarked_image,'watermarked_img2.bmp','bmp');
figure,imshow(watermarked_image,[]),title('lsb匹配算法：嵌入水印后图像')
elapsed_time=cputime-start_time


%% 卡方分析


%计算直方图

%原图
file_name=strcat('pic5.bmp');
[cover_object,map]=imread(file_name);
gray_level=[];
for i=1:256
    gray_level(i)=0;
end
cover_object=cover_object(:);
for i=1:Mc*Nc
    gray_level(cover_object(i)+1)=gray_level(cover_object(i)+1)+1;
end

x=[20:99];
figure,bar(x,gray_level(21:100))

subk=[];
j=1;
for i=1:256
    if mod(i,2)==0
       subk(j)=gray_level(i)-gray_level(i-1);
       j=j+1;
    end
end

figure,bar(subk)

%含水印图片
file_name=strcat('watermarked_img2.bmp');
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
figure,bar(x,gray_level(51:101)),title('lsb匹配：图像直方图')
        
%计算h(2k+1)和h(2k)的差
subk=[];
j=1;
for i=1:256
    if mod(i,2)==0
       subk(j)=gray_level(i)-gray_level(i-1);
       j=j+1;
    end
end

figure,bar(subk),title('lsb匹配：卡方分析')