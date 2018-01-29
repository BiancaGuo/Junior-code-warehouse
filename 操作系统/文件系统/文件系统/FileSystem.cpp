/*
1．利用Windows 提供的API进行文件的创建、打开、读、写以及删除等操作。
2．利用文件映射实现数据通信（编制控制台程序，实现两个控制台程序同步显示录入的信息）。
*/
//优点：不必创建或打开一个专门的磁盘文件
//将磁盘上指定的数据文件作为虚拟内存
#include<stdio.h>
#include<iostream>
#include<string>
#include<Windows.h>
#include <conio.h>  
#include <tchar.h>  
#define BUF_SIZE 256
using namespace std;


LPCWSTR fname = L"TEXT.txt";
void file_operate()
{
	
	//setlocale(LC_ALL, "chs");
	BOOL ret;
	LPCWSTR filePath = fname;//待创建文件名
	DWORD dwDesiredAccess = GENERIC_READ | GENERIC_WRITE;//对该文件的访问模式（读写）
	DWORD dwShareMode = FILE_SHARE_READ;//共享模式，读共享
	LPSECURITY_ATTRIBUTES lpSecurityAttributes = NULL;
	DWORD dwCreationDisposition = OPEN_ALWAYS;//若文件不存在则创建它
	DWORD dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL; //文件属性（默认属性）
	HANDLE hTemplateFile = NULL;//扩展属性

	//文件创建和打开
	HANDLE handle = CreateFileW(filePath, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
	if (handle == NULL) 
	{
		cout << "CreateFile fail " << GetLastError() << endl;
	}
	else 
	{
		DWORD len;
		TCHAR *writeBuf = L"Hello World!";
		TCHAR readBuf[1024];
		/*
		ASCII:不加前缀（如果写入unicode字符串读出来会是乱码）
		Unicode:0xFEFF
		UTF8:0xEFBBBF
		*/
		WORD prefix = 0xFEFF;

		/*
		BOOL WriteFile(
		HANDLE  hFile,//文件句柄
		LPCVOID lpBuffer,//数据缓存区指针
		DWORD   nNumberOfBytesToWrite,//你要写的字节数
		LPDWORD lpNumberOfBytesWritten,//用于保存实际写入字节数的存储区域的指针
		LPOVERLAPPED lpOverlapped//OVERLAPPED结构体指针
		);
		return 失败返回0,成功返回非0
		*/
	
		//文件写入
		ret = WriteFile(handle, writeBuf, lstrlen(writeBuf) * sizeof(TCHAR), &len, NULL);
		if (ret == 0) 
		{
			printf("WriteFile buf fail(%ld)\n", GetLastError());
		}

		/*
		一个文件中设置当前的读取位置
		DWORD SetFilePointer(
		HANDLE hFile,               // 文件句柄
		LONG lDistanceToMove,       // 偏移量(低位)
		PLONG lpDistanceToMoveHigh, // 偏移量(高位)
		DWORD dwMoveMethod          // 基准位置FILE_BEGIN:文件开始位置 FILE_CURRENT:文件当前位置 FILE_END:文件结束位置
		);
		*/
		DWORD pos = SetFilePointer(handle, 0, 0, FILE_BEGIN);
		if (pos == HFILE_ERROR) 
		{
			printf("SetFilePointer fail(%ld)\n", GetLastError());
		}
		
		/*
		BOOL ReadFile(
		HANDLE  hFile,                  //文件的句柄
		LPVOID  lpBuffer,               //用于保存读入数据的一个缓冲区
		DWORD   nNumberOfBytesToRead,   //要读入的字节数
		LPDWORD lpNumberOfBytesRead,    //指向实际读取字节数的指针
		LPOVERLAPPED lpOverlapped       //如文件打开时指定了FILE_FLAG_OVERLAPPED，那么必须，用这个参数引用一个特殊的结构。该结构定义了一次异步读取操作。否则，应将这个参数设为NULL
		);
		*/
		//文件读取
		ret = ReadFile(handle, readBuf, 1024, &len, NULL);
		if (ret == 0) 
		{
			printf("ReadFile fail(%ld)\n", GetLastError());
		}
		else 
		{
			
			readBuf[len / sizeof(TCHAR)] = L'\0';
			printf("读出长度为：%ld, 内容为：%ls\n", len, readBuf);
		}

		CloseHandle(handle);
	}

	cout << "是否删除文件（y or n）：";
	char answer;
	cin >> answer;
	if (answer == 'y')
	{
		BOOL ret = DeleteFile(fname);
		if (ret == 0)
		{
			printf("DeleteFile fail(%d)\n", GetLastError());
		}
	}
}

TCHAR szName[] = TEXT("Operating System");


//文件映像通信
void read()
{
	HANDLE hMapFile;
	LPCTSTR pBuf;
	TCHAR szName[] = TEXT("Operating System");
	//打开一个现有的文件映射对象
	hMapFile = OpenFileMapping(
		FILE_MAP_READ, //权限
		FALSE,//句柄不被继承
		szName);//要打开的文件映射内核对象的名字。如果该名字对应的文件映射内核对象已经被打开，而且 dwDesiredAccess指定的安全权限不冲突的话，可以成功打开返回值：如果成功，则返回一个打开的文件映射句柄；失败则返回NULL，可以调用GetLastError()获取详细的错误信息；

	if (hMapFile == NULL)
	{
		_tprintf(TEXT("Could not open file mapping object (%d).\n"), GetLastError());
	}

	//将一个文件映射内核对象映射到调用进程的地址空间中，并返回映射到进程地址中的起始址
	pBuf = (LPTSTR)MapViewOfFile(hMapFile, FILE_MAP_READ, 0, 0, BUF_SIZE);
	if (pBuf == NULL)
	{
		_tprintf(TEXT("Could not map view of file (%d).\n"), GetLastError());
		CloseHandle(hMapFile);
	}

	wcout << pBuf << endl;
}
void file_image_communication()
{
	//INVALID_HANDLE_VALUE:告诉系统我们创建的文件映射对象的物理存储器不是磁盘上的文件，而是希望系统从页交换文件中调拨物理存储器。
	HANDLE hFile = CreateFileW(TEXT("TEXT.txt"), GENERIC_READ | GENERIC_WRITE,
		0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == NULL)
	{
		printf("create file error!");
	}
	HANDLE hMapFile;
	LPCTSTR pBuf;

	//创建文件映射内核对象
	hMapFile = CreateFileMapping(hFile,//指定欲在其中创建映射的一个文件句柄
		NULL,
		PAGE_READWRITE,//指定欲在其中创建映射的一个文件句柄
		0,
		BUF_SIZE,
		szName);//指定文件映射对象的名字。如存在这个名字的一个映射，函数会用flProtect权限试图去打开它。返回值：如果成功，则返回一个文件映射内核对象句柄；

	if (hMapFile == NULL)
	{
		_tprintf(TEXT("Could not create file mapping object (%d).\n"),GetLastError());
	}

	//将一个文件映射内核对象映射到调用进程的地址空间中，并返回映射到进程地址中的起始址
	pBuf = (LPTSTR)MapViewOfFile(hMapFile,
		FILE_MAP_ALL_ACCESS,
		0,
		0,
		BUF_SIZE);

	if (pBuf == NULL)
	{
		_tprintf(TEXT("Could not map view of file (%d). \n"),GetLastError());
		CloseHandle(hMapFile);
	}
	//char temp[]="";
	//cin >> temp;
	TCHAR szMsg[]=TEXT("");
	for (int i = 0; i < 5; i++)
	{
		wcin >> szMsg;
		CopyMemory((void*)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));//将信息存入文件映射内核对象
	}
	read();
	_getch();
	//在当前应用程序的内存地址空间解除对一个文件映射对象的映射。
	UnmapViewOfFile(pBuf);//不再需要把文件的数据映射到进程的地址空间时，需要调用UnmapViewOfFile来释放内存区域
	CloseHandle(hMapFile);
}


int main()
{
	file_image_communication();
	system("pause");
	return 0;
}