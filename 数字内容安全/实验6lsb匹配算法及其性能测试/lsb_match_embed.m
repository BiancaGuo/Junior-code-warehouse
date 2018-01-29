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
%嵌入水印的最小heigh和width
Mm=fix(Mc/50); 	        
Nm=fix(Nc/50);	        
cover_object=cover_object(:);
%对一幅图片测试50个不同容量
for i=25:25
    %随机生成嵌入的二值图片（0,1)
    watermark=rand(Mm*i,Nm*i);
    key = uint8(zeros(Mm*i,Nm*i));
    for k = 1:Mm*i 
        for v = 1:Nm*i 
            if watermark(k,v)>0.5
                 key(k,v)=1;
            end
            if watermark(k,v)<0.5
                 key(k,v)=0;
            end
        end
    end
    
    %使用密钥决定嵌入位置
    rand('seed',i+1);
    place=round(1+(Mc*Nc-1)*rand(Mm*i,Nm*i))%在载体图像中选择和水印信息像素个数相同的位置进行嵌入

  
    %决定水印信息与像素最低位不同时，像素值进行减1还是加1操作
    template=rand(Mm*i ,Nm*i);
    watermarked_image=cover_object;
    for k = 1:Mm*i 
        for v = 1:Nm*i 
            if bitget(watermarked_image(place(k,v)),1)~=bitget(key(k,v),1)%水印信息与像素最低位不同
               if template(k,v)>0.5||watermarked_image(place(k,v))==0%当 template(k,v)>0.5 或者该位像素为0时进行加1操作
                   watermarked_image(place(k,v))=watermarked_image(place(k,v))+1;
               end
               if template(k,v)<0.5||watermarked_image(place(k,v))==255%当 template(k,v)<0.5 或者该位像素为255时进行加1操作
                   watermarked_image(place(k,v))=watermarked_image(place(k,v))-1;
               end
            end
        end
    end

    watermarked_image=reshape(watermarked_image,Mc,Nc);
    cover_object=reshape(cover_object,Mc,Nc);
    key=fix(key.*255);
    imwrite(key,strcat('key',num2str(i),'.bmp'));
    imwrite(watermarked_image,strcat('watermarked_img',num2str(i),'.bmp'));
    %figure,imshow(watermarked_image,[]),title('lsb匹配算法：嵌入水印后图像')
    elapsed_time=cputime-start_time
    
    
     %计算PSNR
     watermarked_image_psnr=psnr(cover_object,watermarked_image,Mc,Nc);
     PSNR(i) = watermarked_image_psnr;%y轴
     CAPACITY(i) = (Nm*i*Mm*i)/(Nc*Nc);%x轴  

end


%绘制PSNR~容量图
x=CAPACITY;
y=PSNR;
figure,plot(x,y);
xlabel('水印容量')%x轴标记
ylabel('psnr值')%y轴标记
title(strcat('PSNR~容量图'))%标题
