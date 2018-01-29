%Name:		Chris Shoemaker
%Course:	EER-280 - Digital Watermarking
%Project: 	CDMA based using multiple PN sequences embeded into whole object
%           Watermark Recovery
clc
clear all
close all
alpha = 0.0015;   
display(strcat('alpha=',num2str(alpha),';'))  %just for showing
% save start time
start_time=cputime;
%% read in the cover object, watermarked object
file_name='_lena_std_bw.bmp';                 %'_lena_std_bw.bmp';
cover_object=double(imread(file_name));
figure,imshow(uint8(cover_object)),title('orignal image')
display(strcat('Cover_Img_Size=',num2str(size(cover_object,1)),'x',num2str(size(cover_object,2)),'pixels;'))

file_name='cdma_watermarked.bmp';
watermarked_image=double(imread(file_name));
ImSiz = size(watermarked_image);
psnrWk=psnr(cover_object,watermarked_image,ImSiz(1),ImSiz(2));
display(strcat('watermarked iamge, PSNR=',num2str(psnrWk),'dB;'))
figure,imshow(uint8(watermarked_image)),title(strcat('wked image, PSNR=',num2str(psnrWk)))
%% %%%%%%%%%%%%%%%%%% distortion %%%%%%%%%%%%
watermarked_image=uint8(watermarked_image);

imwrite(watermarked_image,'temp.jpg','Quality',90);
watermarked_image2=imread('temp.jpg');
psnr_Dist=psnr(watermarked_image2,watermarked_image,ImSiz(1),ImSiz(2));
display(strcat('distorted wked iamge, PSNR=',num2str(psnr_Dist),'dB;'))
figure,imshow(watermarked_image2),title(strcat('distorted wked image, PSNR=',num2str(psnr_Dist)))
watermarked_image=watermarked_image2;

% watermarked_image2 = imnoise(watermarked_image,'gaussian',0,2*10^(-3)); %1~7*10^(-6)
% psnr_Dist=psnr(watermarked_image2,watermarked_image,size(watermarked_image,1),size(watermarked_image,2));
% figure,imshow(watermarked_image2),title(strcat('distorted wked image, PSNR=',num2str(psnr_Dist)))
% watermarked_image=watermarked_image2;

% watermarked_image2 = imnoise(watermarked_image,'salt & pepper',0.05); % 0~100%
% psnr_Dist=psnr(watermarked_image2,watermarked_image,size(watermarked_image,1),size(watermarked_image,2));
% figure,imshow(watermarked_image2),title(strcat('distorted wked image, PSNR=',num2str(psnr_Dist)))
% watermarked_image=watermarked_image2;

watermarked_image=double(watermarked_image);
%% read in the message image and reshape it into a vector % 仅用于计算秘密信息的正确检出率
file_name='_copyright_small.bmp';
message=double(imresize(imread(file_name),0.3));
% message=message(10:22,7:28).*2-3;    % 1,2 --> -1,+1,13x22=286
message=message(10:22,7:19).*2-3;    % 1,2 --> -1,+1,169
% message=message(10:16,7:19).*2-3;    % 1,2 --> -1,+1,91
% message=message(10:12,7:19).*2-3;    % 1,2 --> -1,+1,39
% message=message(10:25,:).*2-3;    % 1,2 --> -1,+1
figure,imagesc(message),title('orginal message'),colorbar,colormap('gray')
messageImgSize = size(message);
message=message(:);
%% Extraction wk
% given PN keys （including the number of message bits length(message)） and alpha
for k=1:length(message)
    rng(k);
    pn_sequence=sign(randn(size(cover_object)));%
%     pn_sequence=sign(rand(size(watermarked_image))-0.5);
    correlation(k)=sum(sum((watermarked_image-mean2(watermarked_image)).*pn_sequence))/ImSiz(1)/ImSiz(2);
%     correlation(k)=sum(sum((watermarked_image-cover_object).*pn_sequence))/ImSiz(1)/ImSiz(2);
end
figure,plot(correlation),title('correlation values')
threshold=0;
message_recover = (correlation>=threshold).*2-1; % if correlation exceeds threshold, set message bit low
elapsed_time=cputime-start_time; display(strcat('Runing_time=',num2str(elapsed_time),'s;'))% display processing time

%  correlation(k)=corr2(watermarked_image,pn_sequence);   % calculate correlation
% threshold=mean(correlation);% use the average correlation value as threshold
%% reshape the message vector and display recovered watermark.
capacity = length(message);display(strcat('Capacity=',num2str(capacity),'bits;'))
precision = sum(message_recover'==message)/length(message); display(strcat('Precision=',num2str(precision*100),'%;'))
message_recover=reshape(message_recover',messageImgSize);
figure,imagesc(message_recover),title('Recovered Message'),colorbar,colormap('gray')
