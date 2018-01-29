#include<iostream>
#include<string>
using namespace std;

//遵照的预测分析表
  /*    id         +        *       ∧     (         )         #
  ---------------------------------------------------------- 
E | TE'                          TE'    TE' 
E'|            +E                                   &        &
T | FT'                          FT'    FT'
T'| T          &                T      T         &        &
F | PF'                          PF'    PF'
F'| &         &        *F     &      &       &      &
P | b                             ∧    (E)
-----------------------------------------------------------
*/


void E();
void E_();
void T();
void T_();
void F();
void F_();
void P();

string s;
int i;
int error;

int main()
{
	while (cin >> s)
	{
		i = 0;//扫描位置
		error = 0;
		s += '#';
		E();
		if (s[i] == '#'&&error==0)//扫描到末尾
			cout << "接受！" << endl;
		s = "";
	}
		
	return 0;
}

void E()
{
	if (error == 0)
	{
		char temp = s[i];
		T();
		E_();
	}
}

void E_()
{
	if (error == 0)
	{
		char temp = s[i];
		if (s[i] == '+')
		{
			++i;
			//T();
			E();
		}
		else if (s[i] != '#'&&s[i] != ')')
		{
			cout << "E_()拒绝！" << endl;
			error = 1;
		}
	}
}


void T()
{
	if (error == 0)
	{
		char temp = s[i];
		F();
		T_();
	}
}

void T_()
{
	if (error == 0)
	{
		char temp = s[i];
		if (s[i] == 'a' || s[i] == 'b' || s[i] == '^' || s[i] == '(')
		{
			++i;
			T();
		}
		else if (s[i] != '#'&&s[i] != ')'&&s[i]!='+')
		{
			cout << "T_()拒绝！" << endl;
			error = 1;
		}
	}
}

void F()
{
	if (error == 0)
	{
		char temp = s[i];
		P();
		F_();
	}
}

void F_()
{
	if (error == 0)
	{
		char temp = s[i];
		if (s[i] == '*')
		{
			++i;
			F();
		}
		else if (s[i] != '#'&&s[i] != '('&&s[i] != ')'&&s[i] != '^'&&s[i] != 'a'&&s[i] != 'b'&&s[i] != '+')
		{
			cout << "F_()拒绝！" << endl;
			error = 1;
		}
	}
}


void P()
{
	if (error == 0)
	{
		char temp = s[i];
	//	char t = s[i];
		if (s[i] == '(')
		{
			++i;
			E();
			if (s[i] == ')')
				++i;
			else if (s[i] == '#')
			{
				cout << "P()1拒绝！" << endl;
				error = 1;
				++i;
			}
		}
		else if (s[i] == 'a'||s[i]=='b'|| s[i] == '^')
			++i;
		else
		{
			cout << "P()2拒绝！" << endl;
			error = 1;
		}
	}
}

