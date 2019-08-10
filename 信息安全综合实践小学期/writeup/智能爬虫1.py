# -*- coding: utf-8 -*-

import urllib
import urllib2
import string
import re
import cookielib

# 需要提交post的url
TARGET_URL = "http://sec.cuc.edu.cn/ctf/backend/spider_basics_100.php"
agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0'
cookies='PHPSESSID=j4m02fhjc76bhrs47orvri8n05'


headers = {
    'User-Agent': agent,
    'Cookie':cookies,
    'Upgrade-Insecure-Requests':	"1",
    'Cache-Control':"max-age=0",
    'Connection':	"keep-alive"

}
html=requests.get(TARGET_URL)
print html.url
content = html.text
print content

for i in range(0,100):
    soup = BeautifulSoup(content, 'lxml')
    items = soup.find('label',id='token')
    # print items
    print items.string.strip()
    post_data = {
            'token':items.string.strip()
        }

    data = urllib.urlencode(post_data)
    req_url = requests.get(TARGET_URL,post_data,headers=headers)
    print req_url.url
    # response_url = urllib2.urlopen(req_url)
    content = req_url.text
    print content