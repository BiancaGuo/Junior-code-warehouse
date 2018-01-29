#-*- coding:utf-8

'''

lda_model.py
这个文件的作用是lda模型的训练
根据预处理的结果，训练lda模型

'''

from pre_process import documents_pre_process
from gensim import corpora, models, similarities
import traceback

# 训练tf_idf模型
def tf_idf_trainning(documents_token_list):
    try:

        # 将所有文章的token_list映射为 vsm空间
        dictionary = corpora.Dictionary(documents_token_list)

        # 每篇document在vsm上的tf表示
        corpus_tf = [ dictionary.doc2bow(token_list) for token_list in documents_token_list ]

        # 用corpus_tf作为特征，训练tf_idf_model
        tf_idf_model = models.TfidfModel(corpus_tf)

        # 每篇document在vsm上的tf-idf表示
        corpus_tfidf = tf_idf_model[corpus_tf]

        #print "[INFO]: tf_idf_trainning is finished!"
        return dictionary, corpus_tf, corpus_tfidf

    except Exception,e:
        print traceback.print_exc()

# 训练lda模型
def lda_trainning( dictionary, corpus_tfidf, K ):
    try:

        # 用corpus_tfidf作为特征，训练lda_model
        lda_model = models.LdaModel( corpus_tfidf, id2word=dictionary, num_topics = K )

        # 每篇document在K维空间上表示
        corpus_lda = lda_model[corpus_tfidf]

        #print "[INFO]: lda_trainning is finished!"
        return lda_model, corpus_lda

    except Exception,e:
        print traceback.print_exc()

'''
功能:根据文档来训练一个lda模型，以及文档的lda表示
    训练lda模型的用处是来了query之后，用lda模型将queru映射为query_lda
@documents:原始文档raw material
@K:number of topics
@lda_model:训练之后的lda_model
@corpus_lda:语料的lda表示
'''
def get_lda_model( documents, K ):
    try:

        # 文档预处理
        documents_token_list = documents_pre_process( documents )

        # 获取文档的字典vsm空间,文档vsm_tf表示,文档vsm_tfidf表示
        dict, corpus_tf, corpus_tfidf = tf_idf_trainning( documents_token_list)

        # 获取lda模型,以及文档vsm_lda表示
        lda_model, corpus_lda = lda_trainning( dict, corpus_tfidf, K )

        print "[INFO]:get_lda_model is finished!"
        return lda_model, corpus_lda, dict, corpus_tf, corpus_tfidf

    except Exception,e:
        print traceback.print_exc()