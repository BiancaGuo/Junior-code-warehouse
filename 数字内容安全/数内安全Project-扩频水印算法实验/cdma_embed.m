%Name:		Chris Shoemaker
%Course:	EER-280 - Digital Watermarking
%Project: 	CDMA based using multiple PN sequences embeded into whole object
%           Watermark Embeding
clc
clear all
close all
% save start time
start_time=cputime;
alpha=0.0015;%0.2;                % set the gain factor for embeding 嵌入强度
display(strcat('alpha=',num2str(alpha),';'))
%% read in the cover object
file_name='_lena_std_bw.bmp';                 %'_lena_std_bw.bmp';
cover_object=double(imread(file_name));
figure,imshow(uint8(cover_object)),title('orignal image')
display(strcat('Cover_Img_Size=',num2str(size(cover_object,1)),'x',num2str(size(cover_object,2)),'pixels;'))
%% read in the message image and reshape it into a vector
file_name='_copyright_small.bmp';
message=double(imresize(imread(file_name),0.3));
% message=message(10:22,7:28).*2-3;    % 1,2 --> -1,+1,13x22=286
message=message(10:22,7:19).*2-3;    % 1,2 --> -1,+1,169
% message=message(10:16,7:19).*2-3;    % 1,2 --> -1,+1,91
% message=message(10:12,7:19).*2-3;    % 1,2 --> -1,+1,39
% message=message(10:25,:).*2-3;    % 1,2 --> -1,+1
figure,imagesc(message),title('orginal message'),colorbar,colormap('gray')
message=message(:);
%% Embedding
watermarked_image=cover_object;
for k=1:length(message)
    rng(k);
    pn_sequence=sign(randn(size(cover_object)));%
%     pn_sequence=sign(rand(size(cover_object))-0.5);
%     watermarked_image=watermarked_image+alpha*message(k)*pn_sequence; % 嵌入秘密信息比特 加性扩频方法
    watermarked_image=watermarked_image+alpha*message(k)*pn_sequence.*watermarked_image; % 嵌入秘密信息比特，乘性扩频方法
end
watermarked_image_uint8=uint8(watermarked_image);% convert back to uint8
imwrite(watermarked_image_uint8,'cdma_watermarked.bmp','bmp');% write watermarked Image to file
% display processing time
elapsed_time=cputime-start_time; display(strcat('Runing_time=',num2str(elapsed_time),'s;'))
% calculate the PSNR
psnrWk=psnr(cover_object,watermarked_image_uint8,size(cover_object,1),size(cover_object,2));
display(strcat('PSNR=',num2str(psnrWk),'dB;'))
% display watermarked Image
figure,imshow(uint8(watermarked_image_uint8)),title(strcat('wked image, PSNR=',num2str(psnrWk)))
figure,imshow(pn_sequence,[]),title('PN sequence')
capacity = length(message);display(strcat('Capacity=',num2str(capacity),'bits;'))
