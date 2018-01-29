%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法
% JPEG测试
clc
clear all
close all
start_time=cputime;

%% 对图像进行操作，测试水印鲁棒性

watermarked_file_name='embed.bmp';%embed.bmp & lena.bmp
watermarked_image=imread(watermarked_file_name);

original_file_name='lena.bmp';%embed.bmp & lena.bmp
original_image=imread(original_file_name);

Mc=size(watermarked_image,1);%height
Nc=size(watermarked_image,2);%width

%裁剪[XMIN YMIN WIDTH HEIGHT]
%仅保留四分之一
%左上角
for i=1:Mc
    for j=1:Nc
        if i>=1&&i<=0.5*Mc&&j>=1&&j<=0.5*Nc
            LT(i,j)=watermarked_image(i,j);
            LT2(i,j)=original_image(i,j);
        else     
            LT(i,j)=0;
            LT2(i,j)=0;
        end
    end
end
            
path='..\';
file_name_out=strcat(path,'embed_LT','.bmp');
imwrite(uint8(LT),file_name_out,'bmp');
file_name_out=strcat(path,'lena_LT','.bmp');
imwrite(uint8(LT2),file_name_out,'bmp');

%右上角
for i=1:Mc
    for j=1:Nc
        if (i>=1&&i<=0.5*Mc)&&(j<=Nc&&j>=0.5*Nc)
            RT(i,j)=watermarked_image(i,j);
            RT2(i,j)=original_image(i,j);
        else
            RT(i,j)=0;
            RT2(i,j)=0;
        end
    end
end
            
path='..\';
file_name_out=strcat(path,'embed_RT','.bmp');
imwrite(uint8(RT),file_name_out,'bmp');
file_name_out=strcat(path,'lena_RT','.bmp');
imwrite(uint8(RT2),file_name_out,'bmp');
% 
%左下角
for i=1:Mc
    for j=1:Nc
        if (i>=0.5*Mc&&i<=Mc)&&(j>=1&&j<=0.5*Nc)
            LD(i,j)=watermarked_image(i,j);
            LD2(i,j)=original_image(i,j);
        else
            LD(i,j)=0;
            LD2(i,j)=0;
        end
    end
end
            
path='..\';
file_name_out=strcat(path,'embed_LD','.bmp');
imwrite(uint8(LD),file_name_out,'bmp');
file_name_out=strcat(path,'lena_LD','.bmp');
imwrite(uint8(LD2),file_name_out,'bmp');
% 
% %右下角
for i=1:Mc
    for j=1:Nc
        if (i>=0.5*Mc&&i<=Mc)&&(j>=0.5*Nc&&j<=Nc)
            RD(i,j)=watermarked_image(i,j);
            RD2(i,j)=original_image(i,j);
        else
            RD(i,j)=0;
            RD2(i,j)=0;
        end
    end
end
            
path='..\';
file_name_out=strcat(path,'embed_RD','.bmp');
imwrite(uint8(RD),file_name_out,'bmp');
file_name_out=strcat(path,'lena_RD','.bmp');
imwrite(uint8(RD2),file_name_out,'bmp');
