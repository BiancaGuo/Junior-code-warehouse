clc
clear all
close all
start_time=cputime;
%% 提取图片水印信息


for i=25:25
    % 未处理载体图片提取
    watermarked_file_name=strcat('watermarked_img',num2str(i),'.bmp');
    watermarked_image=imread(watermarked_file_name); 
    Mw=size(watermarked_image,1);	%Height
    Nw=size(watermarked_image,2);	%Width
    watermarked_image=watermarked_image(:);%二维图像转化为一维
    Mm=fix(Mw/50)*i;%水印height和width
    Nm=fix(Nw/50)*i;
    watermark = uint8(zeros(Mm,Nm));
    
    %使用之前密钥决定提取位置
    rand('seed',i+1);
    place=round(1+(Mw*Nw-1)*rand(Mm,Nm))  

    for k = 1:Mm
        for v = 1:Nm
            watermark(k,v)=bitget(watermarked_image(place(k,v)),1);
        end
    end
        
    watermark=fix(watermark.*255);
    path='.\lsb_extract\';
    recover_watermark_name=strcat(path,'key',num2str(i),'.bmp');
    imwrite(watermark,recover_watermark_name,'bmp');%提取出的水印信息
        
        
     %jpeg90压缩后的载体图像提取
    path='.\lsb_operator\';
    watermarked_file_name=strcat(path,'watermarked_img',num2str(i),'jpeg90压缩.bmp');
    watermarked_image=imread(watermarked_file_name);
        
    Mw=size(watermarked_image,1);	%Height
    Nw=size(watermarked_image,2);	%Width
    watermarked_image=watermarked_image(:);
    
    Mm=round(Mw/50)*i;
    Nm=round(Nw/50)*i;
        
    watermark = uint8(zeros(Mm,Nm));
    
    %使用密钥决定提取位置
    rand('seed',i+1);
    place=round(1+(Mw*Nw-1)*rand(Mm,Nm));    
  
    for k = 1:Mm
        for v = 1:Nm
            watermark(k,v)=bitget(watermarked_image(place(k,v)),1);
        end
    end
        
    watermark=fix(watermark.*255);
    path='.\lsb_extract\';
    recover_watermark_name=strcat(path,'key',num2str(i),'jpeg90压缩.bmp');
    imwrite(watermark,recover_watermark_name,'bmp');


    %高斯噪声后的载体图像提取
    path='.\lsb_operator\';
    watermarked_file_name=strcat(path,'watermarked_img',num2str(i),'高斯噪声.bmp');
    watermarked_image=imread(watermarked_file_name);
        
    Mw=size(watermarked_image,1);	%Height
    Nw=size(watermarked_image,2);	%Width
    watermarked_image=watermarked_image(:);
    
    Mm=round(Mw/50)*i;
    Nm=round(Nw/50)*i;
        
    watermark = uint8(zeros(Mm,Nm));
    
    %使用密钥决定提取位置
    rand('seed',i+1);
    place=round(1+(Mw*Nw-1)*rand(Mm,Nm));    

    for k = 1:Mm
        for v = 1:Nm
            watermark(k,v)=bitget(watermarked_image(place(k,v)),1);
        end
    end
        
    watermark=fix(watermark.*255);
    path='.\lsb_extract\';
    recover_watermark_name=strcat(path,'key',num2str(i),'高斯噪声.bmp');
    imwrite(watermark,recover_watermark_name,'bmp');

    %椒盐噪声后的载体图像提取
    path='.\lsb_operator\';
    watermarked_file_name=strcat(path,'watermarked_img',num2str(i),'椒盐噪声.bmp');
    watermarked_image=imread(watermarked_file_name);
        
    Mw=size(watermarked_image,1);	%Height
    Nw=size(watermarked_image,2);	%Width
    watermarked_image=watermarked_image(:);
    
    Mm=round(Mw/50)*i;
    Nm=round(Nw/50)*i;
        
    watermark = uint8(zeros(Mm,Nm));
    
    %使用密钥决定提取位置
    rand('seed',i+1);
    place=round(1+(Mw*Nw-1)*rand(Mm,Nm));    

    for k = 1:Mm
        for v = 1:Nm
            watermark(k,v)=bitget(watermarked_image(place(k,v)),1);
        end
    end
    
    watermark=fix(watermark.*255);
    
    path='.\lsb_extract\';
    recover_watermark_name=strcat(path,'key',num2str(i),'椒盐噪声.bmp');
    imwrite(watermark,recover_watermark_name,'bmp');

elapsed_time=cputime-start_time
end


