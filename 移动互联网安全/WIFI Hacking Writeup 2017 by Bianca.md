## WIFI Hacking Writeup 2017 by Bianca

### 思路：数据包中的哪些字段能够满足题目所给的条件，应用为filter，再借助tshark，快速筛选去重（办自动化）
### tshark命令行参数：

- -n: 禁止网络对象名称解析;
- -r: 读取本地文件，可以先抓包存下来之后再进行分析;
- -T,-e: 打印字段;
- -Y：筛选规则

### 一、WIFI Hacking 1 

1、题目要求：分析附件提供的pcap中有多少可用AP？

2、过滤思路：

使用 `tshark -r ctf-chinese.pcap -n -T fields -e wlan_mgt.ssid | sort -u` 筛选出所有不重复的AP的SSID，而后删除beacons和response都为0的SSID即得到所有可用IP。还要对其中的中文SSID进行解码：

	a='\xcc\xd2\xbb\xa8\xb5\xba\xd1\xb5\xc1\xb7\xd7\xa8\xd3\xc3\x57\x49\x46\x49'
	print a.decode('gbk').encode('utf-8')

beacon帧：信标帧，是相当重要的维护机制，主要来宣告某个网络的存在。定期发送的信标，可让移动工作站得知该网络的存在，从而调整加入该网络所必要的参数。在基础网络里，接入点必须负责发送Beacon帧，Beacon帧所及范围即为AP服务区域。在基础型网络里，所有沟通都必须通过接入点，因此工作站不能距离太远，否则无法接收到信标。


3、flag：tCTF{WIFI_H4CK1NG_1_COMPL3T33D}

4、提交结果：	
	
	A101E
	a101e-guest
	and-Business
	ChinaNet
	CMCC
	CMCC-EDU
	CMCC-WEB
	CUC
	CUC-AC-001
	lczhap
	桃花岛训练专用WIFI

### 二、WIFI Hacking 2

1、题目要求：找到WIFI Hacking 1题目附件中所有尝试连接过ssid为a101e-guest的无线客户端MAC地址

2、过滤思路：
	
查看wlan统计可知a101e-guest的BSSID为d8:fe:e3:e5:31:23，所以使用 `tshark -r ctf-chinese.pcap -n -T fields -e wlan.da -Y "wlan.bssid==d8:fe:e3:e5:31:23"| sort -u` 筛选出所有尝试连接过a101e-guest的不重复SSID(去重）。

![](https://i.imgur.com/fkZ3hKe.png)

3、flag：tCTF{W1F1_H4CK1NG_2_D0N3}

4、提交结果：

	00:1a:a9:c1:fc:35
	08:70:45:dd:20:a0
	34:23:ba:8b:97:b7
	38:bc:1a:64:2c:08
	56:75:f1:3c:4c:08
	60:f8:1d:87:0e:19
	64:9a:be:82:9f:c5
	6c:25:b9:1f:cb:94
	70:14:a6:39:f8:2f
	78:9f:70:03:44:3a
	e2:08:bd:58:1e:3b


### 三、WIFI Hacking 3

1、题目要求：找到WIFI Hacking 1题目附件中无线客户端尝试连接过但抓包期间信号覆盖范围内不存在的AP的SSID集合

2、过滤方法：

	查看wlan统计：
	Beacon=0
	probe request>0
	probe response=0

3、提交结果：

	sharkAP
	Apple Setup
	GGBWG-G
	Chu-Sushi

4、flag：tCTF{WIFI_H4CK1NG_3_Y3T_AN0THER_D0N3}

probe request帧：移动工作站将会利用 Probe Request （探测请求）帧，扫描所在区域内目前有哪些 802.11网络。
probe response帧：如果Probe Request 帧所探测的网络与之相容，该网络就会以 Probe Response 帧应答。
beacon帧：信标帧，是相当重要的维护机制，主要来宣告某个网络的存在。定期发送的信标，可让移动工作站得知该网络的存在，从而调整加入该网络所必要的参数。在基础网络里，接入点必须负责发送Beacon帧，Beacon帧所及范围即为AP服务区域。在基础型网络里，所有沟通都必须通过接入点，因此工作站不能距离太远，否则无法接收到信标。

### 四、WIFI Hacking 4

1、题目要求：找到附件中唯一的一个“乱入”的手机，这部手机没有连接上任何一个热点，但暴漏了它曾经连过很多热点。请将这些热点的SSID集合填入到以下网址

2、过滤方法：

1）在wireshark中过滤probe request包（`wlan.fc.type_subtype == 0x0004`），发现图中设备发出大量request包但均未收到response（`wlan.fc.type_subtype == 0x0005`）

![](https://i.imgur.com/jogScoH.png)

2）查看该设备mac地址

![](https://i.imgur.com/ONkZ9GQ.png)


3）查找连过热点的ssid：tshark -r "20161025-01-filtered.cap" -n -T fields -e 'wlan_mgt.ssid' -Y 'wlan.fc.type_subtype == 0x0004 && wlan.sa == 7c:1d:d9:df:a1:0b' | sort -u
	
4）有中文字符的ssid解码：python- print s.decode('utf-8')

3、 提交结果：

	Feixun_AFE4B3
	ganluyuan5
	gg
	KL4
	LieBaoWiFi744
	linan
	sft4-1
	SQBG8701
	sxbl
	sxblz
	XUE
	神州专车

4、flag：tCTF{4E30D412-049A-48C4}


### 五、WIFI Hacking 6

1、题目要求：找到WIFI Hacking 4题目附件中哪些AP（在请求响应帧中找）支持WPA/WPA2企业级认证方式？请将这些热点的MAC地址集合填入到以下网址

2、过滤方法：

http://blog.csdn.net/zhangxinrun/article/details/10517581

http://blog.csdn.net/rs_network/article/details/50676786

https://wenku.baidu.com/view/24fdb66df56527d3240c844769eae009581ba27b.html

RSN字段下的Auth Key Management 字段为WPA时支持WPA/WPA2企业级认证方式：

可能存在隐藏id，就不在beacon帧中找，在Probe Response帧中找：

Robust Secure Network：包含了AP的安全配置信息

认证密钥管理协商：来实现STA与AP之间的加密算法以及密钥管理方式的协商。如果网络中有RADIUS服务器作为认证服务器，那么 STA就使用802.1x方式进行认证；如果网络中没有RADIUS，STA与AP就会采用预共享密钥（PSK，Pre-Shared Key）的方式。

![](https://i.imgur.com/XkWR8lH.png)
	
使用命令 `tshark -r "20161025-01-filtered.cap" -n -T fields -e wlan.bssid -Y "wlan_mgt.rsn.akms.type == 1" | sort -u` 筛选出符合条件的MAC地址

3、提交结果：

	52:1a:a9:c1:fc:37
	d8:fe:e3:e5:31:18

4、flag：tCTF{55263790-4133-46E6}

### 六、WIFI Hacking 7

1、题目要求：找到WIFI Hacking 4题目附件中哪些AP可能是设置了禁止SSID广播？试列举所有的BSSID？

隐藏SSID：隐藏ssid本身就是AP不发射beacon帧(用来广播SSID),但不影响数据传输的正常使用,目的就是不让其他人知道有这个无线信号。 

http://blog.csdn.net/dyllove98/article/details/9631367

2、过滤方法：

	查看wifi 统计：
	Beacon frames=0
    probe response>0

3、提交结果：

	6c:70:9f:e8:57:90
	ec:88:8f:95:ff:12

4、flag:tCTF{8E32-97812-8D187E3}

### 七、WIFI Hacking 5

1、题目要求：找到WIFI Hacking 4题目附件中哪些AP仅支持使用WPA2 CCMP/AES认证加密模式？请将这些热点的MAC地址集合填入到以下网址并提交

2、过滤方法：
	RSN中数据加密及完整性校验算法有两种，分别是TKIP和CCMP
	CCMP(CTR with CBC-MAC Protocol): 基于AES的全新加密协议，在IEEE 802.11i中提出
	CCMP加密在802.11i修正案中定义，用于取代TKIP和WEP加密。CCMP使用AES块加密算法取代WEP和TKIP的RC4流算法，它也是WAP2指定的加密方式，因为AES加密算法是和处理器相联系的，所以旧的设备中可以支持WEP和TKIP，但是不能支持CCMP/AES加密，关于AES算法的详细介绍可以查看文档《FIPS PUB 197-2001 》。值得注意的是，在CCMP加密使用的AES算法中都是使用的128bit的密钥和128bit的加密块,关于CCM的定义请参考《IETF RFC 3610 》。

	802.11i、WPA、WPA2、PSK、802.1X、TKIP、CCMP和AES，这些概念之间到底是怎么样个关系？
    802.11i是无线安全协议，是总的原则，相当于“宪法”，其内容包括WPA和WPA2两个部分内容，WPA相当于“治安处罚管理条例”，而WPA2相 当于“刑罚”，所以WPA2是更高级的一种安全方式。PSK和802.1X是两种无线安全认证方式，PSK是一种个人级别的，相对简单，而802.1X是 一种企业级别的，较为复杂，但更安全。TKIP和CCMP是两种数据加密算法，在WPA和WPA2中都可以使用。而AES是CCMP算法中的核心算法，且 目前来看，是最可靠的加密算法。

以下两字段均为AES（参考资料：http://www.freebuf.com/articles/wireless/134349.html）：

	Group Cipher Suite（组播加密套件）：该字段标识了使用何种加密算法进行组播加密
	pairwise cipher type 单播加密类型
	TKIP：临时密钥完整性协议（链路层）

![](https://i.imgur.com/HKKiIZR.png)

构造筛选代码：`tshark -r 20161025-01-filtered.cap -n -T fields -e 'wlan.sa' -Y "wlan_mgt.rsn.pcs.type == 4&&wlan_mgt.rsn.gcs.type == 4" | sort -u`

3、提交结果：

	52:1a:a9:c1:fc:37
	6c:70:9f:e8:57:90
	ac:f1:df:78:c7:67
	ec:88:8f:95:ff:12

4、flag：tCTF{817A-5798C97-C773B}


## WIFI Hacking Writeup 2017 Hidden SSID by 郭韵婷 Bianca


### 一、隐藏ssid的名称

（成功抓到有隐藏SSID的三个包~~ BSSID貌似都是ac:f1:df:78:c7:5b）

pcap1：uc4nuup

pcap2：<length:  13>

pcap3：你们期待的中文SSID来了

### 二、分析方法

**1、方法一：抓包手工分析（以第三个隐藏SSID的发现为例）**

* 用wireshark打开pcap包，查看WLAN流量统计。可以发现其中有SSID为空的AP，但是它仍发出了probe response包。右键作为过滤器应用。

![](https://i.imgur.com/9pSP5ux.png)

* 接着筛选该AP发出的响应包，可以发现SSID已经暴露

![](https://i.imgur.com/oLGViNI.png)

* 将SSID进行解码，得到最终答案

![](https://i.imgur.com/4E7rGiy.png)

**2、借用scapy程序自动化分析**


	# 版本兼容
	from __future__ import unicode_literals
	import os
	import sys
	
	# Dot11:802.11
	# Dot11Elt:802.11 Information Element,load all datas in beacon frame
	# rdpcap:read the pcap file
	from scapy.all import Dot11, Dot11Elt, rdpcap
	
	pcap = sys.argv[1]
	
	if not os.path.isfile(pcap):
		print('input file does not exist')
		exit(1)
	
	beacon_all = set()  #存储beacon帧中SSID未隐藏的所有AP的MAC地址的集合
	beacon_null = set() #存储beacon帧中隐藏了SSID的所有AP的MAC地址的集合
	ssids_all = set()   #存储beacon帧和probe request帧中AP的MAC地址与SSID（不为空）的对应关系的集合
	ssids_hidden = set()#存储在probe response帧中SSID不为空而在beacon 帧中SSID为空的AP的MAC地址与SSID的对应关系的集合
	proberesp_all = set()#存储probe request帧中AP的MAC地址与SSID的对应关系的集合
	
	pkts = rdpcap(pcap)
	
	for pkt in pkts:
		if not pkt.haslayer(Dot11Elt):   # Not an 802.11 pkt
			continue
		if pkt.subtype == 8: # Beacon Frame
			# print(pkt.summary())
			# print(pkt.getlayer(Dot11Elt).info)
			if pkt.getlayer(Dot11Elt).info.decode('utf-8').strip('\x00') == '': # SSID is empty
				beacon_null.add(pkt.addr3)   #Note all aps' MAC address whose ssid is empty.
			else:
				beacon_all.add(pkt.addr3)
				ssids_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8')) #BSSID-------SSID
		elif pkt.subtype == 5:   # Probe Response
				proberesp_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
				if pkt.addr3 in beacon_null:   #the Mac address is the same but ssid in beacon frame is empty.Note the ssid from probe response pkt.
					ssids_hidden.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
				else:
					ssids_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
	
	for essid in ssids_hidden:   #BSSID-------SSID
		print(essid)
	
	rs = proberesp_all.difference(ssids_all).difference(ssids_hidden)#Screening residual elements，筛选不存在beacon frame的AP
	
	print('----------------------')
	
	for essid in rs:
		print(essid)


* 分析效果

![](https://i.imgur.com/qx655KK.png)




