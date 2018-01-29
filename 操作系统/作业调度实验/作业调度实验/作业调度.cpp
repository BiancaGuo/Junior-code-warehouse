
#include <conio.h>
#include <stdlib.h>
#include <fstream>
#include <io.h>
#include <string.h>
#include <stdio.h>
#include<iostream>
#include <time.h> 
#include<string>
#include <algorithm>

using namespace std;

typedef struct {
	float JobRun;//作业运行时刻
	float JobFinish;//作业完成时刻
	float WaitTime;//作业等待时间
	float AveRunTime;//周转时间=结束时间-提交时间
	float WeightRunTime;//带权周转时间=周转时间/服务时间
}jobtime;

struct jcb {
	int JobNum;               //作业编号
	char JobName[10];         //作业名
	char JobSubmitTime[10];   //作业到达时间（string）
	int JobSubmitTime_INT;    //作业到达时间（int）
	float RunTime;            //作业运行时间
	struct jcb* link;         //链指针，指向下一个进程
	float JobResponseRatio;   //响应比:（等待时间 + 要求服务时间） / 要求服务时间 
	jobtime wt;               //所有待输出的时间信息
};


typedef struct jcb JCB;

int convert_str_to_tm(string time)//时间转换
{
	char hour[2];
	char minute[2];
	int hour_int;
	int minute_int;
	hour[0] = time[0];
	hour[1] = time[1];
	minute[0] = time[3];
	minute[1] = time[4];
	hour_int = atoi(hour);
	minute_int = atoi(minute);
	return hour_int * 60 + minute_int;
}

JCB *JobArray;
JCB *jobarray_next = NULL;
float T = 0;

void link_list()//对作业信息依据要求进行链接排序
{
	JCB *firstPtr, *nextPtr;
	int flag = 0;
	if ((jobarray_next == NULL) || ((JobArray->JobSubmitTime_INT) < (jobarray_next->JobSubmitTime_INT)))
	{
		JobArray->link = jobarray_next;
		jobarray_next = JobArray;
		T = JobArray->JobSubmitTime_INT;//第一个作业
	}
	else
	{
		firstPtr = jobarray_next;
		nextPtr = firstPtr->link;
		while (nextPtr != NULL)//将作业插入合适的位置
		{
			if (JobArray->JobSubmitTime_INT < nextPtr->JobSubmitTime_INT)
			{
				JobArray->link = nextPtr;
				firstPtr->link = JobArray;
				nextPtr = NULL;
				flag = 1;
			}
			else
			{
				firstPtr = firstPtr->link;
				nextPtr = nextPtr->link;
			}
		}
		if (flag == 0)
			firstPtr->link = JobArray;
	}



}

void input()//读入作业信息
{
	char *file = "work.txt";
	ifstream inFile;
	inFile.open(file);
	puts("Read work File \n");
	char temp;
	while (inFile >> temp)
	{
		JobArray = new JCB[1000];//为进程创建空间
		JobArray->JobNum = temp - '0';//作业序号
		inFile >> JobArray->JobName;  //作业名称
		inFile >> JobArray->JobSubmitTime;//作业提交时间
		JobArray->JobSubmitTime_INT = convert_str_to_tm(JobArray->JobSubmitTime);//将作业提交时间转换为整数
		char temp2[5];
		inFile >> temp2;
		JobArray->RunTime = atoi(temp2);//要求服务运行时间
		JobArray->link = NULL;//下一个进程
		JobArray->JobResponseRatio = 1;
		link_list();
	}
}

int jobarray_nextCount() //就绪作业个数
{
	int count = 0;
	JCB* jobarray_next_queue = jobarray_next;
	while (jobarray_next_queue != NULL)
	{
		count++;
		jobarray_next_queue = jobarray_next_queue->link;
	}
	return count;
}

void jobRun(JCB *job)//改变T
{
	if (T >= job->JobSubmitTime_INT)//作业开始运行时间
	{
		job->wt.JobRun = T;
	}
	else//作业需等待
	{
		job->wt.JobRun = job->JobSubmitTime_INT;
	}
	job->wt.JobFinish = job->wt.JobRun + job->RunTime;//结束时间=开始时间+运行时间
	job->wt.AveRunTime = job->wt.JobFinish - job->JobSubmitTime_INT;//周转时间=结束时间-提交时间
	job->wt.WeightRunTime = job->wt.AveRunTime / job->RunTime;//带权周转时间=周转时间/服务时间
	job->wt.WaitTime = T - (job->JobSubmitTime_INT);//等待时间=当前时间-提交时间
	T = job->wt.JobFinish;//T变为该作业完成时间
}

void destroy()
{
	printf("\n %s完成.\n", JobArray->JobName);
	delete[]JobArray;
}

void display()
{
	JCB* job = JobArray;
	printf("\n 作业编号  作业名称  提交时间  要求服务运行时间  开始时间  完成时间  等待时间  周转时间\n");
	printf("   %d\t", job->JobNum);
	printf("     %s\t", job->JobName);
	printf("      %d\t  ", job->JobSubmitTime_INT);
	printf("%.2f\t", job->RunTime);
	printf("      %.2f\t ", job->wt.JobRun);
	printf("  %.2f   ", job->wt.JobFinish);
	printf(" %.2f\t", job->wt.WaitTime);
	printf(" %.2f", job->wt.AveRunTime);
	//printf(" %.2f", job->JobResponseRatio);
	printf("\n");
	job = jobarray_next;
	while (job != NULL)
	{
		job->JobResponseRatio = (job->RunTime + T - job->JobSubmitTime_INT) / job->RunTime;
		//cout << job->JobName << ":" << job->JobResponseRatio << endl;//检验响应比
		job = job->link;
	}

}

void FCFS()
{
	int len = 0;
	int count = 0;
	float sumAveRunTime = 0;
	float sumWeightRunTime = 0;
	input();//读入作业信息
	len = jobarray_nextCount();
	while ((len != 0) && (jobarray_next != NULL))//从就绪队列中取作业
	{
		count++;
		JobArray = jobarray_next;
		jobarray_next = JobArray->link;
		JobArray->link = NULL;
		jobRun(JobArray);//作业运行
		sumAveRunTime += JobArray->wt.AveRunTime;
		sumWeightRunTime += JobArray->wt.WeightRunTime;
		display();
		destroy();
	}

	printf("\n");
	printf("平均周转时间：%f\n", sumAveRunTime / count);
	printf("平均带权周转时间：%f\n", sumWeightRunTime / count);
}

void SJF()
{
	int len = 0;
	int count = 0;
	float sumAveRunTime = 0;
	float sumWeightRunTime = 0;
	input();
	len = jobarray_nextCount();
	while ((len != 0) && (jobarray_next != NULL))
	{
		count++;
		JobArray = jobarray_next;
		jobarray_next = JobArray->link;
		JobArray->link = NULL;
		jobRun(JobArray);

		sumAveRunTime += JobArray->wt.AveRunTime;
		sumWeightRunTime += JobArray->wt.WeightRunTime;
		display();
		//先按来的时间排序，再按运行时间长短
		JCB *firstPtr = NULL, *minRunTime = NULL, *nextPtr = NULL;
		int flag = 0;
		minRunTime = jobarray_next;
		if (minRunTime != NULL)
		{
			nextPtr = minRunTime->link;
			while (nextPtr != NULL)
			{
				if ((nextPtr != NULL) && (T >= nextPtr->JobSubmitTime_INT) && (minRunTime->RunTime)>(nextPtr->RunTime))//寻找已到达的作业中运行时间最短的那个
				{
					firstPtr = minRunTime;
					minRunTime = nextPtr;
					nextPtr = nextPtr->link;
					flag = 1;
				}
				else
					nextPtr = nextPtr->link;
			}

			if (flag == 1)
			{
				firstPtr->link = minRunTime->link;
				minRunTime->link = jobarray_next;
			}
			jobarray_next = minRunTime;


		}
		destroy();
	}
	printf("\n");
	printf("平均周转时间：%f\n", sumAveRunTime / count);
	printf("平均带权周转时间：%f\n", sumWeightRunTime / count);

}

void HRRN()
{
	int len = 0;
	int count = 0;
	float sumAveRunTime = 0;
	float sumWeightRunTime = 0;
	input();
	len = jobarray_nextCount();
	while ((len != 0) && (jobarray_next != NULL))
	{
		count++;
		JobArray = jobarray_next;
		jobarray_next = JobArray->link;
		JobArray->link = NULL;

		jobRun(JobArray);

		sumAveRunTime += JobArray->wt.AveRunTime;
		sumWeightRunTime += JobArray->wt.WeightRunTime;

		display();

		JCB *firstPtr = NULL, *minResponseRatio = NULL, *nextPtr = NULL;

		int flag = 0;
		minResponseRatio = jobarray_next;

		if (minResponseRatio != NULL)
		{
			nextPtr = minResponseRatio->link;
			while (nextPtr != NULL)
			{
				if ((nextPtr != NULL) && (T >= nextPtr->JobSubmitTime_INT) && (minResponseRatio->JobResponseRatio) < (nextPtr->JobResponseRatio))
				{
					firstPtr = minResponseRatio;
					while (firstPtr->link != nextPtr)
					{
						firstPtr = firstPtr->link;
					}
					firstPtr->link = nextPtr->link;
					minResponseRatio = nextPtr;
					nextPtr = nextPtr->link;
					minResponseRatio->link = jobarray_next;

				}
				else
					nextPtr = nextPtr->link;
			}
			jobarray_next = minResponseRatio;
		}
		destroy();

	}

	printf("\n");
	printf("平均周转时间：%f\n", sumAveRunTime / count);
	printf("平均带权周转时间：%f\n", sumWeightRunTime / count);
}

int main()
{
	int choice = 0;
	cout << "-------------------------------------------------------------------------------" << endl;
	cout << "******************************作业调度试验系统*********************************" << endl;

	cout << "*******************************************************************************" << endl;
	cout << "*     请输入选择的算法序号：                                                  *" << endl;
	cout << "*                          1:先来先服务                                       *" << endl;
	cout << "*                          2:短作业优先                                       *" << endl;
	cout << "*                          3:最高响应比优先                                   *" << endl;
	cout << "*                          -1:退出系统                                        *" << endl;
	cout << "*******************************************************************************" << endl;
	cout << ">>>";
	while (cin >> choice&&choice != -1)
	{
		if (choice == 1)//先来先服务:作业来了，先来先运行，后来的按到达时间的先后排在就绪队列上
		{
			FCFS();
		}
		if (choice == 2)//短作业优先:运行时间短的优先调度；如果运行时间相同则调度最先发起请求的进程。
		{
			SJF();
		}
		if (choice == 3)//最高响应比优先:优先权 = （等待时间 + 要求服务时间） / 要求服务时间 = 响应时间 / 要求服务时间
		{
			HRRN();
		}


		cout << "-------------------------------------------------------------------------------" << endl;
		cout << "******************************作业调度试验系统*********************************" << endl;

		cout << "*******************************************************************************" << endl;
		cout << "*     请输入选择的算法序号：                                                  *" << endl;
		cout << "*                          1:先来先服务                                       *" << endl;
		cout << "*                          2:短作业优先                                       *" << endl;
		cout << "*                          3:最高响应比优先                                   *" << endl;
		cout << "*                          -1:退出系统                                        *" << endl;
		cout << "*******************************************************************************" << endl;
		cout << ">>> ";
	}


	return 0;
}