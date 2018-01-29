%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	LSB替换算法



clc
clear all
close all

%% 对提取出的水印信息计算检出率

for k=1:1
    for v=1:1
        %% 卡方分析
        
        %原图像
        file_name_org=strcat('pic',num2str(k),'.bmp');
        [cover_object,map]=imread(file_name_org);
        Mc=size(cover_object,1);	%Height
        Nc=size(cover_object,2);	%Width
        
        gray_level=[];
        for i=1:256
            gray_level(i)=0;
        end
        cover_object=cover_object(:);
      
        for i=1:Mc*Nc
            gray_level(cover_object(i)+1)=gray_level(cover_object(i)+1)+1;
        end
        %计算直方图
        %test=[0,12,3,4];
        %bar(test)
        figure,
        bar(gray_level)
        
        %计算h(2k+1)和h(2k)的差
        subk=[];
        j=1;
        for i=1:256
            if mod(i,2)==0
                subk(j)=gray_level(i)-gray_level(i-1);
                j=j+1;
            end
        end
        figure,
        bar(subk)
        
        
        %原掩密载体
        %path='.\lsb_pic\';
        %file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'.bmp');%含密载体
        file_name='lsb_watermarked.bmp';
        [cover_object,map]=imread(file_name);
        Mc=size(cover_object,1);	%Height
        Nc=size(cover_object,2);	%Width
        
        gray_level=[];
        for i=1:256
            gray_level(i)=0;
        end
        cover_object=cover_object(:);
      
        for i=1:Mc*Nc
            gray_level(cover_object(i)+1)=gray_level(cover_object(i)+1)+1;
        end
        %计算直方图
        %test=[0,12,3,4];
        %bar(test)
        figure,
        bar(gray_level)
        
        %计算h(2k+1)和h(2k)的差
        subk=[];
        j=1;
        for i=1:256
            if mod(i,2)==0
                subk(j)=gray_level(i)-gray_level(i-1);
                j=j+1;
            end
        end
        figure,
        bar(subk)
        
%         %原掩密载体
%         figure,
%         path='.\lsb_pic\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'.bmp');%含密载体
%         image=imread(file_name);
%         subplot(2,2,1),imshow(image,[]),title('(Origin) Watermarked Image'),colorbar
%         
%         %原嵌入的水印图片
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'key',num2str(v),'.bmp');
%         oimage=imread(file_name);
%         [Mw,Nw]=size(oimage);
%         subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar
%         
%         
%         %原掩密载体提取出的水印信息
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'key.bmp');%提取的水印信息
%         rimage=imread(file_name);
%         subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar
%         
%         rimage=fix(rimage./128);
%         oimage=fix(oimage./128);
%         Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
%         subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率
%         
%         
%         
%         
% 
%          % jpeg压缩（90）
%         figure,
%         path='.\lsb_operator\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg90.jpg');%含密载体
%         image=imread(file_name);
%         subplot(2,2,1),imshow(image,[]),title('(jpeg压缩) Watermarked Image'),colorbar
%   
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'key',num2str(v),'.bmp');
%         oimage=imread(file_name);
%         [Mw,Nw]=size(oimage);
%         subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar
%         
%         %jpeg压缩提取出的水印信息
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg90_key.bmp');%提取的水印信息
%         rimage=imread(file_name);
%         rimage = imresize(rimage,[Mw Nw]);
%         subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar
%         
%         rimage=double(rimage);
%         rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         rimage=uint8(rimage);
%         
%         oimage=double(oimage);
%         oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         oimage=uint8(oimage);
%        
%         Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
%         subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率
%         
%         %高斯噪声
%         figure,
%         path='.\lsb_operator\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_gs.bmp');%含密载体
%         image=imread(file_name);
%         subplot(2,2,1),imshow(image,[]),title('(高斯噪声) Watermarked Image'),colorbar
%   
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'key',num2str(v),'.bmp');%原水印信息
%         oimage=imread(file_name);
%         [Mw,Nw]=size(oimage);
%         subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar
%         
%          %高斯噪声提取出的水印信息
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_gs_key.bmp');%提取的水印信息
%         rimage=imread(file_name);
%         rimage = imresize(rimage,[Mw Nw]);
%         subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar
%         
%         rimage=double(rimage);
%         rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         rimage=uint8(rimage);
%         
%         oimage=double(oimage);
%         oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         oimage=uint8(oimage);
%         Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
%         subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率
%         
%         %椒盐噪声
%         figure,
%         path='.\lsb_operator\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_sp.bmp');%含密载体
%         image=imread(file_name);
%         subplot(2,2,1),imshow(image,[]),title('(椒盐噪声) Watermarked Image'),colorbar
%   
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'key',num2str(v),'.bmp');%原水印信息
%         oimage=imread(file_name);
%         [Mw,Nw]=size(oimage);
%         subplot(2,2,2),imshow(oimage),title('Original Watermark'),colorbar
%         
%          %椒盐噪声提取出的水印信息
%         path='.\lsb_watermark\';
%         file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_sp_key.bmp');%提取的水印信息
%         rimage=imread(file_name);
%         rimage = imresize(rimage,[Mw Nw]);
%         subplot(2,2,3),imshow(rimage),title('Recovered Watermark'),colorbar
%         
%         rimage=double(rimage);
%         rimage=fix(rimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         rimage=uint8(rimage);
%         
%         oimage=double(oimage);
%         oimage=fix(oimage./128);  %pixel values: 1, 2 ==> 0, 1 fix：向下取整，将所有像素值除以128，将其二值化
%         oimage=uint8(oimage);
%         Wk_Diff_sum = 1-sum(sum(abs(double(double(rimage)-double(oimage)))))/Mw/Nw; 
%         subplot(2,2,4),imshow(abs(double(double(rimage)-double(oimage))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar %检出率
        
        
    end
end




disp('hhh')

