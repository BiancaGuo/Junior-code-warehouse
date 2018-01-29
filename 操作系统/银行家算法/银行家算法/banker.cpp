#include<stdio.h>
#include<iostream>
#include<iomanip>
using namespace std;
#define maxsize 1000

int request[maxsize];//请求资源
int allocation[maxsize][maxsize];//分配矩阵
int MAX[maxsize][maxsize];//最大需求矩阵
int available[maxsize];//可利用资源向量
int need[maxsize][maxsize];//需求矩阵


//循环使用
int request2[maxsize];
int allocation2[maxsize][maxsize];
int allocation3[maxsize][maxsize];
int available2[maxsize];
int available3[maxsize];
int need2[maxsize][maxsize];
int need3[maxsize][maxsize];
int N;//进程数
int M;//资源数


void destroy(int p)
{
	for (int j = 0; j < M; j++)
	{
			available2[j] += allocation2[p][j];
			need2[p][j] = 10000;
	}
}


int main()
{
	while (1)
	{
		cout << "请输入进程数和资源种类数：" << endl << endl;
		cout << "进程数：" << endl;
		cin >> N;
		cout << "资源种类数：" << endl;
		cin >> M;

		cout << endl;
		cout << "请输入各个资源的总数： ";
		for (int i = 0; i < M; i++)
		{
			cin >> available[i];
		}

		cout << endl;
		cout << "请输入每个进程对资源的最大需求： " << endl;
		for (int i = 0; i < N; i++)
		{
			for (int j = 0; j < M; j++)
			{
				cin >> MAX[i][j];
			}
		}

		cout << endl;
		cout << "请输入每个进程已经分配的各个资源数量" << endl;
		for (int i = 0; i < N; i++)
		{
			for (int j = 0; j < M; j++)
			{
				cin >> allocation[i][j];
			}
		}

		//need
		for (int i = 0; i < N; i++)
		{
			for (int j = 0; j < M; j++)
			{
				need[i][j] = MAX[i][j] - allocation[i][j];
			}
		}

		//求available，每个资源可用总数
		for (int i = 0; i < N; i++)
		{

			for (int j = 0; j < M; j++)
			{
				available[j] = available[j] - allocation[i][j];
			}
		}

		cout << endl;


		//是否会发生死锁测试
		cout << "是否有安全分配方式测试：" << endl;
		for (int i = 0; i < M; i++)
		{
			available2[i] = available[i];
		}

		for (int i = 0; i < N; i++)
		{
			for (int j = 0; j < M; j++)
			{
				allocation2[i][j] = allocation[i][j];
				need2[i][j] = need[i][j];
			}

		}
		int process_num = N;//初始进程数
		while (process_num > 0)//当进程都可以执行完毕时退出
		{
			int flag = 0;
			//available > MAX
			for (int i = 0; i < N; i++)//循环遍历所有进程
			{
				int count = 0;
				for (int j = 0; j < M; j++)
				{
					if (available2[j] >= need2[i][j])//资源可用数>需求数，记录
					{
						count++;
					}
				}
				if (count == M)//所有资源可用数都大于该进程需求数量时进行分配
				{
					cout << "进程" << i << "满足" << endl;
					flag = 1;
					destroy(i);//执行进程并释放资源
					process_num--;
				}
			}

			if (flag == 0)//当不存在进程满足资源请求时，死锁产生
			{
				cout << "发生死锁！" << endl;
				break;
			}

		}//end while

		if (process_num == 0)//所有进程都执行完毕
		{
			cout << "死锁不会产生！" << endl;
		}

		cout << endl;




		//请求进程测试
		int proc = 0;
		cout << "请求进程测试：" << endl;//输入请求的进程号
		//初始化
		for (int i = 0; i < M; i++)
		{
			available2[i] = available[i];
			available3[i] = available[i];
		}
		for (int i = 0; i < N; i++)
		{
			for (int j = 0; j < M; j++)
			{
				allocation2[i][j] = allocation[i][j];
				allocation3[i][j] = allocation[i][j];
				need2[i][j] = need[i][j];
				need3[i][j] = need[i][j];
			}
		}
		int que[maxsize] = { 0 };//进程是否已经执行完毕，执行完毕赋值1
		while (1)//循环接收请求资源的进程信息
		{
			int temp = 0;
			cout << "输入请求进程（-1停止测试）：" << endl;
			cin >> proc;
			if (proc == -1)
				break;
			int flag = 0;
			cout << "输入请求资源数目：" << endl;
			for (int k = 0; k < M; k++)
			{
				cin >> request[k];
				//当请求的资源大于需要的资源或大于可用资源时，不能给该进程分配请求资源
				if (request[k] > need3[proc][k] || request[k] > available3[k])
				{
					cout << "请求失败！" << endl;
					temp = 1;
					break;
				}
			}
			if (temp == 1)
				continue;

			//尝试分配
			for (int k = 0; k < M; k++)
			{
				allocation2[proc][k] += request[k];//进程分配资源=已分配资源+该次请求的资源
				need2[proc][k] = need2[proc][k] - request[k];//进程所需资源=已分配资源-该次请求的资源
				available2[k] = available2[k] - request[k];//当前可用资源=可用资源-该次请求的资源
			}
			que[proc] = 1;
			destroy(proc);//程序执行结束后资源释放
			int num = 0;
			for (int i = 0; i < N; i++)//当前等待队列中的进程数
			{
				if (que[i] == 0)
					num++;
			}
			//与8中思路相同
			int process_num = num;
			while (process_num > 0)
			{
				int flag = 0;
				int i;
				int j;
				for (i = 0; i < N; i++)
				{
					if (que[i] == 0)//未分配的进程
					{
						int count = 0;
						for (j = 0; j < M; j++)
						{
							if (available2[j] >= need2[i][j])
							{
								count++;
							}
						}
						if (count == M)
						{
							cout << "进程" << i << "满足" << endl;
							flag = 1;
							destroy(i);
							process_num--;
						}
					}
				}
				if (flag == 0)
				{
					cout << "发生死锁！不能将资源分配给" << proc << endl;
					//发生死锁回收分配资源
					que[proc] = 0;
					for (int k = 0; k < M; k++)
					{
						allocation2[proc][k] -= request[k];
						need2[proc][k] = need3[proc][k];
						available2[k] = available3[k];
					}
					break;
				}
			}
			if (process_num == 0)
			{
				//不发生死锁，进行资源分配
				cout << "不会发生死锁！可以将资源分配给" << proc << endl;
				que[proc] = 1;
				for (int k = 0; k < M; k++)
				{
					available3[k] = available3[k] - request[k];
					need3[proc][k] = need3[proc][k] - request[k];
					available2[k] = available3[k];
				}
			}
			for (int i = 0; i < N; i++)
			{
				if (que[i] == 0)
				{
					for (int k = 0; k < M; k++)
					{
						need2[i][k] = need[i][k];
					}
				}
			}

		}
		return 0;
	}
}