#include<stdio.h>
#include<iostream>
#include<string>
#include<Windows.h>
#include <conio.h>  
#include <tchar.h>  

using namespace std;

#define BUF_SIZE 256  

int main()
{
	HANDLE hMapFile;
	LPCTSTR pBuf;
	TCHAR szName[] = _T("Operating System");
	hMapFile = OpenFileMapping(FILE_MAP_READ, FALSE, szName);
	if (hMapFile == NULL) 
	{
		_tprintf(TEXT("Could not open file mapping object (%d).\n"), GetLastError());
	}

	
	pBuf = (LPTSTR)MapViewOfFile(hMapFile, FILE_MAP_READ, 0, 0, BUF_SIZE);
	if (pBuf == NULL)
	{
		_tprintf(TEXT("Could not map view of file (%d).\n"), GetLastError());
		CloseHandle(hMapFile);
	}

	while (1)
	{
		wcout << pBuf << endl;
	}
	

	_getch();
	UnmapViewOfFile(pBuf);
	CloseHandle(hMapFile);

	system("pause");
	return 0;
}