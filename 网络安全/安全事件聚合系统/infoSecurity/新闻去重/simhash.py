#!/usr/bin/python
#-*- coding:utf-8

import sys
reload(sys)
sys.setdefaultencoding("utf8")
import jieba

class simhash:
    # 构造函数
    def __init__(self, tokens='', hashbits=128):
        self.hashbits = hashbits
        self.hash = self.simhash(tokens)

    # toString函数
    def __str__(self):
        return str(self.hash)

    # 生成simhash值
    def simhash(self, tokens):
        v = [0] * self.hashbits
        for t in [self._string_hash(x) for x in tokens]:  # t为token的普通hash值
            for i in range(self.hashbits):
                bitmask = 1 << i
                if t & bitmask:
                    v[i] += 1  # 查看当前bit位是否为1,是的话将该位+1
                else:
                    v[i] -= 1  # 否则的话,该位-1
        fingerprint = 0
        for i in range(self.hashbits):
            if v[i] >= 0:
                fingerprint += 1 << i
        return fingerprint  # 整个文档的fingerprint为最终各个位>=0的和

    # 求海明距离
    def hamming_distance(self, other):
        x = (self.hash ^ other.hash) & ((1 << self.hashbits) - 1)
        tot = 0
        while x:
            tot += 1
            x &= x - 1
        return tot

    # 求相似度
    def similarity(self, other):
        a = float(self.hash)
        b = float(other.hash)
        if a > b:
            return b / a
        else:
            return a / b

    # 针对source生成hash值   (一个可变长度版本的Python的内置散列)
    def _string_hash(self, source):
        if source == "":
            return 0
        else:
            x = ord(source[0]) << 7
            m = 1000003
            mask = 2 ** self.hashbits - 1
            for c in source:
                x = ((x * m) ^ ord(c)) & mask
            x ^= len(source)
            if x == -1:
                x = -2
            return x

#表名、id、abstraction
if __name__ == '__main__':
    news=[]
    import MySQLdb
    # 打开数据库连接
    db = MySQLdb.connect(host='localhost', user='root', passwd='123', db='Spider2', charset='utf8')
    # 使用cursor()方法获取操作游标
    cursor = db.cursor()
    choices = ["SpiderFor36ker", "SpiderForCnbeta"]
    # SQL 查询语句
    i = 0
    for choice in choices:#表名
        id = 0
        sql = "SELECT `abstraction` FROM " + choice
        # 执行SQL语句
        cursor.execute(sql)
        # 获取所有记录列表
        results = cursor.fetchall()
        for row in results:
            id = id + 1 #id号
            s = "".join(row)
            #print s
            s=s.encode("utf-8").replace(' ', '').replace('\n', '').replace('\t', '')
            while len(s)<2000:
                s+=s
            hash = simhash(s.split()) #hash值
            #print hash
            dic={"table":choice, "id":id, "hash":hash }
            news.append(dic)

    for k in range(0,len(news)):
        for v in range(0,len(news)):#查找算法可以优化
            sql = "SELECT `news_url` FROM " + news[k]["table"] + " WHERE id =" + str(news[k]["id"])
            cursor.execute(sql)
            url_1 = cursor.fetchall()

            sql = "SELECT `news_url` FROM " + news[v]["table"] + " WHERE id =" + str(news[v]["id"])
            cursor.execute(sql)
            url_2 = cursor.fetchall()
            if url_1[0][0]!="" and url_2[0][0]!="":
                sem=news[k]["hash"].similarity(news[v]["hash"])
                print news[k]["table"]+"-"+str(news[k]["id"])+ " vs " + news[v]["table"]+"-"+str(news[v]["id"])+ ":"+ str(sem)
                if sem > 0.9 :
                    if url_1[0][0] != url_2[0][0] or (url_1[0][0] == url_2[0][0] and news[k]["id"]!=news[v]["id"]):
                        url_3=url_1[0][0]+" "+url_2[0][0]

                        #source
                        sql = "SELECT `source` FROM " + news[k]["table"] + " WHERE id =" + str(news[k]["id"])
                        cursor.execute(sql)
                        source_1 = cursor.fetchall()
                        sql = "SELECT `source` FROM " + news[v]["table"] + " WHERE id =" + str(news[v]["id"])
                        cursor.execute(sql)
                        source_2 = cursor.fetchall()
                        source_3 = source_1[0][0] + " " + source_2[0][0]
                        sql = 'UPDATE `' + news[k]["table"] + '` SET `source` = "' + str(source_3) + '" WHERE id = ' + str(news[k]["id"])
                        cursor.execute(sql)
                        sql = 'UPDATE `' + news[v]["table"] + '` SET `source` = "" WHERE id = ' + str(news[v]["id"])
                        cursor.execute(sql)
                        print "source changed!"

                        #title
                        sql = "SELECT `title` FROM " + news[k]["table"] + " WHERE id =" + str(news[k]["id"])
                        print sql
                        cursor.execute(sql)
                        title_1 = cursor.fetchall()
                        sql = "SELECT `title` FROM " + news[v]["table"] + " WHERE id =" + str(news[v]["id"])
                        cursor.execute(sql)
                        title_2 = cursor.fetchall()
                        title_3 = title_1[0][0] + " " + title_2[0][0]
                        #print news[k]["table"]
                        sql = 'UPDATE `' + news[k]["table"] + '` SET title = "' + str(title_3) + '" WHERE id = ' + str(news[k]["id"])
                        print sql
                        cursor.execute(sql)
                        sql = 'UPDATE `' + news[v]["table"] + '` SET `title` = "" WHERE id = ' + str(news[v]["id"])
                        cursor.execute(sql)
                        print "title changed!"


                        #news_url
                        sql = 'UPDATE `'+ news[k]["table"] +'` SET `news_url` = "'+ str(url_3) +'" WHERE id = '+str(news[k]["id"])
                        cursor.execute(sql)
                        sql = 'UPDATE `' + news[v]["table"] + '` SET `news_url` = "" WHERE id = ' + str(news[v]["id"])
                        cursor.execute(sql)
                        print "url changed!"

    # 关闭数据库连接
    db.close()

