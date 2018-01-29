#include <windows.h>
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include<iostream>
#include<sstream>
#include<iomanip>
#include<string>
#include <DbgHelp.h>
#pragma comment(lib,"dbghelp.lib")  
#include"debugger.h"
using namespace std;
void EnterDebugLoop(const LPDEBUG_EVENT);
DWORD OnCreateThreadDebugEvent(const LPDEBUG_EVENT) { printf("OnCreateThreadDebugEvent\n"); return 0; };
DWORD OnCreateProcessDebugEvent(const LPDEBUG_EVENT) { printf("OnCreateProcessDebugEvent\n"); return 0; };
DWORD OnExitThreadDebugEvent(const LPDEBUG_EVENT) { printf("OnExitThreadDebugEvent\n"); return 0; };
DWORD OnExitProcessDebugEvent(const LPDEBUG_EVENT) { printf("OnExitProcessDebugEvent\n"); return 0; };
DWORD OnLoadDllDebugEvent(const LPDEBUG_EVENT dv)
{
	printf("OnLoadDllDebugEvent %x\n", dv->u.LoadDll.hFile);
	return 0;
}
DWORD OnUnloadDllDebugEvent(const LPDEBUG_EVENT) { printf("OnUnloadDllDebugEvent\n"); return 0; };
DWORD OnOutputDebugStringEvent(const LPDEBUG_EVENT) { printf("OnOutputDebugStringEvent\n"); return 0; };
DWORD OnRipEvent(const LPDEBUG_EVENT) { printf("OnRipEvent\n"); return 0; };

STARTUPINFO si;          //指定新进程的主窗口特性的一个结构
PROCESS_INFORMATION pi;  //该结构返回有关新进程及其主线程的信息
DEBUG_EVENT DebugEv;     //结构体返回进程的调试信息



//获取被调试进程的主线程的上下文环境。
void GetDebuggeeContext(CONTEXT* pContext) {

	pContext->ContextFlags = CONTEXT_FULL;

	if (GetThreadContext(pi.hThread, pContext) == FALSE) {//获取寄存器的值

		std::wcout << TEXT("GetThreadContext failed: ") << GetLastError() << std::endl;
		exit(-1);
	}

}

//设置被调试进程的主线程的上下文环境
void SetDebuggeeContext(CONTEXT* pContext) {

	if (SetThreadContext(pi.hThread, pContext) == FALSE) {

		std::wcout << TEXT("SetThreadContext failed: ") << GetLastError() << std::endl;
		exit(-1);
	}

}
char ByteToChar(BYTE byte) {

	if (byte >= 0x00 && byte <= 0x1F) {
		return '.';
	}


	if (byte >= 0x81 && byte <= 0xFF) {
		return '?';
	}

	return (char)byte;
}
void DumpHex(unsigned int address, unsigned int length) {
	//存储每一行字节对应的ASCII字符。
	char content[17] = { 0 };

	//将起始输出的地址对齐到16的倍数。
	unsigned int blankLen = address % 16;
	unsigned int startAddress = address - blankLen;

	unsigned int lineLen = 0;
	unsigned int contentLen = 0;

	//输出对齐后第一行的空白。
	if (blankLen != 0) {

		cout<< hex<< uppercase << setfill('0') << setw(8) << startAddress << TEXT("  ");
		startAddress += 16;
		for (unsigned int len = 0; len < blankLen; ++len) {

			cout << hex << uppercase << TEXT("   ");
			content[contentLen] = TEXT(' ');
			++contentLen;
			++lineLen;
		}
	}

	//逐个字节读取被调试进程的内存，并输出。
	BYTE byte;

	for (unsigned int memLen = 0; memLen < length; ++memLen) {
		unsigned int curAddress = address + memLen;
		//如果是每行的第一个字节，则先输出其地址。
		if (lineLen % 16 == 0) {
			cout << hex << uppercase <<  setfill('0') << setw(8) << startAddress << TEXT("  ");
			startAddress += 16;
			lineLen = 0;
		}

		//读取内存，如果成功的话，则原样输出，并获取其对应的ASCII字符。
		if (ReadProcessMemory(pi.hProcess, (LPCVOID)curAddress, &byte, 1, NULL) == TRUE) {
			cout << hex << uppercase << setfill('0') << setw(2) << byte << TEXT(' ');
			content[contentLen] = ByteToChar(byte);
		}
		//如果读取失败，则以 ?? 代替。
		else {
			cout << hex << uppercase << TEXT("?? ");
			content[contentLen] = TEXT('.');
		}

		//如果一行满了16个字节，则输出换行符。由于从0开始计数，所以这里与15比较。
		if (contentLen == 15) {
			cout << hex << uppercase << TEXT(' ') << content << std::endl;
		}

		++contentLen;
		contentLen %= 16;

		++lineLen;
	}

	//输出最后一行的空白，为了使最后一行的ASCII字符对齐上一行。
	for (unsigned int len = 0; len < 16 - lineLen; ++len) {

		cout << hex << uppercase << TEXT("   ");
	}

	//输出最后一行的ASCII字符。
	cout << hex << uppercase << TEXT(' ');
	content[contentLen] = 0;
	cout << hex << uppercase << content;
	//cout << dumpStr.str() << endl;
}

/**
//显示局部变量命令的处理函数。
//命令格式为 lv [expression]
//参数expression表示仅显示符合指定通配符表达式的变量，如果省略则显示全部变量。

//用来保存一些变量信息的结构体
struct VARIABLE_INFO {
	DWORD address;
	DWORD modBase;
	DWORD size;
	DWORD typeID;
	string name;
};

//获取符号的虚拟地址
//如果符号是一个局部变量或者参数，
//pSymbol->Address是相对于EBP的偏移，
//将两者相加就是符号的虚拟地址
DWORD GetSymbolAddress(PSYMBOL_INFO pSymbolInfo) {

	if ((pSymbolInfo->Flags & SYMFLAG_REGREL) == 0) {
		return DWORD(pSymbolInfo->Address);
	}

	//如果当前EIP指向函数的第一条指令，则EBP的值仍然是属于
	//上一个函数的，所以此时不能使用EBP，而应该使用ESP-4作
	//为符号的基地址。

	CONTEXT context;
	GetDebuggeeContext(&context);

	//获取当前函数的开始地址
	DWORD64 displacement;
	SYMBOL_INFO symbolInfo = { 0 };
	symbolInfo.SizeOfStruct = sizeof(SYMBOL_INFO);

	SymFromAddr(pi.hProcess,context.Eip,&displacement,&symbolInfo);

	//如果是函数的第一条指令，则不能使用EBP
	if (displacement == 0) {
		return DWORD(context.Esp - 4 + pSymbolInfo->Address);
	}

	return DWORD(context.Ebp + pSymbolInfo->Address);
}

BOOL CALLBACK EnumVariablesCallBack(PSYMBOL_INFO pSymInfo, ULONG SymbolSize, PVOID UserContext) {

	list<VARIABLE_INFO>* pVarInfoList = (list<VARIABLE_INFO>*)UserContext;

	VARIABLE_INFO varInfo;

	if (pSymInfo->Tag == SymTagData) {

		varInfo.address = GetSymbolAddress(pSymInfo);
		varInfo.modBase = (DWORD)pSymInfo->ModBase;
		varInfo.size = SymbolSize;
		varInfo.typeID = pSymInfo->TypeIndex;
		varInfo.name = pSymInfo->Name;

		pVarInfoList->push_back(varInfo);
	}

	return TRUE;
}

void OnShowLocalVariables() {

	//获取当前函数的开始地址
	CONTEXT context;
	GetDebuggeeContext(&context);

	//设置栈帧
	IMAGEHLP_STACK_FRAME stackFrame = { 0 };
	stackFrame.InstructionOffset = context.Eip;

	if (SymSetContext(pi.hProcess, &stackFrame, NULL) == FALSE) {

		if (GetLastError() != ERROR_SUCCESS) {
			cout << "No debug info in current address." << endl;
			return;
		}
	}

	LPCWSTR expression = NULL;

	//枚举符号
	list<VARIABLE_INFO> varInfoList;

	if (SymEnumSymbols(
		pi.hProcess,
		0,
		(PCSTR)expression,
		EnumVariablesCallBack,
		&varInfoList) == FALSE) {
		cout << "SymEnumSymbols failed: " << GetLastError() << endl;
	}
	
	for (list<VARIABLE_INFO>::iterator it = varInfoList.begin(); it != varInfoList.end(); ++it)
	{
		cout << it->address << " ";
		cout << it->modBase << " ";
		cout << it->size << " ";
		cout << it->typeID << " ";
		cout << it->name << " ";
	}
	cout << endl;
}

*/
//context.esp就是函数的返回地址，context.esp+4位置的值就是函数的第一个参数，context.esp+8就是第二个参数，依次类推可以得到你想要的任何参数。需要注意的是因为参数是在被调试进程中的内容，所以你必须通过ReadProcessMemory函数才能得到： 

LONG GetEntryPointAddress() {

	HANDLE hProcess = GetCurrentProcess();
	SymInitialize(hProcess, NULL, TRUE);
	SymSetOptions(SYMOPT_EXACT_SYMBOLS);
	SetLastError(0);
	SYMBOL_INFO symbol = { 0 };
	symbol.SizeOfStruct = sizeof(symbol);
	BOOL result = SymFromName(hProcess, "main", &symbol);
	if (result == TRUE) 
	{
		printf("symbol : 0x%I64X\n", symbol.Address);
		printf("error : %u, result : %u\n", GetLastError(), result);
	}
	return 0;
}

void step_through(CONTEXT context)
{


	cout << "EIP :"<< uppercase << hex << context.Eip << endl;
	cout << endl;
	cout << "寄存器值 :" << endl;
	cout << "eax：" << uppercase << hex << context.Eax << endl;
	cout << "ebx：" << uppercase << hex << context.Ebx << endl;
	cout << "ecx：" << uppercase << hex << context.Ecx << endl;
	cout << "edx：" << uppercase << hex << context.Edx << endl;
	cout << "esi：" << uppercase << hex << context.Esi << endl;
	cout << "edi：" << uppercase << hex << context.Edi << endl;
	cout << "esp：" << uppercase << hex << context.Esp << endl;
	cout << "ebp：" << uppercase << hex << context.Ebp << endl;
	
	//DWORD buf[4]; // 取4个参数
	//ReadProcessMemory(pi.hProcess, (void*)(context.Esp + 4), &buf, sizeof(buf),NULL);
	cout << endl;
	cout << "显示内存内容："<<endl;
	unsigned int address = 0;
	unsigned int length = 128;
	address = context.Eip;
	DumpHex(address, length);
	
	cout << endl << endl;
	/*
	cout << "显示局部变量：" << endl;
	OnShowLocalVariables();
	cout << endl << endl;
	*/
}
HANDLE hProcess;

void main()
{

	ZeroMemory(&si, sizeof(si));
	//大小
	si.cb = sizeof(si);////包含STARTUPINFO结构中的字节数
	ZeroMemory(&pi, sizeof(pi));


	// Start the child process. 
	
	if (CreateProcess(
		TEXT("fussing 测试.exe"),
		//argv[1],
		NULL, // 命令行字符串 
		NULL,   //  指向一个NULL结尾的、用来指定可执行模块的宽字节字符串  
		NULL, //    指向一个SECURITY_ATTRIBUTES结构体，这个结构体决定是否返回的句柄可以被子进程继承。  
			  //NULL, //    如果lpProcessAttributes参数为空（NULL），那么句柄不能被继承。<同上>  
		false,//    指示新进程是否从调用进程处继承了句柄。   
			  //DEBUG_ONLY_THIS_PROCESS | CREATE_NEW_CONSOLE,  //  指定附加的、用来控制优先类和进程的创建的标  
			  //  CREATE_NEW_CONSOLE  新控制台打开子进程  
			  //  CREATE_SUSPENDED    子进程创建后挂起，直到调用ResumeThread函数  
		DEBUG_PROCESS,
		NULL, //    指向一个新进程的环境块。如果此参数为空，新进程使用调用进程的环境  
		NULL, //    指定子进程的工作路径  
		&si, // 决定新进程的主窗体如何显示的STARTUPINFO结构体  
		&pi  // 接收新进程的识别信息的PROCESS_INFORMATION结构体  
	) == FALSE)           // Pointer to PROCESS_INFORMATION structure
	{
		printf("CreateProcess failed (%d).\n", GetLastError());
		return;
	}

	// Wait until child process exits.	等待子进程结束。关闭handle。
	//WaitForSingleObject(pi.hProcess, INFINITE);
	EnterDebugLoop(&DebugEv);
	// Close process and thread handles. 


	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
}

void EnterDebugLoop(const LPDEBUG_EVENT DebugEv)
{
	DWORD dwContinueStatus = DBG_CONTINUE; // exception continuation 
	EXCEPTION_RECORD x;
	BOOL waitEvent = TRUE;
	CONTEXT context;
	
	GetDebuggeeContext(&context);
	cout << GetEntryPointAddress();


	//if (GetEntryPointAddress() == context.Eip)
	//{


		context.EFlags |= 0x100;
		SetDebuggeeContext(&context);
		int single = 0;
		for (;;)
		{
			// Wait for a debugging event to occur. The second parameter indicates
			// that the function does not return until a debugging event occurs. 

			WaitForDebugEvent(DebugEv, INFINITE);

			// Process the debugging event code. 

			switch (DebugEv->dwDebugEventCode)
			{
			case EXCEPTION_DEBUG_EVENT:
				// Process the exception code. When handling 
				// exceptions, remember to set the continuation 
				// status parameter (dwContinueStatus). This value 
				// is used by the ContinueDebugEvent function. 

				switch (DebugEv->u.Exception.ExceptionRecord.ExceptionCode)
				{
				case EXCEPTION_ACCESS_VIOLATION:
					single = 0;
					// First chance: Pass this on to the system. 
					// Last chance: Display an appropriate error. 
					/*definations*/
					//Exceptioncode:
					//ExceptionFlags:The exception flags.value:0 indicating a continuable exception;or EXCEPTION_NONCONTINUABLE, indicating a noncontinuable exception.
					//ExceptionAddress:The address where the exception occurred.
					//NumberParameters:The number of parameters associated with the exception
					//ExceptionInformation is an array,the first number's value indicates the error type.
					//If this value is zero, the thread attempted to read the inaccessible data.
					//If this value is 1, the thread attempted to write to an inaccessible address.

					//printf("ExceptionCode:%lu ExceptionFlags:%lu ExceptionAddress:%p NumberParameters:%lu ExceptionInformation:%lu\n", DebugEv->u.Exception.ExceptionRecord.ExceptionCode, DebugEv->u.Exception.ExceptionRecord.ExceptionFlags, DebugEv->u.Exception.ExceptionRecord.ExceptionAddress, DebugEv->u.Exception.ExceptionRecord.NumberParameters, DebugEv->u.Exception.ExceptionRecord.ExceptionInformation[0]);
					//cout << DebugEv->u.Exception.ExceptionRecord.ExceptionFlags;

					break;

				case EXCEPTION_BREAKPOINT:
					// First chance: Display the current 
					// instruction and register values. 
					//printf("EXCEPTION_BREAKPOINT\n");

					break;

				case EXCEPTION_DATATYPE_MISALIGNMENT:
					// First chance: Pass this on to the system. 
					// Last chance: Display an appropriate error. 
					break;

				case EXCEPTION_SINGLE_STEP:
					// First chance: Update the display of the 
					// current instruction and register values. 
					single = 1;
					step_through(context);
					break;

				case DBG_CONTROL_C:
					// First chance: Pass this on to the system. 
					// Last chance: Display an appropriate error. 
					break;

				default:
					// Handle other exceptions. 
					break;
				}

				break;

			case CREATE_THREAD_DEBUG_EVENT:
				single = 0;
				// As needed, examine or change the thread's registers 
				// with the GetThreadContext and SetThreadContext functions; 
				// and suspend and resume thread execution with the 
				// SuspendThread and ResumeThread functions. 

				//dwContinueStatus = OnCreateThreadDebugEvent(DebugEv);
				break;

			case CREATE_PROCESS_DEBUG_EVENT:
				single = 0;
				// As needed, examine or change the registers of the
				// process's initial thread with the GetThreadContext and
				// SetThreadContext functions; read from and write to the
				// process's virtual memory with the ReadProcessMemory and
				// WriteProcessMemory functions; and suspend and resume
				// thread execution with the SuspendThread and ResumeThread
				// functions. Be sure to close the handle to the process image
				// file with CloseHandle.

				//dwContinueStatus = OnCreateProcessDebugEvent(DebugEv);
				break;

			case EXIT_THREAD_DEBUG_EVENT:
				single = 0;
				// Display the thread's exit code. 

				//dwContinueStatus = OnExitThreadDebugEvent(DebugEv);
				break;

			case EXIT_PROCESS_DEBUG_EVENT:
				single = 0;
				// Display the process's exit code. 
				waitEvent = FALSE;
				//dwContinueStatus = OnExitProcessDebugEvent(DebugEv);
				break;

			case LOAD_DLL_DEBUG_EVENT:
				single = 0;
				// Read the debugging information included in the newly 
				// loaded DLL. Be sure to close the handle to the loaded DLL 
				// with CloseHandle.

				//dwContinueStatus = OnLoadDllDebugEvent(DebugEv);
				break;

			case UNLOAD_DLL_DEBUG_EVENT:
				single = 0;
				// Display a message that the DLL has been unloaded. 

				//dwContinueStatus = OnUnloadDllDebugEvent(DebugEv);
				break;

			case OUTPUT_DEBUG_STRING_EVENT:
				single = 0;
				// Display the output debugging string. 

				//dwContinueStatus = OnOutputDebugStringEvent(DebugEv);
				break;

			case RIP_EVENT:
				single = 0;
				//dwContinueStatus = OnRipEvent(DebugEv);
				break;
			}
			// Resume executing the thread that reported the debugging event. 
			char answer = 1;
			if (waitEvent == TRUE)
			{
				if (single == 1)
				{

					cout << "是否继续？ -y/n：";
					cin >> answer;
					single = 0;
					if (answer == 'y')
					{
						GetDebuggeeContext(&context);
						context.EFlags |= 0x100;
						SetDebuggeeContext(&context);
						ContinueDebugEvent(DebugEv->dwProcessId, DebugEv->dwThreadId, DBG_CONTINUE);
					}
					else if (answer == 'n')
					{
						cout << endl;
						cout << "调试结束！" << endl;
						break;
					}
					
				}
				else
				{
					ContinueDebugEvent(DebugEv->dwProcessId, DebugEv->dwThreadId, DBG_CONTINUE);
				}

			}
			else
			{
				break;
			}

		}
	//}
}
