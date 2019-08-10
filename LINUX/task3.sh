#!/bin/bash

host_top()
{
    # 统计访问来源主机TOP 100和分别对应出现的总次数
    t=`awk '{a[$1]+=1;} END {for(i in a){print a[i],i;}}'  ./web_log.tsv | sort -t " " -k 1 -n -r | head -n 100`
    echo "$t"
}


ip_top()
{
    # 统计访问来源主机TOP 100 IP和分别对应出现的总次数
    t=`awk -F\\t '{print $1}' ./web_log.tsv| egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100`
    echo "$t"
}


url_top()
{
    # 统计最频繁被访问的URL TOP 100
    t=`awk -F '\t' '{
            a[$5]+=1;
        }
        END {
            for(i in a){
                b[a[i]]=i;
            }
            for(i in b){
                print i,b[i];
            }
        }'  ./web_log.tsv | sort -nr | head -n 100`
    echo "$t"
}


responsecode_stat()
{
    # 统计不同响应状态码的出现次数和对应百分比
    t=`awk -F '\t' '{a[$6]+=1;b+=1} END {
        for(i in a)
        {
            print i,a[i],a[i]/b;
        }
    }'  ./web_log.tsv`
    echo "$t"
}

responsecode_top()
{
    # 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
    t=`awk -F '\t' '{
            if($6>=400&&$6<500)
            {
                above400[$6]++;
            }
        } 
    END {
        for(i in above400)
        {
            print above400[i],i;
        }
    }'  ./web_log.tsv `
    echo "$t"
}

url_host()
{
    # 没有添加更改url功能 /images/ksclogosmall.gif
    t=`awk -F '\t' '{
            if($5=="'$1'")
            {
                count[$1]++;
            }
        } 
    END {
        for(i in count)
        {
            print count[i],i;
        }
    }'  ./web_log.tsv | sort -nr | head -n 100`
    echo "$t"
    # "给定URL输出TOP 100访问来源主机"

}


useage()
{
	echo "Usage: bash q3.sh [OPTION]"
	echo "-a				show TOP 100 host and count"
	echo "-b 				show TOP 100 IP and count"
	echo "-c 				show TOP 100 frequency url and count"
	echo "-d 				show responsecode and count and porprotion"
	echo "-e 				show TOP 10 4XX responsecode  url and count"
	echo "-f [url]			show TOP 100 given url of host and count"	
	exit 0
}

while getopts 'f:abcdeh' OPT; do
    case $OPT in
        h)
            useage;;
        a)
            host_top;;
        b)
            ip_top;;
        c)
            url_top;;
        d)
            responsecode_stat;;
        e)
            responsecode_top;;
        f)
            url_host $OPTARG;;
    esac
done