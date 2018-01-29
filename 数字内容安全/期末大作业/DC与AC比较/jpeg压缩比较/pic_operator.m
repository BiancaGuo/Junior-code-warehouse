%Name:		GuoYunting
%Course:	Êı×ÖÄÚÈİ°²È«
%Project: 	DCT ÓòÍ¼ÏñË®Ó¡-Ç¶Èë¶Ô²ßºÍËã·¨
% JPEGÑ¹Ëõ

clc
clear all
close all
start_time=cputime;

AC_watermarked_file_name='embed_AC.bmp';
AC_watermarked_image=imread(AC_watermarked_file_name);
DC_watermarked_file_name='embed_DC.bmp';
DC_watermarked_image=imread(DC_watermarked_file_name);
Mc=size(DC_watermarked_file_name,1);
Nc=size(DC_watermarked_file_name,2);
%jpegÑ¹Ëõ
for i=5:100
    path='.\jpegÑ¹ËõÍ¼Æ¬\';
    file_name_out=strcat(path,'embed_jpeg_Ñ¹Ëõ_ac',num2str(i),'.jpg');%ac
    imwrite(AC_watermarked_image,file_name_out,'jpg','quality',i);%jpegÑ¹Ëõ
    
    file_name_out=strcat(path,'embed_jpeg_Ñ¹Ëõ_dc',num2str(i),'.jpg');%dc
    imwrite(DC_watermarked_image,file_name_out,'jpg','quality',i);%jpegÑ¹Ëõ
end




