## CUC CTFd @TaoHuaIsland平台 WriteUp —— by Bianca

### 一、CRYPTO（70）

#### 1、rot13（10）

* ROT13码意思是将字母左移13位。如'A' ↔ 'N'

(1) 将svefgC4ffSy4T经过rot13编码转换得到：firstP4ssFl4G

(2) 计算解码后结果的md5值：

* md5(firstP4ssFl4G,32) = 23e0f116244ca90ff984d2983e711808
* md5(firstP4ssFl4G,16) = 244ca90ff984d298

#### 2、JS代码也可以萌萌哒 (20)

(1) 观察这段密文中有“+”、“/”，推测经过了base64编码，使用工具解码后得到结果如下：

![](https://i.imgur.com/yOUqBXv.jpg)

* Base64是网络上最常见的用于传输8Bit字节码的编码方式之一，Base64就是一种基于64个可打印字符来表示二进制数据的方法。

(2) 查阅资料得知为aaencode编码，使用[工具](https://cat-in-136.github.io/2010/12/aadecode-decode-encoded-as-aaencode.html)得到结果：alert("Welcome2TaoHuaIsland");

(3) 计算js代码执行后的结果的md5值：

* md5(Welcome2TaoHuaIsland,32) = 601aabe4c19c7c10c04d3bb70ada6dbc
* md5(Welcome2TaoHuaIsland,16) = c19c7c10c04d3bb7

#### 3、CUC编码（20）

（1）将此段编码后的文字进行代码格式化，感觉很像可执行代码

    CUC = ~ [];
	CUC = {
	    ___: ++CUC,
	    $$$$: (![] + "")[CUC],
	    __$: ++CUC,
	    $_$_: (![] + "")[CUC],
	    _$_: ++CUC,
	    $_$$: ({} + "")[CUC],
	    $$_$: (CUC[CUC] + "")[CUC],
	    _$$: ++CUC,
	    $$$_: (!"" + "")[CUC],
	    $__: ++CUC,
	    $_$: ++CUC,
	    $$__: ({} + "")[CUC],
	    $$_: ++CUC,
	    $$$: ++CUC,
	    $___: ++CUC,
	    $__$: ++CUC
	};
	CUC.$_ = (CUC.$_ = CUC + "")[CUC.$_$] + (CUC._$ = CUC.$_[CUC.__$]) + (CUC.$$ = (CUC.$ + "")[CUC.__$]) + ((!CUC) + "")[CUC._$$] + (CUC.__ = CUC.$_[CUC.$$_]) + (CUC.$ = (!"" + "")[CUC.__$]) + (CUC._ = (!"" + "")[CUC._$_]) + CUC.$_[CUC.$_$] + CUC.__ + CUC._$ + CUC.$;
	CUC.$$ = CUC.$ + (!"" + "")[CUC._$$] + CUC.__ + CUC._ + CUC.$ + CUC.$$;
	CUC.$ = (CUC.___)[CUC.$_][CUC.$_];
	CUC.$...

（2）因为与很多“！”、“[]”字符，推测为javascript代码的一种编码方式（jother编码），添加console.log语句调试，得到如下结果：

![](https://i.imgur.com/WmkfJXr.jpg)

（3）运行上面的js代码得到flag。

![](https://i.imgur.com/FMbATyH.jpg)


#### 4、什么gui？（20）

* 此题为jother编码，即运用于javascript语言中利用少量字符构造精简的匿名函数方法对于字符串进行的编码方式。其中8个少量字符包括： ! + ( ) [ ] { } 。只用这些字符就能完成对任意字符串的编码。

在控制台中直接执行得到：

![](https://i.imgur.com/rhKWwwq.jpg)

### 二、FORENSICS（450）

#### 1、 猜猜我在哪儿（50）

* 该文件为.doc文件，但是下载的过程中发现文件很大（1767KB），推测此文件中包含其他文件。将该.doc文件后缀名改为.zip，打开发现其中的media文件夹下有一张图片上有flag。

![](https://i.imgur.com/H0NgTjD.jpg)

#### 2、苹果程序员的烦恼（50）

（1） 将jpeg文件下载，用winhex（hxd）工具打开，在文件末尾发现疑似base64编码的字符。

![](https://i.imgur.com/Q4E62H2.jpg)

（2）base64解码后发现为一串路径

![](https://i.imgur.com/LEJeTka.jpg)

* .DS_Store是Mac OS保存文件夹的自定义属性的隐藏文件

（3）尝试访问服务器的.DS_Store文件


> http://sec.cuc.edu.cn/ctf/backend/hidden_150/C5B7858D-0899-46D2-AA91-21F0BE2A801E/.DS_Store

（4）文件自动下载，使用winhex打开后发现flag

![](https://i.imgur.com/p7BWHFX.jpg)

#### 3、猜猜我在哪儿2（100）

（1）下载过程中发现该jpg文件过大，分析有文件隐藏，后缀名改为zip后打开压缩包并没有发现，之后尝试用kali下的binwalk工具分析，发现其中隐藏有一个gzip格式文件。

![](https://i.imgur.com/AYVWFpm.jpg)

（2）使用dd命令分离出隐藏文件，打开发现存在flag.docx文件

![](https://i.imgur.com/mXFwStL.jpg)

* 使用binwalk -e filename可以直接分离文件


（3）之后按照“猜猜我在哪儿”的套路，获得flag。

![](https://i.imgur.com/HCuKpDf.jpg)

#### 4、揣着明白装糊涂（100）

（1）将图片下载下来，查看属性发现hint。

![](https://i.imgur.com/xW6kBGU.jpg)

（2）获取.DS_Store文件（http://sec.cuc.edu.cn/ctf/backend/hidden_200/.DS_Store)，winhex打开后发现以下字样

![](https://i.imgur.com/9uLJCfX.jpg)

（3）清除干扰的符号之后，推测还有一个jpg文件，文件名为83853064-A971-49CB-B7C5-02F4A58C87C6.jpg，访问服务器上的该图片，下载到本地。将其后缀改为.zip后解压缩，发现一个flag.php文件。

![](https://i.imgur.com/7Z5uHW2.jpg)

（4）将该文件放到ubuntu下/var/www/html/路径下，开启apache服务，在浏览器中访问该文件获得flag。

![](https://i.imgur.com/obXxAYE.jpg)

#### 5、猜猜我在哪儿3（150）

（1）将文件后缀名改为.zip后发现其中有一个加密的flag.txt文件，因为隐写题中有一种题型是zip伪加密，所以先按照伪加密的方式尝试处理。

* 伪加密是在未加密的zip文件基础上修改了它的压缩源文件目录区里的全局方式位标记的比特值，使得压缩软件打开它的时候识别为加密文件.
* 伪加密破解方法的相关说明：https://blog.csdn.net/ETF6996/article/details/51946250

（2）使用winhex打开文件，找到zip文件头，对相应十六进制进行修改，将红色位置的09修改为00。

![](https://i.imgur.com/Cu48V9z.jpg)

（3）再次打开zip发现txt文件不需要密码即可查看。

![](https://i.imgur.com/opl5sCh.jpg)

* ps：使用binwalk分析文件可分离一张阿狸的图片，貌似没什么用处。


### 三、MISC （320）

#### 1、Google Hacking（20）

* base64解码后使用google搜索，获得flag。

![](https://i.imgur.com/9wvQcsP.jpg)

#### 2、脑洞解密系列-2（100）

（1）txt文件下载后发现每行为3个255以下的数（大部分为255）组成，推测代表的是像素值的RGB分量的大小。尝试利用python的PIL库将矩阵转化为图片。

（2）利用工具将文件行数进行[质因数分解](http://www.atool.org/quality_factor.php?)，推测图片的长宽，运行python代码最终得到flag。

代码如下：

    # -*- coding: UTF-8 -*-
	from PIL import Image
	
	x = 212    
	y = 380    
	
	im = Image.new("RGB", (x, y))   #创建图片
	file = open('misc100.txt')    #打开文件
	for i in range(0, x):
	    for j in range(0, y):
	        line = file.readline()  #获取一行的rgb值
	        rgb = line.split(", ")  #分离rgb，文本中逗号后面有空格
	        im.putpixel((i, j), (int(rgb[0]), int(rgb[1]), int(rgb[2])))    #将rgb转化为像素
	im.show()

运行得到的图片如下：

![](https://i.imgur.com/KjMhe9o.jpg)

* 本题参考链接：https://blog.csdn.net/ssjjtt1997/article/details/78450816

#### 3、暴力破解？！？（200）

（1）按照处理zip伪加密的方法获得了flag.png。

![](https://i.imgur.com/fEZImwC.png)

（2）使用winhex查看发现后半部分有很多类似base64编码后的字符，解码后发现由GIF89a开头，推测还隐藏着一张gif图片。

![](https://i.imgur.com/pSAZhHt.jpg)

（3）在kali下使用base64命令解码，结果存为flag.gif，使用StegSolve逐帧查看gif图，获得flag。

![](https://i.imgur.com/tNERwWv.jpg)

### 四、PROGRAMMING（370）

#### 1、ASCII二维码编码（20）

（1）根据题目推测01字符组成的二维矩阵代表了二维码相应位置的颜色，使用python读取01序列，将值为1的点的坐标存入文件中（为了接下来绘图）。

代码如下：

    # -*- coding: UTF-8 -*-
	from PIL import Image
	x = 25    
	y = 25 
	file = open('misc100.txt')   
	w=open('data.txt','w') 
	for i in range(0, x):
	        line = file.readline()  
	        for k in range(len(line)-1):
	            if line[k]=='1':
	                s= str(i)+' '+str(k)+"\n"
	                w.write(s)
	w.close()

data.txt内容：

![](https://i.imgur.com/JM2I81h.jpg)

（2）使用linux下的绘图工具gnuplot绘制二维码。

* 安装：apt install gnuplot-x11
* 使用：plot "data.txt" pt 5 ps 4(点的形状和大小）

![](https://i.imgur.com/g17anzr.jpg)

（3）扫描得到flag。

#### 2、纸老虎验证码破解 （50）

* 通过如下爆破脚本计算出结果后，使用get方法提交，得到flag
* 参考链接：https://blog.csdn.net/lacoucou/article/details/72355346
* 代码：见纸老虎验证码.py
		
![](https://i.imgur.com/GErrTqc.jpg)

#### 3、智能爬虫-1 (100)

* 见代码:智能爬虫1.py

![](https://i.imgur.com/KUQYEme.jpg)


#### 4、智能爬虫-3 (200)

* 见代码:智能爬虫2.py

![](https://i.imgur.com/kAkIPzN.jpg)

### 五、PWN（50）

#### 1、ROP（50）

* 利用IDA静态分析得到flag

![](https://i.imgur.com/MnYtux8.jpg)


## 以上五部分总得分为1260
