#include<string>
#include<iostream>
#include<stack>
#include<iomanip>
using namespace std;

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
	if (a == '#' || a == '+' || a == '-' || a == '*' || a == '/' || a == '^' || a == 'i' || a == '(' || a == ')')
	{
		return true;
	}
	else
	{
		return false;
	}

}


int chartoint(char c)//将非终结符转化为数字下标
{
	int temp;
	if (is_digital(c))
	{
		temp = 4;
		return temp;
	}
	switch (c)
	{
	case '+':temp = 0;
		break;
	case '*':temp = 1;
		break;
	case '(':temp = 2;
		break;
	case ')':temp = 3;
		break;
	case 'i':temp = 4;
		break;
	case '#':temp = 5;
		break;
	default:temp = 6;
		break;
	}
	return temp;
}
//LR分析表
//S移进、r归约
string LR_table[11][6] = { 
	{"&","&","S2","&","S3","&" },
	{ "S4","S5","&","&","&","acc" },
	{ "&","&","S2","&","S3","&" },
	{ "r4","r4","&","r4","&","r4" },
	{ "&","&","S2","&","S3","&" },
	{ "&","&","S2","&","S3","&" },
	{ "S4","S5","&","S9","&","&" },
	{ "r1","S5","&","r1","&","r1" },
	{ "r2","r2","&","r2","&","r2" },
	{ "r3","r3","&","r3","&","r3" },
	{ "&","&","&","&","&","&" }
};

int E[] = { 1,-1,6,-1,7,8,-1,-1,-1,-1 };
int pop_num[] = { 3,3,3,1 };

stack<int>statue;//状态栈
stack<char>symbol;//符号栈
string token; //输入表达式，以#结尾
int slen = 0;   //输入表达式的长度
int sign = 1;
int position = 0;

char num[20];//分词
int number;
int counts;

void lexer()//词法分析
{
	int len = token.length();
	counts = 0;
	int j;
	for (j = position; j < len; j++)
	{
		if (token[j] >= '0' && token[j] <= '9')
		{
			num[counts++] = token[j];
		}
		else
		{
			//num[count] = '\0';//在字符串末尾添加字符串结束符
			//number = atoi(num);//字符串转换为整型
			break;
		}
	}
	position = j;


}


void reduction(char proc)
{
	
	if (proc == '4')
	{
		num[counts] = '\0';//在字符串末尾添加字符串结束符
		number = atoi(num);//字符串转换为整型
		symbol.push(number+'0');
	}
	else
	{

		if (proc == '1')
		{
			int a = symbol.top() - '0';
			symbol.pop();
			char opera = symbol.top();
			symbol.pop();
			int b = symbol.top() - '0';
			symbol.pop();
			symbol.push(a + b + '0');
		}
		else if (proc == '2')
		{
			int a = symbol.top() - '0';
			symbol.pop();
			char opera = symbol.top();
			symbol.pop();
			int b = symbol.top() - '0';
			symbol.pop();
			symbol.push(a * b + '0');
		}
		else if (proc == '3')
		{
			char r = symbol.top();
			symbol.pop();
			char re = symbol.top();
			symbol.pop();
			char l = symbol.top();
			symbol.pop();
			symbol.push(re);
		}
	}
	
}

void LR_calculate()
{  
	int step = 1;
	int top = -1;

	int a = 10;
	int b = 0;
	int c = 0;


	//cout << token << endl;
	/*
	cout << "------------------------------------------------------------------------------------------" << endl;
	cout << "|    步骤    |    状态栈    |    符号栈    |    输入串    |   Action      |     GOTO     |" << endl;
	cout << "------------------------------------------------------------------------------------------" << endl;
	*/
	while (LR_table[a][b]!= "acc")
	{
		
		cout << " (" << step << ")"<<"   ";//步骤
		stack<int>statue2 = statue;//状态栈
		stack<char>symbol2 = symbol;//符号栈
	
		while (!statue2.empty())//状态栈
		{
			cout << statue2.top();
			statue2.pop();
		}
		cout << "     ";
		
		while (!symbol2.empty())//符号栈
		{
			cout << symbol2.top();
			symbol2.pop();
		}
		cout << "     ";
		for (int i = position; i < token.length(); i++)//输入串
		{
			cout << token[i];
		}
		cout << "     ";

		a = statue.top();
		b = chartoint(token[position]);
		c = symbol.top();
		if (LR_table[a][b][0]=='S')//移进
		{
			if (is_digital(token[position]))
			{
				lexer();
				statue.push(LR_table[a][b][1] - '0');
			}
			else
			{
				statue.push(LR_table[a][b][1] - '0');
				symbol.push(token[position]);
				position++;
			}
			

		}
		else if (LR_table[a][b][0] == 'r')//归约
		{
			int num = pop_num[(LR_table[a][b][1]-'0') - 1];

			for (int i = 0; i < num; i++)
			{
				statue.pop();
				//symbol.pop();
			}
			top = statue.top();
			statue.push(E[top]);
			//symbol.push('E');
			reduction(LR_table[a][b][1]);
		}
		else if (LR_table[a][b][0] == 'a')
		{

		}
		else 
		{
			sign = 0;
			break;
		}

		cout << LR_table[a][b]<<"     ";//Action

		if (top != -1)
			cout << E[top];//Goto

		step++;
		top = -1;
		cout << endl;
	}


}

int main()
{

	while (cin >> token)//输入表达式计算
	{
		while (!statue.empty())
		{
			statue.pop();
		}
		while (!symbol.empty())//清空操作符栈
		{
			symbol.pop();
		}
		
		position = 0;
		token += "#";
		symbol.push('#');
		statue.push(0);
		LR_calculate();//计算表达式
		cout << endl;
		cout << "result=" << symbol.top()-'0' << endl << endl;//输出计算结果
		if (sign == 1)
			cout << endl << "分析成功" << endl << endl;
		else
			cout << endl << "分析失败" << endl << endl;
	}

	return 0;
}