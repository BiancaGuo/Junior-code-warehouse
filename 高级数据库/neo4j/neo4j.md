# Neo4j —— 图数据库

### 小组成员：郭韵婷、宋雅文、刘彦延
---

# 一、概述

---

Neo4j is an open source, NoSQL graph management system written using Java and Scala. Neo Technologies sponsors and oversees the development of Neo4j and has a huge influence on its development roadmap. Neo4j is one of the very few ACID compliance NoSQL databases as it uses a proprietary, labeled property graph data model to represent and store data both in memory and at the storage level.
Some use cases for Neo4j include fraud detection, analytics, social networks, recommendations, scientific research, and routing. Since being made open source in 2007, the popularity of Neo4j has increased steadily and has been downloaded more than a million times. Well written guides, video tutorials, and online documentation makes it easy for new developers to adopt Neo4j. The following sections in this chapter will give insights into Neo4j's architecture and will help in the transition from a user to a contributor.

---

# 二、历史

---

- ## The history of graph database

[![](https://i.imgur.com/aBLxO5U.jpg)](https://www.youtube.com/watch?v=CDZXC5XHfEI)

---
![](https://i.imgur.com/AvajnAW.png)

* Version 1.0 was released in February 2010.[11]

* Neo4j version 2.0 was released in December 2013.[12]

* Neo4j version 3.0 was released in April 2016.

* What's new in neo4j 3.3

	* Data import uses 40% less memory
	* adds page caching for large imports
	* write speed is 55% faster than Neo4j 3.2 and nearly 350% faster than version 2.3
	* more graph algorithms

---

# 三、所使用的数据库模型


* ## Neo4j图数据库遵循属性图模型来存储和管理其数据。

---


## 属性图模型规则

* 表示节点，关系和属性中的数据

* 节点和关系都包含属性

* 关系连接节点

* 属性是键值对

* 节点用圆圈表示，关系用方向键表示。

* 关系具有方向：单向和双向。

* 每个关系包含“开始节点”或“从节点”和“到节点”或“结束节点”

---

* 节点

	* 用于表示实体，可以添加标签和分组

	![](https://i.imgur.com/J3ABTO7.jpg)
    
    （只有一个属性，属性名是name,属性值是Marko）

---

* 关系

	* 关系是定向的
	* 关系是有方向性的
	* 一个关系连接两个节点，必须有一个开始节点和结束节点
	* 节点之间的关系是图数据库很重要的一部分。通过关系可以找到很多关联的数据，比如节点集合，关系集合以及他们的属性集合。
	* 对一个节点来说，与他关联的关系看起来有输入/输出两个方向，这个特性对于我们遍历图非常有帮助
		
	![](https://i.imgur.com/oeSrMjQ.jpg)
    
    （有两种关系的最简单的社会化网络图 ）

---

* 属性

	* 节点和关系都可以设置自己的属性。
	* 属性由Key-Value键值对组成，键名是字符串。属性可以是原始值或者原始值类型的一个数组

	![](https://i.imgur.com/9uSlttb.jpg)

---

* 路径

	* 由至少一个节点，通过各种关系连接组成，经常是作为一个查询或遍历的结果

	![](https://i.imgur.com/QxVoc6g.jpg)

---

* 遍历（用Traversal进行数据库查询）

	* 按照一定的规则，更随它们的关系，访问关联的节点集合。Neo4j提供了遍历的API，能够让用户指定遍历规则（例如：宽度优先遍历还是深度优先遍历）
	
---	

# 四、基本操作

* ### Try it ：学习创建电影关系图
   * 将电影、电影导演、演员之间的复杂网状关系作为蓝本，使用Neo4j创建三者关系的图结构

---

## 1、 创建图数据

---

* 创建电影节点

	CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})

---

* 创建人物节点


    CREATE (Keanu:Person {name:'Keanu Reeves', born:1964})
    CREATE (Carrie:Person {name:'Carrie-Anne Moss', born:1967})
    CREATE (Laurence:Person {name:'Laurence Fishburne', born:1961})
    CREATE (Hugo:Person {name:'Hugo Weaving', born:1960})
    CREATE (LillyW:Person {name:'Lilly Wachowski', born:1967})
    CREATE (LanaW:Person {name:'Lana Wachowski', born:1965})
    CREATE (JoelS:Person {name:'Joel Silver', born:1952})

---

* 创建演员、导演、制片商关系

	CREATE
        (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrix),
        (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrix),
        (Laurence)-[:ACTED_IN {roles:['Morpheus']}]->(TheMatrix),
        (Hugo)-[:ACTED_IN {roles:['Agent Smith']}]->(TheMatrix),
        (LillyW)-[:DIRECTED]->(TheMatrix),
        (LanaW)-[:DIRECTED]->(TheMatrix),
        (JoelS)-[:PRODUCED]->(TheMatrix)

---

## 2、检索结点

---

* 查找名为 “Tom Hanks” 的人物

		MATCH (tom {name: "Tom Hanks"}) RETURN tom
        
* 查找电影 “Cloud Atlas”

		MATCH (cloudAtlas {title: "Cloud Atlas"}) RETURN cloudAtlas

---

* 随机查找10个人物的名字

		MATCH (people:Person) RETURN people.name LIMIT 10
        
* 查找多个电影

		MATCH (nineties:Movie) WHERE nineties.released >= 1990 AND nineties.released < 2000 RETURN nineties.title

---

## 3、查询关系

---

*  查找“Tom Hanks”参演过的电影的名称

		MATCH (tom:Person {name: "Tom Hanks"})-[:ACTED_IN]->(tomHanksMovies) RETURN tom,tomHanksMovies
---

* 查找谁导演了电影“Cloud Atlas”

		MATCH (cloudAtlas {title: "Cloud Atlas"})<-[:DIRECTED]-(directors) RETURN directors.name
        
---

* 查找与“Tom Hanks”同出演过电影的人

		MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) RETURN coActors.name

---

## 4、查询关系路径

---

* 查找与演员“Kevin Bacon”存在4条及以内关系的任何演员和电影

		MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..4]-(hollywood) RETURN DISTINCT hollywood
        
---


* 查找与演员“Kevin Bacon”与“Meg Ryan”之间的最短关系路径
		
        MATCH p=shortestPath(
          (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
        )
        RETURN p
        
---

## 5、删除

---

		

* 删除关系：由于宋青书背叛武当,宋远桥和他断绝了父子关系

		MATCH (p1:武当{name:'宋远桥'})-[r:父子]->(p2:武当{name:'宋青书'}) delete r
        

* 删除节点和节点关系：

		MATCH (p1:武当{name:'宋远桥'})-[r:父子]->(p2:武当{name:'宋青书'}) delete p1,r,p2
        
* 删除所有节点

		match (n) detach delete n