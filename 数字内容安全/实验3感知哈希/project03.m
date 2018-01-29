%Name:		GuoYunting
%Course:	数字内容安全
%Project: 	感知哈希

clc; 
clear all; 
close all;  
img = imread('lena.bmp');  

[height,width]=size(img);
img2=double(img);
pic_g=imnoise(img,'gaussian',0.1); %加入高斯噪声
%pic_g=imread('house.bmp');
pic_g2=double(pic_g);
pic_sap=imnoise(img,'salt & pepper',0.02);%加入椒盐噪声
pic_sap2=double(pic_sap);

n = 8;                         %  按8x8分块
numc = height/n;                    %  图像分块的行  
numr = width/n;                    %图像分快的列  
                
avg_img=sum(sum(img2))/(height*width);%求出整幅图像均值
avg2_img=sum(sum(pic_g2))/(height*width);%求出整幅图像均值
avg3_img=sum(sum(pic_sap2))/(height*width);%求出整幅图像均值

array=[];
array2=[];
array3=[];
k=1;
t1 = (0:numr-1)*8 + 1; t2 = (1:numr)*8;     %  分别求得每一块图像的起始行的像素值  
t3 = (0:numc-1)*8 + 1; t4 = (1:numc)*8;     %分别求得每一块图像的起始列的像素值
for i = 1 : numc           
    for j = 1 : numr         
        temp = img2(t1(i):t2(i), t3(j):t4(j),:);      %暂存分块图像为temp  
        temp2 = pic_g2(t1(i):t2(i), t3(j):t4(j),:);      %暂存分块图像为temp2  
        temp3 = pic_sap2(t1(i):t2(i), t3(j):t4(j),:);      %暂存分块图像为temp3  
        
        s=sum(sum(temp)); 
        s2=sum(sum(temp2));
        s3=sum(sum(temp3));
        
        avg=double(s/(n*n));%求出原图各小分块均值
        avg2=double(s2/(n*n));%求出加入高斯噪声各小分块均值
        avg3=double(s3/(n*n));%求出加入椒盐噪声各小分块均值
        
        if avg>avg_img%求原图感知哈希值
            array(k)=1;
        else
            array(k)=0;
        end
        
        if avg2>avg2_img%求加入高斯噪声感知哈希值
            array2(k)=1;
        else
            array2(k)=0;
        end
        
        if avg3>avg3_img%求加入椒盐噪声感知哈希值
            array3(k)=1;
        else
            array3(k)=0;
        end
        
        k=k+1;
    end  
end  

same2=0;
same3=0;
for i=1:k-1
    if array2(i)==array(i)%比较加入高斯噪声的图像与原图的感知哈希值
        same2=same2+1;
    end
end

for i=1:k-1
    if array3(i)==array(i)%比较加入椒盐噪声的图像与原图的感知哈希值
        same3=same3+1;
    end
end

%设定NC阈值为0.8
if same2>0.8*k
    disp('图片1通过验证!')
end

if same3>0.8*k
    disp('图片2通过验证!')
end
