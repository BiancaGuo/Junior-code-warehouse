#include<iostream>
using namespace std;

/********************************************************************************
*Course: 编译原理
*Name:   郭韵婷
*Aim：   运用编译思想进行运算器设计01版（仅实现加法与减法功能）
*Date:   2017-10-19
*********************************************************************************/
static int n=0;//定位表达式处理的位置

int funcT(char * expression)//T
{
	int len = strlen(expression);
	char num[20];//分词
	int number;
	int count = 0;
	int i;
	for (i = n; i < len; i++)
	{
		if (expression[i] >= '0'&&expression[i] <= '9')
		{
			num[count++] = expression[i];
		}
		else
		{
			num[count] = '\0';//在字符串末尾添加字符串结束符
			number = atoi(num);//字符串转换为整型
			break;
		}
	}
	n = i+1;
	return number;
}

int funcE2(int num1,char * expression)//E2
{
	int i;
	int result;
	int num2;
	int m;
	int len = strlen(expression);
	m = n;
	if (n >= len)
	{
		return num1;
	}
	else
	{
		if (expression[n-1] == '+')
		{
			num2 = funcT(expression);//T
			result = num1 + num2;
		}
		else if (expression[n - 1] == '-')
		{
			num2 = funcT(expression);//T
			result = num1 - num2;
		}
		
		return funcE2(result, expression);//E2
	}
}
void funE(char * expression)
{
	int num1 = funcT(expression);//T
	int result=funcE2(num1, expression);//E2
	cout << result << endl;
}

int main()
{
	char test[210];//获取公式,长度不超过210
	int len;
	while (cin.getline(test, 201))//获取整个表达式,输入时表达式末尾需输入等号‘=’
	{
		n = 0;
		len = strlen(test);//表达式长度
		if (len == 1 && test[0] == '0') break;//输入0时程序退出
		funE(test);//E
		
	}


	return 0;
}