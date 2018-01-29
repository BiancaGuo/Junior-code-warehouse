# -*-coding:utf-8-*-

import jieba
import jieba.analyse
import numpy as np
import uniout

# hash操作
def string_hash(source):
    if source == "":
        return 0
    else:
        x = ord(source[0]) << 7
        m = 1000003
        mask = 2 ** 128 - 1
        for c in source:
            x = ((x * m) ^ ord(c)) & mask
        x ^= len(source)
        if x == -1:
            x = -2
        x = bin(x).replace('0b', '').zfill(64)[-64:]
        print(source, x)  # 打印 （关键词，hash值）
        return str(x)

# 海明距离计算
def hammingDis(simhash1, simhash2):
    t1 = '0b' + simhash1
    t2 = '0b' + simhash2
    n = int(t1, 2) ^ int(t2, 2)
    i = 0
    while n:
        n &= (n - 1)
        i += 1
    return i

# 分词 权重 关键词 hash
# 测试样本
num = 0
for line in open('edu.txt').readlines():
    num += 1
    if num == 2:
        print line
        break
# line_1 = open('edu.txt').readline()  # 只读文档的第一行
# print type(line_1)  # <type 'str'>

seg = jieba.cut(line)  # 分词
jieba.analyse.set_stop_words('stopword.txt')  # 去除停用词
keyWord = jieba.analyse.extract_tags(
    '|'.join(seg), topK=10, withWeight=True, allowPOS=())  # 先按照权重排序，再按照词排序
print keyWord  # 前20个关键词，权重
keyList = []
for feature, weight in keyWord:  # 对关键词进行hash
    weight = int(weight * 10)
    feature = string_hash(feature)
    temp = []
    for i in feature:
        if (i == '1'):
            temp.append(weight)
        else:
            temp.append(-weight)
    print temp  # 将hash值用权值替代
    keyList.append(temp)
list_sum = np.sum(np.array(keyList), axis=0)  # 20个权值列向相加
print 'list_sum:', list_sum  # 权值列向求和
if (keyList == []):  # 编码读不出来
    print '00'
simhash = ''
for i in list_sum:  # 权值转换成hash值
    if (i > 0):
        simhash = simhash + '1'
    else:
        simhash = simhash + '0'
simhash_1 = simhash
print simhash_1  # str 类型
print '----------------------------------------------------------------'

# 相似度对比样本
num = 0
for line in open('edu.txt').readlines():  # 只读文档的第一行
    print type(line)  # <type 'str'>

    num += 1
    if num != 2:
        lines = line
        seg = jieba.cut(lines)  # 分词
        jieba.analyse.set_stop_words('stopword.txt')  # 去除停用词
        keyWord = jieba.analyse.extract_tags(
            '|'.join(seg), topK=10, withWeight=True, allowPOS=())  # 先按照权重排序，再按照词排序
        print keyWord  # 前20个关键词，权重
        keyList = []
        for feature, weight in keyWord:  # 对关键词进行hash
            weight = int(weight * 10)
            feature = string_hash(feature)
            temp = []
            for i in feature:
                if (i == '1'):
                    temp.append(weight)
                else:
                    temp.append(-weight)
            print temp  # 将hash值用权值替代
            keyList.append(temp)
        list_sum = np.sum(np.array(keyList), axis=0)  # 20个权值列向相加
        print 'list_sum:', list_sum  # 权值列向求和
        if (keyList == []):  # 编码读不出来
            print '00'
        simhash = ''
        for i in list_sum:  # 权值转换成hash值
            if (i > 0):
                simhash = simhash + '1'
            else:
                simhash = simhash + '0'
        # simhash_1 = simhash
        print simhash  # str 类型
        print '----------------------------------------------------------------'

        value = hammingDis(simhash_1, simhash)
        print value
        if value <= 3:
            print 'Is Similar'
        else:
            print "Isn't Similar"
        print '----------------------------------------------------------------'