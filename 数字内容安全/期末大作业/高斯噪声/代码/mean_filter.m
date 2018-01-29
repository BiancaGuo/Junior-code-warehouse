%均值滤波
function p=mean_filter(pic,n)     
m=ones(n,n);   %n×n模板
[height, width]=size(pic);   %输入图像是hightxwidth的,且hight>n,width>n  
%考虑边界，将pic1扩大
for i=1:height+2*n
    for j=1:width+2*n
        pic1(i,j)=0.0;
    end
end

for i=n+1:n+height
    for j=n+1:n+width
        pic1(i,j)=double(pic(i-n,j-n));
    end
end

pic2=pic1;
for i=1:height  
    for j=1:width  
        a=pic1(i:i+(n-1),j:j+(n-1)).*m; 
        s=sum(sum(a));                 %二维矩阵求和  
        pic2(i+(n-1)/2,j+(n-1)/2)=double(s/(n*n)); %求均值  
    end  
end  

%恢复为原来大小（384x384）
pic2=pic2(n+1:n+width,n+1:n+height);
p=uint8(pic2);  
