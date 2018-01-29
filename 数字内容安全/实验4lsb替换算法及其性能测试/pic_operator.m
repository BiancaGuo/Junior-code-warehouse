%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	LSB替换算法

clc
clear all
close all
start_time=cputime;

%% JPEG压缩

%% 高斯噪声

%% 椒盐噪声

clc
clear all
close all

%% 对嵌入图片水印信息的载体图像进行处理

for k=1:2
    for v=1:2
        path='.\lsb_pic\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'.bmp');
        watermarked_image=imread(watermarked_file_name);
        
%         % jpeg压缩（50）
%         path='.\lsb_operator\';
%         file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg50.jpg');
%         imwrite(watermarked_image,file_name_out,'jpg','quality',50);
%         
%          % jpeg压缩（75）
%         path='.\lsb_operator\';
%         file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg75.jpg');
%         imwrite(watermarked_image,file_name_out,'jpg','quality',75);
        
         % jpeg压缩（90）
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg90.jpg');
        imwrite(watermarked_image,file_name_out,'jpg','quality',90);
        
        %高斯噪声
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_gs.bmp');
        pic_g=imnoise(watermarked_image,'gaussian',0.02);
        imwrite(pic_g,file_name_out,'bmp');
        
        %椒盐噪声
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_sp.bmp');
        pic_sap=imnoise(watermarked_image,'salt & pepper',0.02);
        imwrite(pic_sap,file_name_out,'bmp');
        
    end
end


%% 对嵌入文字水印信息的载体图像进行处理

for k=1:2
    for v=1:2
        path='.\lsb_pic\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'.bmp');
        watermarked_image=imread(watermarked_file_name);
        
%         % jpeg压缩（50）
%         path='.\lsb_operator\';
%         file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'_jpg50.jpg');
%         imwrite(watermarked_image,file_name_out,'jpg','quality',50);
%         
%          % jpeg压缩（75）
%         path='.\lsb_operator\';
%         file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'_jpg75.jpg');
%         imwrite(watermarked_image,file_name_out,'jpg','quality',75);
        
         % jpeg压缩（90）
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'_jpg90.jpg');
        imwrite(watermarked_image,file_name_out,'jpg','quality',90);
        
        %高斯噪声
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'_gs.bmp');
        pic_g=imnoise(watermarked_image,'gaussian',0.02);
        imwrite(pic_g,file_name_out,'bmp');
        
        %椒盐噪声
        path='.\lsb_operator\';
        file_name_out=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'_sp.bmp');
        pic_sap=imnoise(watermarked_image,'salt & pepper',0.02);
        imwrite(pic_sap,file_name_out,'bmp');
       
    end 
end

disp('hhh')

