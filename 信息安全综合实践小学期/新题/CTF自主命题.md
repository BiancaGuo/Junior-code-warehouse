## CTF自主命题 —— by Bianca

### 一、WEB（or Programming）

题目：hurry up！

* 题目描述：提交参数：?Flag=xxx（hint：看看response header）
* 题目附件：见`hurryUp.php`
* 题目思路参考：http://www.shiyanbar.com/ctf/1854
* 答案：tCTF{Sp1der_1s_Interest1ng}
* 分值：100
* WriteUp：
	* 代码如下：
	
			import requests
			import base64
			import urllib
			import urllib2
			import string
			import re
			import cookielib
			agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0'
			cookies='PHPSESSID=0ol3i22if37fbhm81mrkn3arb1'
					
					
			headers = {
					    'User-Agent': agent,
					    'Cookie':cookies,
					    'Upgrade-Insecure-Requests':"1",
					    'Cache-Control':"max-age=0",
					    'Connection':"keep-alive"
					
			}
			req_url = requests.get("http://127.0.0.1/ctf.php",headers=headers)
			key = req_url.headers['Flag']
			flag = base64.b64decode(key)
			post_data = {
					  'Flag':flag
			}
			req_url = requests.get("http://127.0.0.1/ctf.php",post_data,headers=headers)
			print req_url.text
		

### 二、FORENSICS

题目：nvshen I love you！

* 题目描述：找到女神就归你~（提交格式：tCTF{<图片base64编码的最后十个字符>})
* 题目附件：nvshen.gif
* 题目思路参考：http://ctf.nuptzj.cn/challenges#%E4%B8%98%E6%AF%94%E9%BE%99De%E5%A5%B3%E7%A5%9E
* 答案：tCTF{JJJAf/2Q==}
* 分值：100
* WriteUp：
	* binwalk跑一下，发下有zip文件末尾标识
	* 在winhex中找到疑似文件头的位置，修改后将zip文件分离出来（下图中的514C改为504B）

		![](https://i.imgur.com/Wh4I2NJ.jpg)

	* 压缩包中有一张加密的nvshen.jpg，它的密码也在刚才winhex查看的位置（如上图，也可用文本编辑器打开gif文件，查找password所在位置），base64解密后即为压缩包密码（ILoveYou）。
	* 解压得到图片，计算图片base64编码后的值，取最后十个字符提交。

### 三、CRYPTO

题目：伟人的秘密 

* 题目描述：提交格式为tCTF{<获得的flag小写>}

		XPHKZGJTDSENYVUBMLAOIRFCQW 
		ZWAXJGDLUBVIQHKYPNTCRMOSFE 
		KPBELNACZDTRXMJQOYHGVSFUWI 
		TDSWAYXPLVUBOIKZGJRFHENMCQ 
		RPLNDVHGFCUKTEBSXQYIZMJWAO 
		XPLTDAOIKFZGHENYSRUBMCQWVJ 
		QWATDSRFHENYVUBMCOIKZGJXPL 
		BMCSRFHLTDENQWAOXPYVUIKZGJ 
		WABMCXPLTDSRJQZGOIKFHENYVU 
		GWTHSPYBXIZULVKMRAFDCEONJQ 
		NOZUTWDCVRJLXKISEFAPMYGHBQ 
		BDMAIZVRNSJUWFHTEQGYXPLOCK 
		AMKGHIWPNYCJBFZDRUSLOQXVET 
		IHFRLABEUOTSGJVDKCPMNZQWXY 
		XPLTDAOIKFZGHENYSRUBMCQWVJ  

密钥： 3,11,5,1,2,6,7,9,15,13,14,4,10,8,12

密文：APMYFHIIAYRKGNI

* 题目附件：无
* 题目思路参考：https://blog.csdn.net/pdsu161530247/article/details/73604729
* 答案：tCTF{thomasjefferson}
* 分值：50
* WriteUp：
	* 可按照杰弗逊转轮加密逻辑手工推出
	* 代码参考：http://www.bugku.com/thread-75-1-1.html

			table = '''XPHKZGJTDSENYVUBMLAOIRFCQW 
			ZWAXJGDLUBVIQHKYPNTCRMOSFE 
			KPBELNACZDTRXMJQOYHGVSFUWI 
			TDSWAYXPLVUBOIKZGJRFHENMCQ 
			RPLNDVHGFCUKTEBSXQYIZMJWAO 
			XPLTDAOIKFZGHENYSRUBMCQWVJ 
			QWATDSRFHENYVUBMCOIKZGJXPL 
			BMCSRFHLTDENQWAOXPYVUIKZGJ 
			WABMCXPLTDSRJQZGOIKFHENYVU 
			GWTHSPYBXIZULVKMRAFDCEONJQ 
			NOZUTWDCVRJLXKISEFAPMYGHBQ 
			BDMAIZVRNSJUWFHTEQGYXPLOCK 
			AMKGHIWPNYCJBFZDRUSLOQXVET 
			IHFRLABEUOTSGJVDKCPMNZQWXY 
			XPLTDAOIKFZGHENYSRUBMCQWVJ'''
			key = (3,11,5,1,2,6,7,9,15,13,14,4,10,8,12)
			cipher = 'APMYFHIIAYRKGNI'
			table = table.split()
			table = [table[key[x] - 1] for x in range(15)]
			key = [table[x].index(cipher[x]) for x in range(len(cipher))]
			for i in range(len(table)):
			    table[i] = table[i][key[i]:] + table[i][:key[i]]
			for i in range(26):
			    s = ''
			    for j in range(len(table)):
			        s += table[j][i]
			    print s

