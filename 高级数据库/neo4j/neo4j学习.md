## 开源图形数据库 —— neo4j

### 一、安装

* 运行install.sh

		#!/bin/bash
		# This script installs default Java Machine and latest version of enterprise Neo4j on your machine
		# This script is compatible with Debian(8+) and Ubuntu (14.04+) as on Dec-21-2016
		
		# update your distro
		sudo apt-get update
		
		# install the default JRE (required for running Neo4j)
		sudo apt-get install default-jre -y
		
		# the following commands add the neo4j repo to apt-get
		wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
		echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list
		
		# get packages from the Neo4j list. I know it's been run before, but I like to
		# do this twice just to ensure nothing got left out earlier
		sudo apt-get update
		
		# Gets Neo4j enterprise. To get latest version use sudo apt-get install neo4j-enterprise
		# sudo apt-get install neo4j-enterprise=x.x.x, e.g. sudo apt-get install neo4j-enterprise=3.1.0
		sudo apt-get install neo4j-enterprise=3.1.3 -y
		
		# Install vim
		sudo apt-get install vim -y
		
		echo "in case of 3.1.3, the conf file can be edited by running vim /etc/neo4j/neo4j.conf"


* 修改配置文件使该数据库控制界面能通过机器内网IP访问

		sudo vim /etc/neo4j/neo4j.conf

	* 将 `dbms.connectors.default_listen_address=0.0.0.0` 项注释打开

* 修改配置文件将数据库的目录更改到另一个地方，避免因权限问题影响增加、修改数据文件和日志文件的情况

		sudo vim /etc/neo4j/neo4j.conf

	* 修改 `dbms.directories.data= <new folder>`

### 一、概述


Neo4j is an open source, NoSQL graph management system written using Java and Scala. Neo Technologies sponsors and oversees the development of Neo4j and has a huge influence on its development roadmap. Neo4j is one of the very few ACID compliance NoSQL databases as it uses a proprietary, labeled property graph data model to represent and store data both in memory and at the storage level.
Some use cases for Neo4j include fraud detection, analytics, social networks, recommendations, scientific research, and routing. Since being made open source in 2007, the popularity of Neo4j has increased steadily and has been downloaded more than a million times. Well written guides, video tutorials, and online documentation makes it easy for new developers to adopt Neo4j. The following sections in this chapter will give insights into Neo4j's architecture and will help in the transition from a user to a contributor.



### 二、历史


[![](https://i.imgur.com/aBLxO5U.jpg)](https://www.youtube.com/watch?v=CDZXC5XHfEI)


![](https://i.imgur.com/AvajnAW.png)

* Version 1.0 was released in February 2010.[11]

* Neo4j version 2.0 was released in December 2013.[12]

* Neo4j version 3.0 was released in April 2016.

* What's new in neo4j 3.3

	* Data import uses 40% less memory
	* adds page caching for large imports
	* write speed is 55% faster than Neo4j 3.2 and nearly 350% faster than version 2.3
	* more graph algorithms


### 三、所使用的数据库模型

* 图数据库模型

	* 节点
		* 用于表示实体

		![](https://i.imgur.com/J3ABTO7.jpg)

	* 关系
	
		* 节点之间的关系是图数据库很重要的一部分。通过关系可以找到很多关联的数据，比如节点集合，关系集合以及他们的属性集合。
		* 对一个节点来说，与他关联的关系看起来有输入/输出两个方向，这个特性对于我们遍历图非常有帮助
		
		![](https://i.imgur.com/oeSrMjQ.jpg)

	* 属性

		* 节点和关系都可以设置自己的属性。
		* 属性由Key-Value键值对组成，键名是字符串。属性可以是原始值或者原始值类型的一个数组

		![](https://i.imgur.com/9uSlttb.jpg)

	* 路径

		* 由至少一个节点，通过各种关系连接组成，经常是作为一个查询或遍历的结果

		![](https://i.imgur.com/QxVoc6g.jpg)

	* 遍历（Traversal）

		* 
	
		
	

### 四、查询语言