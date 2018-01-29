clc
clear all
close all
%% save start time
start_time=cputime;
file_name='pic1.bmp';
[cover_object,map]=imread(file_name);
file_name='key.bmp';
message=imread(file_name);
message1=message;  
message=double(message);
message=fix(message./128);  
message=uint8(message);

watermark = uint8(zeros(Mc,Nc));
for i = 1:Mc 
    for j = 1:Nc 
        watermark(i,j)=message(mod(i-1,Mm)+1,mod(j-1,Nm)+1);  % 从（2,2）位置开始复制-平铺 ==》从（1,1）位置开始复制-平铺
    end
end
watermarked_image=cover_object;
for i = 1:Mc
    for j = 1:Nc
        watermarked_image(i,j)=bitset(watermarked_image(i,j),1,watermark(i,j)); %bitset(a,(i-th)bit,0/1) ,i=1,2,..,Tength(of a).1代表最低有效位
    end
end
imwrite(watermarked_image,'lsb_watermarked.bmp','bmp');
elapsed_time=cputime-start_time
psnr=psnr(cover_object,watermarked_image,Mc,Nc)
figure(11),imshow(watermarked_image,[]),title(strcat('Watermarked Image, PSNR=',num2str(psnr)))
figure(12),imshow(cover_object,[]),title('Original/Cover Image')
figure(13),imshow(watermark,[]),title('Watermark'), colorbar

figure(14),imshow(message,[]),title('Message'), colorbar