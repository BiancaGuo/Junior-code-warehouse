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
    t=`awk -F\\t '{
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
    t=`awk -F\\t '{a[$6]+=1;b+=1} END {
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
    t=`awk -F\\t '{
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
    # 没有添加更改url功能
    t=`awk -F\\t '{
            if($5=="/images/ksclogosmall.gif")
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
# host_top
ip_top
url_top
# responsecode_stat

# 没有统计URL出现的总次数
# responsecode_top

# 没有添加更改url功能
# url_host
