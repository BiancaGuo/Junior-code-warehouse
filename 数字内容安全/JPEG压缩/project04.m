%Name:		
%Course:	数字内容安全
%aim: 	1）模拟数字图像噪声失真（高斯、椒盐…）
%       2）模拟数字图像滤波操作（均值滤波、中值滤波…）
%       3）观察分析滤波前后图像统计特征差异（灰度直方图，一阶差分图像的直方图…）
%       **边界像素处理 ：填充、映射

clc
clear all
close all
%% save start time
start_time=cputime;
%% read in the cover object
file_name='baboon512.bmp';
img=imread(file_name);
[h,w]=size(img);
array=[];
for i=1:100
    %'quality',q是质量因子，对图像进行压缩时，q是0-100之间的整数，数越小，图像压缩越严重，量化步长越大（很多默认情况下q取70）
     file_name_out=strcat('baboon_change_',num2str(i),'.jpg');
    imwrite(img,file_name_out,'jpg','quality',i);
    img_out=imread(file_name_out);
    a=sum(sum(img_out));
    avg=a/(h*w);
    array(i)=avg;
end
%cr=imratio('H1.bmp','baboon_change.jpg');
plot(array)
xlabel('质量因子q')%x轴标记
ylabel('压缩图像均值')%y轴标记
title('质量因子增大过程中图像均值的变化情况')%标题


% display processing time
elapsed_time=cputime-start_time; display(strcat('Runing_time=',num2str(elapsed_time),'s;'))