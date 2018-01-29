%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all

start_time=cputime;

%%  计算不同攻击操作后psnr(攻击后的图与原图）和 提取水印的相似度

file_name='lena.bmp';
cover_object=imread(file_name);
Mc=size(cover_object,1);
Nc=size(cover_object,2);
k=1;

em_y=[];
or_y=[];
for i=1:4
    disp('1/4剪切攻击');
   
 % 计算提取水印相似度
    disp('提取水印的相似度：');
    path_watermark='..\..\剪切水印提取\';
    %含水印
    
    if i==1
        disp('左上角：');
        file_name_out=strcat(path_watermark,'embed_LT.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_LT.txt'));
    end
    if i==2
        disp('右上角：');
        file_name_out=strcat(path_watermark,'embed_RT.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_RT.txt'));
    end
    if i==3
        disp('左下角：');
        file_name_out=strcat(path_watermark,'embed_LD.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_LD.txt'));
    end
    if i==4
        disp('右下角：');
        file_name_out=strcat(path_watermark,'embed_RD.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_RD.txt'));
    end
    disp('含水印图像经剪切处理：');
    watermark_extract=load(file_name_out);
    watermark_embed=load('watermark.txt');
    
    sum1=0;
    sum2=0;
    for v=1:length(watermark_extract)
        sum1=sum1+watermark_extract(v)*watermark_embed(v);
        sum2=sum2+watermark_extract(v)*watermark_extract(v);
    end
    
    similarity(k)=sum1/sqrt(sum2);%y轴
    em_y(i)=abs(sum1/sqrt(sum2));
    %disp(strcat('相似度 = ',num2str(sum1/sqrt(sum2))));
    
    %不含水印
    disp('不含水印图像经剪切处理：');
    if i==1
        file_name_out=strcat(path_watermark,'lena_LT.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_LT.txt'));
    end
    if i==2
        file_name_out=strcat(path_watermark,'lena_RT.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_RT.txt'));
    end
    if i==3
        file_name_out=strcat(path_watermark,'lena_LD.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_LD.txt'));
    end
    if i==4
        file_name_out=strcat(path_watermark,'lena_RD.txt');
        %watermark_embed=load(strcat(path_watermark,'lena_RD.txt'));
    end
    
    watermark_extract2=load(file_name_out);
    watermark_embed=load('watermark.txt');
    sum1=0;
    sum2=0;
    for v=1:length(watermark_extract2)
        sum1=sum1+watermark_extract2(v)*watermark_embed(v);
        sum2=sum2+watermark_extract2(v)*watermark_extract2(v);
    end

    similarity2(k)=sum1/sqrt(sum2);%y轴
    or_y(i)=abs(sum1/sqrt(sum2));
    k=k+1;
    disp(strcat('相似度 = ',num2str(sum1/sqrt(sum2))));
end

x=[1 2 3 4];
y1=em_y;
y2=or_y;
y_all=[y1;y2]';
bar(x,y_all)
%下面定义x轴的刻度
set(gca,'XTick',1:4);
%下面是x轴的刻度值
set(gca,'XTickLabel',{'左上角','左下角','右上角','右下角'});
title('四分之一裁减攻击');
xlabel('保留位置');
ylabel('similarity');
legend('嵌入水印','未嵌入水印',2);




elapsed_time=cputime-start_time

