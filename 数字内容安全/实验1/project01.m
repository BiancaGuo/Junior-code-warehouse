%Name:		GuoYunting
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
file_name='_lena_std_bw.bmp';
%% 1）模拟数字图像噪声失真（高斯、椒盐…）
figure(1);
pic=imread(file_name);%原始图像
subplot(2,3,1);
imshow(pic),title('原图');

pic_g=imnoise(pic,'gaussian',0.02); %加入高斯噪声
subplot(2,3,2);
imshow(pic_g),title('加入高斯噪声');

pic_sap=imnoise(pic,'salt & pepper',0.02);%加入椒盐噪声
subplot(2,3,3);
imshow(pic_sap),title('加入椒盐噪声');

pic_spe=imnoise(pic,'speckle',0.02);%加入乘性噪声
subplot(2,3,4);
imshow(pic_spe),title('加入乘性噪声');

pic_poi=imnoise(pic,'poisson');%加入泊松噪音
subplot(2,3,5);
imshow(pic_poi),title('加入加入泊松噪音');


%% 2）模拟数字图像滤波操作（均值滤波、中值滤波…）
%中值滤波
figure(2);
%mpic_g=medfilt2(pic_g,[3 3]); %对加入高斯噪声图像进行中值滤波
mpic_g=median_filtering(pic_g,3);
subplot(2,2,1);
imshow(mpic_g),title('高斯噪声');

%mpic_sap=medfilt2(pic_sap,[3 3]); %对加入椒盐噪声图像进行中值滤波
mpic_sap=median_filtering(pic_sap,3);
subplot(2,2,2);
imshow(mpic_sap),title('椒盐噪声');

%mpic_spe=medfilt2(pic_spe,[3 3]); %对加入乘性噪声图像进行中值滤波
mpic_spe=median_filtering(pic_spe,3);
subplot(2,2,3);
imshow(mpic_spe),title('乘性噪声');

%mpic_poi=medfilt2(pic_poi,[3 3]); %对加入泊松噪音图像进行中值滤波
mpic_poi=median_filtering(pic_poi,3);
subplot(2,2,4);
imshow(mpic_poi),title('泊松噪声');


%3x3 均值滤波
figure(3);
l=ones(3,3);
l=l/9;  

%apic_g=conv2(double(pic_g),l);    
apic_g=mean_filter(pic_g,3); 
subplot(2,2,1);
imshow(apic_g,[]),title('高斯噪声'); %对加入高斯噪声图像进行均值滤波

%apic_sap=conv2(double(pic_sap),l); %对加入椒盐噪声图像进行均值滤波
apic_sap=mean_filter(pic_sap,3); 
subplot(2,2,2);
imshow(apic_sap,[]),title('椒盐噪声');

%apic_spe=conv2(double(pic_spe),l); %对加入乘性噪声图像进行均值滤波
apic_spe=mean_filter(pic_spe,3); 
subplot(2,2,3);
imshow(apic_spe,[]),title('乘性噪声');

%apic_poi=conv2(double(pic_poi),l); %对加入泊松噪音图像进行均值滤波
apic_poi=mean_filter(pic_poi,3); 
subplot(2,2,4);
imshow(apic_poi,[]),title('泊松噪声');

%{
%7x7 均值滤波
figure(4);
l2=ones(7,7);
l2=l2/49;  

apic_g=conv2(double(pic_g),l);                        
subplot(2,2,1);
imshow(apic_g,[]),title('高斯噪声'); %对加入高斯噪声图像进行均值滤波

apic_sap=conv2(double(pic_sap),l); %对加入椒盐噪声图像进行均值滤波
subplot(2,2,2);
imshow(apic_sap,[]),title('椒盐噪声');

apic_spe=conv2(double(pic_spe),l); %对加入乘性噪声图像进行均值滤波
subplot(2,2,3);
imshow(apic_spe,[]),title('乘性噪声');

apic_poi=conv2(double(pic_poi),l); %对加入泊松噪音图像进行均值滤波
subplot(2,2,4);
imshow(apic_poi,[]),title('泊松噪声');
%}


%% 3）观察分析滤波前后图像统计特征差异（灰度直方图，一阶差分图像的直方图…）
%统计灰度直方图
figure(5);
subplot(4,3,1);
imhist(pic_g); %高斯噪音
title('高斯噪声');

subplot(4,3,2);
imhist(mpic_g);%中值滤波后
title('高斯噪声经过中值滤波');

subplot(4,3,3);
imhist(uint8(apic_g));%均值滤波后
title('高斯噪声经过均值滤波');

subplot(4,3,4);
imhist(pic_sap); %椒盐噪音
title('椒盐噪音');

subplot(4,3,5);
imhist(mpic_sap);%中值滤波后
title('椒盐噪音经过中值滤波');

subplot(4,3,6);
imhist(uint8(apic_sap));%均值滤波后
title('椒盐噪音经过均值滤波');

subplot(4,3,7);
imhist(pic_spe); %乘性噪音
title('乘性噪音');

subplot(4,3,8);
imhist(mpic_spe);%中值滤波后
title('乘性噪音经过中值滤波');

subplot(4,3,9);
imhist(uint8(apic_spe));%均值滤波后
title('乘性噪音经过均值滤波');

subplot(4,3,10);
imhist(pic_poi); %泊松噪音
title('泊松噪音');

subplot(4,3,11);
imhist(mpic_sap);%中值滤波后
title('泊松噪音经过中值滤波');

subplot(4,3,12);
imhist(uint8(apic_sap));%均值滤波后
title('泊松噪音经过均值滤波');

%一阶差分图像的直方图(将差分结果取绝对值）
figure(6);

subplot(2,3,1);
diffpic_g= firstdifference(pic_g,'dx');
imhist(uint8(diffpic_g));
title('高斯噪声');

subplot(2,3,2);
diffmpic_g= firstdifference(mpic_g,'dx');
imhist(uint8(diffmpic_g));
title('高斯噪声经过中值滤波');

subplot(2,3,3);
diffapic_g= firstdifference(apic_g,'dx');
imhist(uint8(diffapic_g));
title('高斯噪声经过均值滤波');

subplot(2,3,4);
diffpic_sap= firstdifference(pic_sap,'dx');
imhist(uint8(diffpic_sap));
title('椒盐噪声');

subplot(2,3,5);
diffmpic_sap= firstdifference(mpic_sap,'dx');
imhist(uint8(diffmpic_sap));
title('椒盐噪声经过中值滤波');

subplot(2,3,6);
diffapic_sap= firstdifference(apic_sap,'dx');
imhist(uint8(diffapic_sap));
title('椒盐噪声经过均值滤波');


% display processing time
elapsed_time=cputime-start_time; display(strcat('Runing_time=',num2str(elapsed_time),'s;'))