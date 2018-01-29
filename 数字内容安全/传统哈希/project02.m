%Name:		
%Course:	数字内容安全
%Project: 	传统哈希
clc
clear all
close all
%% save start time
start_time=cputime;
%% read in the cover object
file_name='lena.bmp';
% 384x384像素
message=imread(file_name);
message_change_1=message;%改变(1,1)
message_change_2=message;%改变(340,340)
message_change_3=message;%改变(50,20)&(20,50)

%原值
message(1,1); %160
message(340,340); %190
message(50,20); %114
message(20,50); %93

%改变初始阵列，观察哈希值

message_change_1(1,1)=159;
message_change_2(340,340)=191;
message_change_3(50,20)=93;
message_change_3(20,50)=114;

%输出图像
figure(1);
subplot(2,2,1);
imshow(message),title('原图');
subplot(2,2,2);
imshow(message_change_1),title('改变(1,1)');
subplot(2,2,3);
imshow(message_change_2),title('改变(340,340)');
subplot(2,2,4);
imshow(message_change_3),title('改变(50,20)&(20,50)');

%使用SHA-1算法
algs='SHA-1';
h=hash(message,algs)
h1=hash(message_change_1,algs)
h2=hash(message_change_2,algs)
h3=hash(message_change_3,algs)
