#include<iostream>
#include<string>
using namespace std;

/********************************************************************************
*Course: 编译原理
*Name:   郭韵婷
*Aim：   运用编译思想进行运算器设计02版（递归下降思想）
*Date:   2017-11-3
*********************************************************************************/

string s;//用户输入的表达式
int i;//目前扫描的位置
int error;//是否符合表达式文法


bool isdigit(char c)//判断是否是数字
{
	if (c >= '0'&&c <= '9')
		return true;
	else
		return false;
}



int lexer()//词法分析
{
	int len = s.length();
	char num[20];//分词
	int number;
	int count = 0;
	int j;
	for (j = i; j < len; j++)
	{
		if (s[j] >= '0'&&s[j] <= '9')
		{
			num[count++] = s[j];
		}
		else
		{
			num[count] = '\0';//在字符串末尾添加字符串结束符
			number = atoi(num);//字符串转换为整型
			break;
		}
	}
	i = j ;
	return number;
}

/*
使用的文法为：

E->TE'
E'->+TE'|空
T->FT'
T'->*FT'|空
F->i|(E)

*/
int E();
int E_();
int T();
int T_();
int F();


int main()
{
	while (cin >> s)
	{
		i = 0;//扫描位置
		error = 0;
		s += '#';//表达式结束符
		cout<< E()<<endl;
		if (s[i] == '#'&&error!=1)//扫描到末尾且表达式符合文法
			cout <<"接受！" << endl;
		s = "";
	}
	

	return 0;
}

int E()//加法计算完毕
{
	
	if (error == 0)
	{
	
		if (isdigit(s[i]) || s[i] == '('||s[i]=='#')
		{
			return T() + E_();
		}
		else
		{
			cout << "E() is error!" << endl;
			return 0;//加法返回0
		}
	}
}

int E_()
{
	if (error == 0)
	{
		char temp = s[i];
		if (s[i] == '+')
		{
			++i;	
			return T()+E_();
		}
		else if (s[i] != '#'&&s[i] != ')')
		{
			cout << "E_()拒绝！" << endl;
			error = 1;
		}
		else
		{
			return 0;//加法返回0
		}
	}
}


int T()//乘法计算完毕
{
	if (error == 0)
	{
		if (isdigit(s[i]) || s[i] == '(')
			return F()*T_();
		else
		{
			cout << "T() is error!" << endl;
			return 1;//乘法返回1
		}
	}
}

int T_()
{
	if (error == 0)
	{
		if (s[i] == '*')
		{
			++i;
			return F()*T_();
		}
		else if (s[i] != '#'&&s[i] != ')'&&s[i] != '+')
		{
			cout << "T_()拒绝！" << endl;
			error = 1;
		}
		else
		{
			return 1;//乘法返回1
		}
	}
}



int F()
{
	int temp;
	if (error == 0)
	{
		if (s[i] == '(')
		{
			++i;
			temp=E();
			if (s[i] == ')')
				++i;
			else if (s[i] == '#')
			{
				cout << "P()1拒绝！" << endl;
				error = 1;
			}
			return temp;//括号内计算
		}
		else if (isdigit(s[i]))
		{
			temp = lexer();//得到运算数
			//++i;
			return temp;
		}
		else
		{
			cout << "P()2拒绝！" << endl;
			error = 1;
		}
	}
}

