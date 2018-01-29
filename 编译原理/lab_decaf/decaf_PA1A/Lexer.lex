%{
	/*直接插到生成程序中*/
	#include "decaf.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include "include/ASTtree.h"
	#include "include/SymbolTable.h"
	#include "include/SymbolTree.h"
	/*全局变量*/
	void yyerror(char *);
	char *str;
%}
identifier [A-Za-z][A-Za-z_0-9]*
space [ \n\t]+
integer [1-9][0-9]*
dex [0][Xx]([0-9A-Fa-f]+)
string \"([^\"]*)\"
operater \+|\-|\*|\/|%|<|>|!|=
separator ;|,|\.|\[|\]|\(|\)|\{|\}
/*注释*/
annotation \/\/([^\n]*)\n|\/\*([^\/\*]*)\*\/   
%%
%union {
int intValue;
char *stringValue;
struct Node *node; /* 结点地址 */
};
bool {ECHO; return MYBOOL;}
break {ECHO; return MYBREAK;}
class {ECHO; return MYCLASS;}
else {ECHO; return MYELSE;}
extends {ECHO; return MYEXTENDS;}
for {ECHO; return MYFOR;}
if {ECHO; return MYIF;}
int {ECHO; return MYINT;}
new {ECHO; return MYNEW;}
null {ECHO; return MYNULL;}
return {ECHO; return MYRETURN;}
string {ECHO; return MYSTRING;}
this {ECHO; return MYTHIS;}
void {ECHO; return MYVOID;}
while {ECHO; return MYWHILE;}
static {ECHO; return MYSTATIC;}
Print {ECHO; return MYPRINT;}
ReadInteger {ECHO; return MYREADINTEGER;}
ReadLine {ECHO; return MYREADLINE;}
instanceof {ECHO; return MYINSTANCEOF;}
true {ECHO; return MYTRUE;}
false {ECHO; return MYFALSE;}
\>\= {ECHO; return MYHET;}
\<\= {ECHO; return MYLET;}
\=\= {ECHO; return MYEQU;}
\!\= {ECHO; return MYUEQU;}
\&\& {ECHO; return MYAND;}
\|\| {ECHO; return MYOR;}
{annotation} {}

/*yytext变量：指向当前正被某规则匹配的字符串，yyleng：yytext字符串长度*/
{string} {yylval.stringValue = (char *)malloc(sizeof(yytext)+1); strcpy(yylval.stringValue, yytext); ECHO; return MYSTRING2;}
{identifier} {yylval.stringValue = (char *)malloc(sizeof(yytext)+1); strcpy(yylval.stringValue, yytext); ECHO; return MYIDENTIFIER;}
{space} {ECHO;}
{integer} {ECHO; yylval.intValue = atoi(yytext); return MYINTEGER;}
{dex} {ECHO; yylval.intValue = strtol(yytext, &str, 16); return MYDEX;}
{operater} {ECHO; return *yytext;}
{separator} {ECHO; return *yytext;}
%%

/*遇到文件结尾词法分析程序自动调用yywrap()来确定下一步做什么，返回0继续扫描，返回1处理结束，lex库中标准版本默认返回1，可根据需要重写*/
int yywrap()
{
	return 1;
}