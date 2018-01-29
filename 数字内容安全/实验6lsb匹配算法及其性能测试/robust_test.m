%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	LSB替换算法

clc
clear all
close all

start_time=cputime;
%% 对提取出的水印信息计算检出率
%不同容量
for i=25:25
        
    %载体
    figure,
    file_name=strcat('watermarked_img',num2str(i),'.bmp');%含密载体
    image=imread(file_name);
    subplot(2,2,1),imshow(image,[]),title('(Origin) Watermarked Image'),colorbar

    %原嵌入的水印图片
    file_name=strcat('key',num2str(i),'.bmp');
    oimage=imread(file_name);
    [Mw,Nw]=size(oimage);
    subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar


    %含密载体提取出的水印信息
    path='.\lsb_extract\';
    file_name=strcat(path,'key',num2str(i),'.bmp');
    rimage=imread(file_name);
    subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar

    rimage=fix(rimage./128);
    oimage=fix(oimage./128);
    Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
    subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率





     % jpeg压缩（90）
    figure,
    path='.\lsb_operator\';
    file_name=strcat(path,'watermarked_img',num2str(i),'jpeg90压缩.bmp');%含密载体
    image=imread(file_name);
    subplot(2,2,1),imshow(image,[]),title('(jpeg压缩) Watermarked Image'),colorbar

    %path='.\lsb_watermark\';
    file_name=strcat('key',num2str(i),'.bmp');
    oimage=imread(file_name);
    [Mw,Nw]=size(oimage);
    subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar

    %jpeg压缩提取出的水印信息
    path='.\lsb_extract\';
    file_name=strcat(path,'key',num2str(i),'jpeg90压缩.bmp');
    rimage=imread(file_name);
    rimage = imresize(rimage,[Mw Nw]);
    subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar

    rimage=double(rimage);
    rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    rimage=uint8(rimage);

    oimage=double(oimage);
    oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    oimage=uint8(oimage);

    Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
    subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率

    %高斯噪声
    figure,
    path='.\lsb_operator\';
    file_name=strcat(path,'watermarked_img',num2str(i),'高斯噪声.bmp');%含密载体
    image=imread(file_name);
    subplot(2,2,1),imshow(image,[]),title('(高斯噪声) Watermarked Image'),colorbar

    %path='.\lsb_watermark\';
    file_name=strcat('key',num2str(i),'.bmp');%原水印信息
    oimage=imread(file_name);
    [Mw,Nw]=size(oimage);
    subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar

     %高斯噪声提取出的水印信息
    path='.\lsb_extract\';
    file_name=strcat(path,'key',num2str(i),'高斯噪声.bmp');
    rimage=imread(file_name);
    rimage = imresize(rimage,[Mw Nw]);
    subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar

    rimage=double(rimage);
    rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    rimage=uint8(rimage);

    oimage=double(oimage);
    oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    oimage=uint8(oimage);
    Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
    subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率

    %椒盐噪声
    figure,
    path='.\lsb_operator\';
    file_name=strcat(path,'watermarked_img',num2str(i),'椒盐噪声.bmp');%含密载体
    image=imread(file_name);
    subplot(2,2,1),imshow(image,[]),title('(椒盐噪声) Watermarked Image'),colorbar

    %path='.\lsb_watermark\';
    file_name=strcat('key',num2str(i),'.bmp');%原水印信息
    oimage=imread(file_name);
    [Mw,Nw]=size(oimage);
    subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar

     %椒盐噪声提取出的水印信息
    path='.\lsb_extract\';
    file_name=strcat(path,'key',num2str(i),'椒盐噪声.bmp');
    rimage=imread(file_name);
    rimage = imresize(rimage,[Mw Nw]);
    subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar

    rimage=double(rimage);
    rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    rimage=uint8(rimage);

    oimage=double(oimage);
    oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
    oimage=uint8(oimage);
    Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
    subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率

end


elapsed_time=cputime-start_time

