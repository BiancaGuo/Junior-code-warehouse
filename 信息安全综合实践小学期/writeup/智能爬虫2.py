def findItems(content):
    soup = BeautifulSoup(content, 'lxml')
    tag = re.split(r'\s', content)[0][1:]
    #print tag
    if tag == "label":
        items = soup.find('label', id='token')
        items = items.string.strip()
        print items
    elif tag == "div":  #
        items = soup.find('div', id='token')['title'].strip()
        print items
    elif tag == "textarea":  #
        items = soup.find('textarea', id='token')
        items = items.string.strip()
        items = re.split(r'\s', items)[0].strip()
        print items
    elif tag == "span":  #
        items = soup.find('span', id='token')
        items = items.string.strip()
        items = re.split(r'/', items)[2].strip()
        print items
    elif tag == "img":  #
        items = soup.find('img', id='token')['src'].strip()
        print items
    elif tag == "a":  #
        items = soup.find('a', id='token')['href'].strip()
        print items
    return items

# 需要提交post的url
TARGET_URL = "http://sec.cuc.edu.cn/ctf/backend/spider_basics_200.php"
agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0'
cookies='PHPSESSID=j4m02fhjc76bhrs47orvri8n05;october_session=eyJpdiI6Im54MWgyMkk4Q0VFSFU3b1RCbVFzdVE9PSIsInZhbHVlIjoiXC9HeHJRWTR3RUtuazFPRFI1TEpoaXhHREk5NGVOTUJYenhTTDI2MWlFZEVaYnp1OFJrRk9yNzBGNWN2THdMNG14bVZXUGdjOWJmZm1ES25xOHU4aDZRPT0iLCJtYWMiOiIwODViN2M5OWMzMGI4MDRlYjUwZmE3YzU1ZjJkNDA3ZDZmMmMwMjk3MGNhY2VkYTEwODVmNDkzYTcxNjIzNmQ5In0='


headers = {
    'User-Agent': agent,
    'Cookie':cookies,
    'Upgrade-Insecure-Requests':	"1",
    'Cache-Control':"max-age=0",
    'Connection':	"keep-alive"

}

html=requests.get(TARGET_URL)
# print html.url
content = html.text
for i in range(0,100):

    items = findItems(content)
    post_data = {
            'token':items
        }
    data = urllib.urlencode(post_data)
    req_url = requests.get(TARGET_URL,post_data,headers=headers)
    content = req_url.text
    print content

