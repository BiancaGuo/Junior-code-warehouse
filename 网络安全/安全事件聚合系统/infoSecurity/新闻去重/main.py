#-*- coding:utf-8
from lda import get_lda_model
from similarity import lda_similarity_corpus
from save_result import save_similarity_matrix
import traceback

INPUT_PATH = ""
OUTPUT_PATH = "./lda_simi_matrix.txt"

def main():
    try:

        # 语料
        documents = ["http://36kr.com/newsflashes/94501",
                     "Shipment of gold damaged in a fire",
                     "Shipment of gold damaged in a qwer",]

        # 训练lda模型
        K = 2 # number of topics
        lda_model, _, _,corpus_tf, _ = get_lda_model(documents, K)

        # 计算语聊相似度
        lda_similarity_matrix = lda_similarity_corpus( corpus_tf, lda_model )

        # 保存结果
        save_similarity_matrix( lda_similarity_matrix, OUTPUT_PATH )

    except Exception,e:
        print traceback.print_exc()

main()