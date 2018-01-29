#-*- coding:utf-8

'''

preprocess.py
这个文件的作用是做文档预处理，
讲每篇文档，生成相应的token_list
只需执行最后documents_pre_process函数即可。

'''

import nltk
import traceback
import jieba
from nltk.corpus import stopwords
from nltk.stem.lancaster import LancasterStemmer
from collections import defaultdict

# 分词 - 英文
def tokenize(document):
    try:

        token_list = nltk.word_tokenize(document)

        #print "[INFO]: tokenize is finished!"
        return token_list

    except Exception,e:
        print traceback.print_exc()

# 分词 - 中文
def tokenize_chinese(document):
    try:

        token_list = jieba.cut( document, cut_all=False )

        #print "[INFO]: tokenize_chinese is finished!"
        return token_list

    except Exception,e:
        print traceback.print_exc()

# 去除停用词
def filtered_stopwords(token_list):
    try:


        token_list_without_stopwords = [ word for word in token_list
                                         if word not in stopwords.words("english")]


        #print "[INFO]: filtered_words is finished!"
        return token_list_without_stopwords
    except Exception,e:
        print traceback.print_exc()

# 去除标点
def filtered_punctuations(token_list):
    try:
        punctuations = ['', '\n', '\t', ',', '.', ':', ';', '?', '(', ')', '[', ']', '&', '!', '*', '@', '#', '$', '%']
        token_list_without_punctuations = [word for word in token_list
                                                         if word not in punctuations]
        #print "[INFO]: filtered_punctuations is finished!"
        return token_list_without_punctuations

    except Exception,e:
        print traceback.print_exc()

# 词干化
def stemming( filterd_token_list ):
    try:

        st = LancasterStemmer()
        stemming_token_list = [ st.stem(word) for word in filterd_token_list ]

        #print "[INFO]: stemming is finished"
        return stemming_token_list

    except Exception,e:
        print traceback.print_exc()

# 去除低频单词
def low_frequence_filter( token_list ):
    try:

        word_counter = defaultdict(int)
        for word in token_list:
            word_counter[word] += 1

        threshold = 0
        token_list_without_low_frequence = [ word
                                             for word in token_list
                                             if word_counter[word] > threshold]

        #print "[INFO]: low_frequence_filter is finished!"
        return token_list_without_low_frequence
    except Exception,e:
        print traceback.print_exc()

"""
功能：预处理
@ document: 文档
@ token_list: 预处理之后文档对应的单词列表
"""
def pre_process( document ):
    try:

        token_list = tokenize(document)
        #token_list = filtered_stopwords(token_list)
        token_list = filtered_punctuations(token_list)
        #token_list = stemming(token_list)
        #token_list = low_frequence_filter(token_list)

        #print "[INFO]: pre_process is finished!"
        return token_list

    except Exception,e:
        print traceback.print_exc()

"""
功能：预处理
@ document: 文档集合
@ token_list: 预处理之后文档集合对应的单词列表
"""
def documents_pre_process( documents ):
    try:

        documents_token_list = []
        for document in documents:
            token_list = pre_process(document)
            documents_token_list.append(token_list)

        print "[INFO]:documents_pre_process is finished!"
        return documents_token_list

    except Exception,e:
        print traceback.print_exc()

#-----------------------------------------------------------------------
def test_pre_process():

    documents = ["he,he,he,we are happy!",
                 "he,he,we are happy!",
                 "you work!"]
    documents_token_list = []
    for document in documents:
        token_list = pre_process(document)
        documents_token_list.append(token_list)

    for token_list in documents_token_list:
        print token_list

#test_pre_process()