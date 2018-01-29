#pragma once
#include<iostream>  
#include<Windows.h>  
#include<string>
#include<list>
#include <DbgHelp.h>
#include <sstream>
#include <vector>
#pragma comment(lib, "Dbghelp.lib")
using namespace std;


void OnCreateProcessDebugEvent(const CREATE_PROCESS_DEBUG_INFO*);
void OnThreadCreated(const CREATE_THREAD_DEBUG_INFO*);
void OnException(const EXCEPTION_DEBUG_INFO*);
void OnExitProcessDebugEvent(const EXIT_PROCESS_DEBUG_INFO*);
void OnExitThreadDebugEvent(const EXIT_THREAD_DEBUG_INFO*);
void OnOutputDebugStringEvent(const OUTPUT_DEBUG_STRING_INFO*);
void OnRipEvent(const RIP_INFO*);
void OnLoadDllDebugEvent(const LOAD_DLL_DEBUG_INFO*);
void OnUnloadDllDebugEvent(const UNLOAD_DLL_DEBUG_INFO*);
void EnterDebugLoop(const LPDEBUG_EVENT DebugEv);
HANDLE g_hProcess = NULL;
char ByteToChar(BYTE byte);
void OnShowLocalVariables();
DWORD GetSymbolAddress(PSYMBOL_INFO pSymbolInfo);
enum SymTagEnum {
	SymTagNull,
	SymTagExe,
	SymTagCompiland,
	SymTagCompilandDetails,
	SymTagCompilandEnv,
	SymTagFunction,				//函数
	SymTagBlock,
	SymTagData,					//变量
	SymTagAnnotation,
	SymTagLabel,
	SymTagPublicSymbol,
	SymTagUDT,					//用户定义类型，例如struct，class和union
	SymTagEnum,					//枚举类型
	SymTagFunctionType,			//函数类型
	SymTagPointerType,			//指针类型
	SymTagArrayType,				//数组类型
	SymTagBaseType,				//基本类型
	SymTagTypedef,				//typedef类型
	SymTagBaseClass,				//基类
	SymTagFriend,				//友元类型
	SymTagFunctionArgType,		//函数参数类型
	SymTagFuncDebugStart,
	SymTagFuncDebugEnd,
	SymTagUsingNamespace,
	SymTagVTableShape,
	SymTagVTable,
	SymTagCustom,
	SymTagThunk,
	SymTagCustomType,
	SymTagManagedType,
	SymTagDimension
};