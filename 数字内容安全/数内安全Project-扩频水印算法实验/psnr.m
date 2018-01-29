%Name:		Chris Shoemaker
%Course:	EER-280 - Digital Watermarking
%Project: 	Calculates the PSNR (Peak Signal to Noise Ratio)
%            of images A and A', both of size MxN

function [A] = psnr(image,image_prime,M,N)

    % convert to doubles
    image=double(image);
    image_prime=double(image_prime);

    % avoid divide by zero nastiness
    if ((sum(sum(image-image_prime))) == 0)    
        error('Input vectors must not be identical')
    else
%          psnr_num=M*N*max(max(image.^2));                % calc ulate numerator
%          % psnr_num=N*M*mean(mean(image.^2));
        psnr_num=M*N*255^2; % 输入图像数据类型内的最大取值，如对于8bit图像应为255
        psnr_den=sum(sum((image-image_prime).^2));      % calculate denominator   
        A=psnr_num/psnr_den;                            % calculate PSNRSNR = 20 log10(Vs/Vn),
        A=10*log10(A);
    end                                                %Vs 就是图像上感兴趣区域的平均值； Vn 就是图像上背景区域的平均值(即，噪音)。 

return

