# -*- coding: utf-8 -*-
import re



def findRemoteExecute(lines):
    global request_ip
    request_ip='0.0.0.0'
    global queue
    queue = {}
    global request_time
    begin=0
    for i in range(len(lines)):
        #print lines[i]
        if lines[i]=="finish here\n":
            begin=i
    #print begin
    for line_num in range(begin+1,len(lines)):
        if re.match(r'--.*-A--',lines[line_num]):
            next_line=lines[line_num+1]
            #print next_line.split()[3]
            request_time=next_line.split()[0]+next_line.split()[1]
            request_ip=next_line.split()[3]
           #print request_ip
        if re.match(r'--.*-H--',lines[line_num]):
            next_line = lines[line_num + 1]
            flag=0
            for str in next_line.split():
                if str=='"phpMyAdmin':
                    flag+=1
                if str == 'CVE-2016-5734"]':
                    flag += 1
            if flag==2:
                queue[request_time]=request_ip
    print queue
    #queue2=list(set(queue))
    return queue

if __name__ == '__main__':
    f = open("test.txt", "a+")
    lines = f.readlines()  # 读取全部内容 ，并以列表方式返回
    f.write('\n'+"finish here" + '\n')
    f.close()
    black_list=findRemoteExecute(lines)
    black_list_file = open(r'CVE-2016-5734_Black_list.txt', 'a+')
    for str in black_list:
        black_list_file.write(str + '\n')
    black_list_file.close()
