#include<iostream>
#include<cmath>
#include<stdio.h>
#include<algorithm>
#include<vector>
#include<fstream>
#include<iomanip>
#include<stdlib.h>
#include<string>
#include<stack>
using namespace std;
#define maxn 15
#define maxsize 50
//a+b*c-4
/*************************************************************************************
* Course: 编译原理                                                                    *
* Name:   郭韵婷                                                                      *
* Aim：   运用算符优先思想进行运算器设计03版（实现整数加、乘、求幂功能，可以添加括号）*
* Date:   2017-11-5                                                                   *
**************************************************************************************/
/*
文法：

S->#E#
E->E+T
E->E-T
E->T
T->T*F
T->T/F
T->F
F->P^F
F->P
P->(E)
P->i

*/

typedef struct {
	char self;
	vector<char> firstvt;
	int fflag = 0;
	vector<char> lastvt;
	int lflag = 0;
}NTsymbol;//非终结符及其对应的firstvt集和lastvt集

string s[maxn];//存储输入的文法
int scount;    //输入的文法条目数
int n;         //扫描的位置
int len;       //非终结符个数（不包括E')
NTsymbol ntsymbols[maxn];  //非终结符
int table[maxn][maxn] = { 0 }; //存储算符优先表

bool is_digital(char a)//判断是否是数字
{
	if (a >= '0'&&a <= '9')
	{
		return true;
	}
	else
		return false;
}
bool is_terminal_symbol(char a)//判断是否是终结符
{
	if (a == '#' || a == '+' || a == '-' || a == '*' || a == '/' || a=='^'|| a == 'i' || a == '(' || a == ')')
	{
		return true;
	}
	else
	{
		return false;
	}
	
}



int index_func(char c)//返回输入终结符在ntsymbols[]对应的数字下标
{
	for (int i = 0; i < len; i++)
	{
		if (c == ntsymbols[i].self)
			return i;
	}
}

int chartoint(char c)//将非终结符转化为数字下标
{
	int temp;
	if (is_digital(c))
	{
		temp = 7;
		return temp;
	}
	switch (c)
	{
	case '+':temp = 0;
		break;
	case '-':temp = 1;
		break;
	case '*':temp = 2;
		break;
	case '/':temp = 3;
		break;
	case '^':temp = 4;
		break;
	case '(':temp = 5;
		break;
	case ')':temp = 6;
		break;
	case 'i':temp = 7;
		break;
	case '#':temp = 8;
		break;
	default:temp = 9;
		break;
	}
	return temp;
}

void read_grammer()//读入文法
{
	string stemp;
	int i = 0;
	while (cin >> stemp&&stemp != "&")
	{
		s[i++] = stemp;
	}
	scount = i;

}
void firstvt_func()//求firstvt集
{
	int flag = 0;
	char name[maxn];

	//将不重复的非终结符赋值给ntsymbols[].self
	for (int i = 0; i < scount; i++)
	{
		name[i] = s[i][0];
	}
	sort(name, name + scount);
	len = unique(name, name + scount) - name;//关键的一句 
	int temp = len;
	for (int i = 0; i < len; i++)
	{
		ntsymbols[i].self = name[i];
		ntsymbols[i].fflag = 0;
	}

	//若读入的该句文法中有终结符，则将第一个读到的终结符存入左侧非终结符的firstvt集中
	for (int i = 0; i < scount; i++)
	{
		int index = index_func(s[i][0]);
		for (int j = 0; j < s[i].length(); j++)
		{
			if (is_terminal_symbol(s[i][j])&& s[i][j+1]!='>')
			{
				ntsymbols[index].firstvt.push_back(s[i][j]);
				break;
			}
		}
	}
	//若读入的文法为E->T类型，则将T的firstvt集加入E的firstvt集中，注意顺序（先存文法中无非终结符的）
	for (int i = 0; i < scount; i++)
	{
		if (s[i].size() == 4 && !is_terminal_symbol(s[i][3]))
		{
			int index = index_func(s[i][0]);
			int index2 = index_func(s[i][3]);
			ntsymbols[index].fflag++;
			flag++;
		}
	}
	while (flag != 0)
	{
		for (int i = 0; i < scount; i++)
		{
			if (s[i].size() == 4 && !is_terminal_symbol(s[i][3]))
			{
				int index = index_func(s[i][0]);
				int index2 = index_func(s[i][3]);
				if (ntsymbols[index2].fflag == 0)
				{
					for (int j = 0; j < ntsymbols[index2].firstvt.size(); j++)
					{
						ntsymbols[index].firstvt.push_back(ntsymbols[index2].firstvt[j]);
						
					}
					ntsymbols[index].fflag--;
					flag--;
					s[i] += '$';
				}


			}
		}
	}
	

  //for test: 输出Firstvt
	for (int i = 0; i < len; i++)
	{
		cout << "First(" << ntsymbols[i].self << ")={";
		for (int j = 0; j < ntsymbols[i].firstvt.size(); j++)
		{
			cout << ntsymbols[i].firstvt[j] << " ";
		}
		cout << endl;
	}
 
}

void lastvt_func()//求lastvt集,与求firstvt集思路相同，只不过每句文法从后向前扫描
{
	int flag = 0;
	
	for (int i = 0; i < len; i++)
	{
		ntsymbols[i].lflag = 0;
	}


	for (int i = 0; i < scount; i++)
	{
		int index = index_func(s[i][0]);
		for (int j = s[i].length()-1; j >= 0; j--)
		{
			if (is_terminal_symbol(s[i][j]) && s[i][j + 1] != '>')
			{
				ntsymbols[index].lastvt.push_back(s[i][j]);
				break;
			}
		}
	}
	for (int i = 0; i < scount; i++)
	{
		if (s[i].size() == 5 && s[i][4] == '$')
		{
			int index = index_func(s[i][0]);
			int index2 = index_func(s[i][3]);
			ntsymbols[index].lflag++;
			flag++;
		}
	}

	while (flag != 0)
	{
		for (int i = 0; i < scount; i++)
		{
			if (s[i].size() == 5 && s[i][4]=='$')
			{
				int index = index_func(s[i][0]);
				int index2 = index_func(s[i][3]);
				if (ntsymbols[index2].lflag == 0)
				{
					for (int j = 0; j < ntsymbols[index2].lastvt.size(); j++)
					{
						ntsymbols[index].lastvt.push_back(ntsymbols[index2].lastvt[j]);

					}
					ntsymbols[index].lflag--;
					flag--;
					s[i] = "";
				}


			}
		}
	}


	//for test: 输出lastvt
	for (int i = 0; i < len; i++)
	{
		cout << "Last(" << ntsymbols[i].self << ")={";
		for (int j = 0; j < ntsymbols[i].lastvt.size(); j++)
		{
			cout << ntsymbols[i].lastvt[j] << " ";
		}
		cout << endl;
	}
	
	
}

void make_func_table()//根据firsvt、lastvt集构造算符优先表
{
	for (int i = 0; i < scount; i++)
	{
		if (s[i] != "")
		{
			for (int j = 0; j < s[i].size(); j++)
			{
				//小于关系aB
				if (is_terminal_symbol(s[i][j]) && !is_terminal_symbol(s[i][j+1]))
				{
					int x = chartoint(s[i][j]);
					int index = index_func(s[i][j+1]);
					for (int k = 0; k < ntsymbols[index].firstvt.size(); k++)
					{
						int y = chartoint(ntsymbols[index].firstvt[k]);
						table[x][y] = -1;

					}
				}
				//大于关系Ba
				if (!is_terminal_symbol(s[i][j]) && is_terminal_symbol(s[i][j+1])&& (is_terminal_symbol(s[i][j+2])!='>'))
				{
					int y = chartoint(s[i][j+1]);
					int index = index_func(s[i][j]);
					for (int k = 0; k < ntsymbols[index].lastvt.size(); k++)
					{
						int x = chartoint(ntsymbols[index].lastvt[k]);
						table[x][y] = 1;

					}
				}
			}
		}
		
	}
	table[8][8] = 2;
	table[5][6] = 2;

	for (int i = 0; i < 9; i++)
	{
		for (int j = 0; j < 9; j++)
		{
			cout << table[i][j] << " ";
		}
		cout << endl;
	}

}

int sign;       //输入表达式是否合法（#结尾）
int current_pos;//当前扫描到的表达式的位置
stack<char>optr;//操作符栈
stack<int>opnd; //操作数栈
char token[50]; //输入以#结尾
int slen = 0;   //输入表达式的长度

int calculate(int num1, int num2, char opera)//计算表达式，返回运算结果
{
	if (opera == '+')
	{
		return num2 + num1;
	}
	else if (opera == '-')
	{
		return num2 - num1;
	}
	else if (opera == '*')
	{
		return num2 * num1;
	}
	else if (opera == '/')
	{
		return num2 / num1;
	}
	else if (opera == '^')
	{
		return pow(num2 , num1);//右结合
	}
}



int lexer()//返回操作数
{
	
	char num[20];//分词
	int number;
	int count = 0;
	int j;
	for (j = current_pos; j < slen+1; j++)
	{
		if (token[j] >= '0'&&token[j] <= '9')
		{
			num[count++] = token[j];
		}
		else
		{
			num[count] = '\0';//在字符串末尾添加字符串结束符
			number = atoi(num);//字符串转换为整型
			break;
		}
	}
	current_pos = j;//移动扫描位置
	return number;
}


void precedence()//扫描表达式，根据算符优先表对操作数栈和操作符栈进行运算操作
{
	int b = chartoint(token[current_pos]);
	if (b != 9)
	{
		optr.push('#');
		opnd.push('#');
		while (token[current_pos] != '#')
		{
			slen++;//计算表达式长度（不包括#）
			current_pos++;
		}
		current_pos = 0;
		while (token[current_pos] != '#')
		{
			int a = chartoint(optr.top());
			int b = chartoint(token[current_pos]);
			
			if (b == 9)
			{
				cout << "分析失败" << endl;
				exit(0);
			}
			else if (table[a][b] == 1)//a>b
			{
				int num1 = opnd.top();//弹出操作数
				opnd.pop();
				int num2 = opnd.top();//弹出操作数
				opnd.pop();
				char opera = optr.top();//弹出操作符
				optr.pop();
				int result = calculate(num1, num2, opera);//计算
				opnd.push(result);
				if (token[current_pos] != ')')
				{
					optr.push(token[current_pos]);
				}
				else
				{
					optr.pop();
				}
				current_pos++;
			}
			else if (table[a][b] == -1)//a<b
			{
				if (is_digital(token[current_pos]))//是数字则存入操作数栈
				{
					char temp = token[current_pos];
					int num = lexer();
					opnd.push(num);
				}

				else//是算符则进入操作符栈
				{
					char temp = token[current_pos];
					optr.push(token[current_pos]);
					current_pos++;
				}
			}
		}
		
		while (optr.top() != '#')//计算栈中剩余表达式
		{
			
			int num1 = opnd.top();//弹出操作数
			opnd.pop();
			int num2 = opnd.top();//弹出操作数
			opnd.pop();
			char opera = optr.top();
			optr.pop();
			int result = calculate(num1, num2, opera);
			opnd.push(result);
				
		}
		
	}
	else
	{
		sign = 0;//表达式不合法
	}
		
}

int main()
{ 
	read_grammer();//读入文法
	firstvt_func();//求firstvt集
	lastvt_func();//求lastvt集
	make_func_table();//形成算符优先关系表
	sign = 1;//文法是否合规
	current_pos = 0;//表达式当前扫描位置
	while (cin >> token)//输入表达式计算
	{
		while (!opnd.empty())//清空操作数栈
		{
			opnd.pop();
		}
		while (!optr.empty())//清空操作符栈
		{
			optr.pop();
		}
		precedence();//按照算符优先表计算表达式
		cout << "result=" << opnd.top() << endl<<endl;//输出计算结果
		if (sign == 1)
			cout << "分析成功" << endl;
		else
			cout << "分析失败" << endl;
	}
	return 0;
}


