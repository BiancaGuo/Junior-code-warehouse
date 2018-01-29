function dimg = firstdifference(img,direction)
    imgPad = padarray(img,[1 1],'symmetric','both');%将原图像的边界扩展
    [row,col] = size(imgPad);
    dimg = zeros(row,col);
    switch (direction)   
    case 'dx',
       dimg(:,1:col-1) = imgPad(:,2:col)-imgPad(:,1:col-1);%x方向差分计算，
    case 'dy',
       dimg(1:row-1,:) = imgPad(2:row,:)-imgPad(1:row-1,:); 
    otherwise, disp('Direction is unknown');
    end;
    dimg = dimg(2:end-1,2:end-1);

end

