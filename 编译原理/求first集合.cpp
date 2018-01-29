#include<iostream>
#include<string>
#include<algorithm>
#include<stack>
#include<stdio.h>
#include<stdlib.h>
# include <string.h>  
#include<vector>
using namespace std;
/********************************************************************************
*Course: 编译原理
*Name:   郭韵婷
*Aim：   求first集
*Date:   2017-10-27
*********************************************************************************/

//空：&
//编译原理：求first集
/*基本思路：
1、对于终结符而言，FIRST集中的元素只有它本身
2、对于非终结符而言，如果开始符是终结符或者空符号串ε，则加入其FIRST集中；
若开始符是非终结符，则要加入它的不含ε的FIRST集，并考虑其为ε时的情况。

input:
S->AB
S->bC
A->&
A->b
B->&
B->aD
C->AD
C->b
D->aS
D->c

S->bC
S->AB
A->&
A->b
B->&
B->aD
C->b
C->AD
D->aS
D->c

S:AB,b
A:b,&
B:a,&
C:AD,b
D:a,c

output:
FIRST(A)=ε,b
FIRST(B)=a,ε
FIRST(S)=b,a,ε
FIRST(D)=a,c
FIRST(C)=b,a,c

*/

#define maxn 100
typedef struct {
	char name;//字母名称
	vector<string>first;//first集合
	int flag;//vector中有多少个项存在非终结符
	int plain;//是否存在空集
}First;

//求first集合
void firstFunc(First*ps,int count)
{
	int sum = 0;
	int position;
	int flag = 0;
	for (int i = 0; i < count; i++)
	{
		if (ps[i].flag >0)//计算有多少个字母的first集合中存在非终结符
			sum++;
		//cout << ps[i].name << endl;
	}
	while (sum > 0)
	{
		for (int i = 0; i < count; i++)//遍历所有First
		{
			if (ps[i].flag > 0)//当该First的first集里还有非终结符时继续执行
			{
				int len = ps[i].first.size();
				for (int j = 0; j < len; j++)//遍历first集中所有元素
				{
					
					//int t1 = ps[i].first.size();//test//////////////////////////////////////////////////
					//if (ps[i].first[0] == "")
						//break;

					const char *pp = (ps[i].first[j]).c_str();
					if( strlen(pp) > 1)//first集中的该元素存在非终结符
					{
						//int t2 = ps[i].first[0].size();/////////////////////////////////////////////////
						for (int k = 0; k < ps[i].first[j].size(); k++)//对由存在非终结符的元素单个字母遍历
						{
							if (ps[i].first[j][k] >= 'A'&&ps[i].first[j][k] <= 'Z')//当该字母也是非终结符时
							{
								for (int s = 0; s < count; s++)
								{
									if (ps[s].name == ps[i].first[j][k])
									{
										for (int v = 0; v < ps[s].first.size
										(); v++)
										{
											if( k == ps[i].first[j].size()-1)//若该非终结符是当前元素的最后一个字母，将该字母的first集加入当前正在遍历的first集中
												ps[i].first.push_back(ps[s].first[v]);
											else
											{
												string temp = { '&',0 };
												if (ps[s].first[v] != temp)//若该非终结符不是当前元素的最后一个字母，将该字母的除&以外的first集加入当前正在遍历的first集中
												{
													ps[i].first.push_back(ps[s].first[v]);
												}
													
											}
										}
										if (ps[s].flag > 0)
											ps[i].flag += ps[s].flag;//刷新当前遍历的first集中存在非终结符项的个数
										if (ps[s].plain == 0)//不存在空
										{
											flag = 0;
										}
										else
										{
											flag = 1;
											ps[i].plain = 1;
										}
										break;
									}
								}
								if (flag == 0)//不存在空则不用再向后扫描
									break;
							}
							else
							{
								ps[i].first.push_back({ ps[i].first[j][k],0 });//类似ABa，遍历到此时，将a加入first集
							}


						}
						ps[i].first[j]="";//用“”替代first集中已经被其他非终结符的first集替代的项
						ps[i].flag -= 1;
					}

				}
				if (ps[i].flag == 0)
					sum--;
				//int t3 = sum;
			}

		}

	}
	

}
int main()
{
	First p[maxn];
	string exp;
	int count=0;
	int n;
	//string temp = {'a',0 };
	//const char *pp = temp.c_str();;
	//cout << strlen(pp);
	for (int i = 0; i < maxn; i++)
	{
		p[i].flag = 0;
		p[i].plain = 0;
	}
		
	while (cin >> exp&&exp!="#")
	{
		
		n = -1;
		for (int i = 0; i < count; i++)
		{
			if (p[i].name == exp[0])
			{
				n = i;
			}
		}
		if (n == -1)
		{
			n = count;
			p[n].name = exp[0];
			count++;
		}
		int j = 0;
		for (int i = 1; i < exp.length(); i++)
		{
			if (exp[i] == '>')
			{
				if (exp[i + 1] >= 'a'&&exp[i + 1] <= 'z')
				{
					string temp = { exp[i + 1],0 };
					p[n].first.push_back(temp);
				}
				else if (exp[i + 1] == '&')
				{
					p[n].plain = 1;//存在空集
					string temp = { exp[i + 1],0 };
					p[n].first.push_back(temp);
				}
				else
				{
					string s="";
					int k;
					for (k = i + 1; k < exp.length(); k++)
					{
						if (exp[k] >= 'A'&&exp[k] <= 'Z')
						{
							s += exp[k];

						}
						else
						{
							break;
						}
					}
					if (k < exp.length())
					{
						s += exp[k];
						p[n].first.push_back(s);
						p[n].flag += 1;
					}
					if (k == exp.length())
					{
						p[n].first.push_back(s);
						p[n].flag += 1;
					}	
				}
				break;
			}
			
		}
	}
	
	firstFunc(p,count);

	//输出
	for (int i = 0; i < count; i++)
	{
		int j;
		sort(p[i].first.begin(), p[i].first.end());
		p[i].first.erase(unique(p[i].first.begin(), p[i].first.end()), p[i].first.end());//去重
		cout << "FIRST(" << p[i].name << "):";
		for (j = 0; j < p[i].first.size(); j++)
			if(p[i].first[j]!="")
				cout << p[i].first[j];

		cout << endl;

	}

	system("pause");
	return 0;
}
