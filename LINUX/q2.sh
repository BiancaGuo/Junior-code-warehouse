#!/bin/bash

age_stat()
{
    a=$(awk -F\\t 'BEGIN{split("<20 20-30 >30",b)}{if($6<20)a[1]++;if($6>=20&&$6<=30)a[2]++;if($6>30)a[3]++}END{for(i in a)print a[i]}' ./worldcupplayerinfo.tsv)

    sum=0
    ages=($a)
    for i in $a ;do
        sum=$(($sum+$i)) 
    done

    s=("<20" "20-30" ">30")
    echo 'age\tcount\tporprotion'
    for i in `seq 0 2`;do
        age=${ages[i]}
        p=`awk 'BEGIN{printf "%.2f\n",('${age}'/'$sum')}'`
        echo ${s[i]}\\t${age}\\t${p}
    done
}
position_stat()
{
	c=`awk -F\\t '{print $5}' ./worldcupplayerinfo.tsv|sort -r|uniq -c|awk '{print $1}'`
	p=`awk -F\\t '{print $5}' ./worldcupplayerinfo.tsv|sort -r|uniq -c|awk '{print $2}'`
	sum=0
	count=($c)
	position=($p)

	for i in $c ;do
		sum=$(($sum+$i)) 
	done
    n=${#count[@]}
    echo 'Position\tcount\tporprotion'
    for((i=0;i<n;i++));  
    do   
        cc=${count[i]}
        p=`awk 'BEGIN{printf "%.2f\n",('${cc}'/'$sum')}'`
        echo ${position[i]}\\t${cc}\\t${p}        
    done  
}
young_stat()
{
    echo `awk 'BEGIN {max = 0} {if ($6>max) max=$6 fi} END {print "年龄最大的是",$9,"年纪是", max}' ./worldcupplayerinfo.tsv`
    echo `awk 'BEGIN {min = 1999999} {if ($6<min) min=$6 fi} END {print "年龄最小的是",$9,"年纪是", min}' ./worldcupplayerinfo.tsv`

}
name_stat()
{
    echo `awk 'BEGIN {max = 0} {if (length($9)>max) max=length($9) fi} END {print "名字最长的是",$9}' ./worldcupplayerinfo.tsv`
    echo `awk 'BEGIN {min = 1999999} {if (length($9)<min) min=$9 fi} END {print "名字最短的是",$9}' ./worldcupplayerinfo.tsv`

}
name_stat
young_stat
age_stat
position_stat


