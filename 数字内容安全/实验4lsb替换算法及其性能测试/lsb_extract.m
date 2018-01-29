clc
clear all
close all

%% 提取图片水印信息

for k=1:2
    for v=1:2
        
        % 未处理载体图片提取
        path='.\lsb_pic\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'.bmp');
        watermarked_image=imread(watermarked_file_name);
        
        Mw=size(watermarked_image,1);	%Height
        Nw=size(watermarked_image,2);	%Width
   
        %嵌入图像的Height和Width
        Mm=watermarked_image(1,1);
        Nm=watermarked_image(2,2);
        
        watermark = uint8(zeros(Mm,Nm));
        for i = 3:Mm+2
            for j = 3:Nm+2
                watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
            end
        end
        
        watermark=fix(watermark.*255);
        path='.\lsb_watermark\';
        recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'key.bmp');
        imwrite(watermark,recover_watermark_name,'bmp');
        
%         %jpeg50压缩后的载体图像提取
%         path='.\lsb_operator\';
%         watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg50.jpg');
%         watermarked_image=imread(watermarked_file_name);
%         
%         Mw=size(watermarked_image,1);	%Height
%         Nw=size(watermarked_image,2);	%Width
%    
%         %嵌入图像的Height和Width
%         Mm=watermarked_image(1,1);
%         Nm=watermarked_image(2,2);
%         
%         watermark = uint8(zeros(Mm,Nm));
%         for i = 3:Mm+2
%             for j = 3:Nm+2
%                 watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
%             end
%         end
%         
%         watermark=fix(watermark.*255);
%         path='.\lsb_watermark\';
%         recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg50_key.bmp');
%         imwrite(watermark,recover_watermark_name,'bmp');
%         
%          %jpeg75压缩后的载体图像提取
%         path='.\lsb_operator\';
%         watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg75.jpg');
%         watermarked_image=imread(watermarked_file_name);
%         
%         Mw=size(watermarked_image,1);	%Height
%         Nw=size(watermarked_image,2);	%Width
%    
%         %嵌入图像的Height和Width
%         Mm=watermarked_image(1,1);
%         Nm=watermarked_image(2,2);
%         
%         watermark = uint8(zeros(Mm,Nm));
%         for i = 3:Mm+2
%             for j = 3:Nm+2
%                 watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
%             end
%         end
%         
%         watermark=fix(watermark.*255);
%         path='.\lsb_watermark\';
%         recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg75_key.bmp');
%         imwrite(watermark,recover_watermark_name,'bmp');
        
         %jpeg90压缩后的载体图像提取
        path='.\lsb_operator\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg90.jpg');
        watermarked_image=imread(watermarked_file_name);
        
        Mw=size(watermarked_image,1);	%Height
        Nw=size(watermarked_image,2);	%Width
   
        %嵌入图像的Height和Width
        Mm=watermarked_image(1,1);
        Nm=watermarked_image(2,2);
        
        watermark = uint8(zeros(Mm,Nm));
        for i = 3:Mm+2
            for j = 3:Nm+2
                watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
            end
        end
        
        watermark=fix(watermark.*255);
        path='.\lsb_watermark\';
        recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_jpg90_key.bmp');
        imwrite(watermark,recover_watermark_name,'bmp');
        
        
        %高斯噪声后的载体图像提取
        path='.\lsb_operator\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_gs.bmp');
        watermarked_image=imread(watermarked_file_name);
        
        Mw=size(watermarked_image,1);	%Height
        Nw=size(watermarked_image,2);	%Width
   
        %嵌入图像的Height和Width
        Mm=watermarked_image(1,1);
        Nm=watermarked_image(2,2);
        
        watermark = uint8(zeros(Mm,Nm));
        for i = 3:Mm+2
            for j = 3:Nm+2
                watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
            end
        end
        
        watermark=fix(watermark.*255);
        path='.\lsb_watermark\';
        recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_gs_key.bmp');
        imwrite(watermark,recover_watermark_name,'bmp');
        
        
        %椒盐噪声后的载体图像提取
        path='.\lsb_operator\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_sp.bmp');
        watermarked_image=imread(watermarked_file_name);
        
        Mw=size(watermarked_image,1);	%Height
        Nw=size(watermarked_image,2);	%Width
   
        %嵌入图像的Height和Width
        Mm=watermarked_image(1,1);
        Nm=watermarked_image(2,2);
        
        watermark = uint8(zeros(Mm,Nm));
        for i = 3:Mm+2
            for j = 3:Nm+2
                watermark(i-2,j-2)=bitget(watermarked_image(i,j),1);
            end
        end
        
        watermark=fix(watermark.*255);
        path='.\lsb_watermark\';
        recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_p_',num2str(v),'_sp_key.bmp');
        imwrite(watermark,recover_watermark_name,'bmp');

    end
end

%Wk_Diff_sum = 1-sum(sum(abs(double(double(watermark)-double(watermarkOrig)))))/Mw/Nw; 
%subplot(2,2,4),imshow(abs(double(double(watermark)-double(watermarkOrig))),[0,1]),title(strcat('正确检出率=',num2str(Wk_Diff_sum))),colorbar

%% 提取文字水印信息

for k=1:2
    for v=1:2
        
        % 未处理载体图片提取
        path='.\lsb_pic\';
        watermarked_file_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'.bmp');
        [watermarked_image,map]=imread(watermarked_file_name);

        Mc=size(watermarked_image,1);	%Height
        Nc=size(watermarked_image,2);	%Width
        
        watermarked_image=watermarked_image(:);
        %len=watermarked_image(1,1);
        len_of_len=watermarked_image(1);
        len_bin=[];
        for i=2:len_of_len+1
            len_bin(i-1)=bitget(watermarked_image(i),1);
        end
        len=bin2dec(num2str(len_bin()));%水印长度（dec）
        
        temp=1;
        watermark=[];
       
        for i=double(len_of_len)+2:double(len_of_len)+1+double(len)%提取出嵌入的二进制字符水印的逆序
            watermark(temp)=bitget(watermarked_image(i),1);
            temp=temp+1;
        end

        watermark=watermark(end:-1:1);%得到正序二进制序列
        temp=1;
        watermark_origin=[];
        for i=1:(len/8)
            watermark_origin(temp) = bin2dec(num2str(watermark((i - 1) * 8 + 1 : i * 8)));%二进制转ASCII
            temp=temp+1;
        end
        
        watermark_origin = native2unicode(watermark_origin,'UTF-8');%ASCII转字符逆序
        watermark_origin=watermark_origin(end:-1:1);%字符正序
        path='.\lsb_watermark\';
        recover_watermark_name=strcat(path,'pic',num2str(k),'_lsb_watermarked_w_',num2str(v),'key.txt');
        recover_watermark_file= fopen(recover_watermark_name, 'w');  
        fprintf(recover_watermark_file,watermark_origin);  
        fclose(recover_watermark_file);  

        
    end 
end

disp('hhh')

