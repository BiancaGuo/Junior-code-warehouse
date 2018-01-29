%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	DCT 域图像水印-嵌入对策和算法

clc
clear all
close all
start_time=cputime;

%% 水印提取(原图jpeg压缩 and 嵌入水印后图片的jpeg压缩）

%剪切
for i=1:4
    path='..\';
    name='embed';%embed

    if i==1
        file_name_out=strcat(path,name,'_LT.bmp');
    end
    if i==2
        file_name_out=strcat(path,name,'_RT.bmp');
    end
    if i==3
        file_name_out=strcat(path,name,'_LD.bmp');
    end
    if i==4
        file_name_out=strcat(path,name,'_RD.bmp');
    end
    
    
  
    pending_file_name=file_name_out;%待检测图片
    [pending_file,map]=imread(pending_file_name);
    file_name='lena.bmp';%原始图片
    [cover_object,map]=imread(file_name);

    Mc=size(cover_object,1);
    Nc=size(cover_object,2);
    Mw=size(pending_file,1);
    Nw=size(pending_file,2);
    row=floor(Mw/8);
    col=floor(Nw/8);
    blocksize=8;
    %watermark_embed=load('watermark.txt');
    k = 1;
    for m = 1:row
        for n = 1:col
             x = (m-1)*blocksize+1;  
             y = (n-1)*blocksize+1;
             block_origin=cover_object(x:x+blocksize-1,y:y+blocksize-1);
             block_pending = pending_file(x:x+blocksize-1,y:y+blocksize-1);
             block_origin_dct = dct2(block_origin);
             block_pending_dct = dct2(block_pending);
             %watermark_extract(k)=block_pending_dct(1,1)-block_origin_dct(1,1);%提取出的待测水印序
             watermark_extract(k)=block_pending(1,1)-block_origin(1,1);%提取出的待测水印序
             block_origin = idct2(block_origin_dct);
             block_pending = idct2(block_pending_dct);
             cover_object(x:x+blocksize-1,y:y+blocksize-1) = block_origin; 
             pending_file(x:x+blocksize-1,y:y+blocksize-1) = block_pending; 
             k=k+1;
        end
    end
    
    %disp(strcat('相似度 = ',num2str(similarity)));
    path_watermark='..\..\剪切水印提取\';
    if i==1
        file_name_out=strcat(path_watermark,name,'_LT.txt');
    end
    if i==2
        file_name_out=strcat(path_watermark,name,'_RT.txt');
    end
    if i==3
        file_name_out=strcat(path_watermark,name,'_LD.txt');
    end
    if i==4
        file_name_out=strcat(path_watermark,name,'_RD.txt');
    end
    watermark_file = fopen(file_name_out,'wt');%数据保存在你当前的文件夹下，文件名为Data.txt
    fprintf(watermark_file,'%d\n',watermark_extract);
    fclose(watermark_file);
end


elapsed_time=cputime-start_time

