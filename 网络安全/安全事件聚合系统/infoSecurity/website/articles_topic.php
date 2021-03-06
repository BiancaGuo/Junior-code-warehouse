<!DOCTYPE html>
<html lang="zh-cmn-Hans">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <title>Home</title>

        <!-- Bootstrap -->
        <link rel="stylesheet" href="assets/css/bootstrap/bootstrap.min.css">

        <!-- Optional theme -->
        <link rel="stylesheet" href="assets/css/bootstrap/bootstrap-theme.min.css">

        <!-- Custom css -->
        <link rel="stylesheet" href="assets/css/style.css">
        
        <!-- Font Awesome -->
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="assets/css/ionicons.min.css">
        
        <!-- Flexslider -->
        <link rel="stylesheet" href="assets/css/flexslider.css">
        
        <!-- Owl -->
        <link rel="stylesheet" href="assets/css/owl.carousel.css">
        
        <!-- Magnific Popup -->
        <link rel="stylesheet" href="assets/css/magnific-popup.css">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <script>
            function changeTime(obj)
            {
                 // var Items = document.getElementsByClassName("choices");
                 var x=document.getElementById("time");
                 x.innerHTML=obj; 
                 // alert(obj);
            }
            function changeField(obj)
            {
                 // var Items = document.getElementsByClassName("choices");
                 var x=document.getElementById("Field");
                 x.innerHTML=obj; 
                 // alert(obj);
            }
            function changeSource(obj)
            {
                 // var Items = document.getElementsByClassName("choices");
                 var x=document.getElementById("Source");
                 x.innerHTML=obj; 
                 // alert(obj);
            }
        </script>
    </head>
    <body>
      
        <!--  loader  -->
        <div id="myloader">
            <div class="loader">
                <div class="grid">
                    <div class="cube cube1"></div>
                    <div class="cube cube2"></div>
                    <div class="cube cube3"></div>
                    <div class="cube cube4"></div>
                    <div class="cube cube5"></div>
                    <div class="cube cube6"></div>
                    <div class="cube cube7"></div>
                    <div class="cube cube8"></div>
                    <div class="cube cube9"></div>
                </div>
            </div>
        </div>
        
        <!--  Header & Menu  -->
        <header id="header">
            <div class="top-nav">
                <!--  Header Logo  -->
                <div id="logo">
                    <a class="navbar-brand" href="index.html">
                        <img src="assets/img/logo.png" class="normal" alt="logo">
                        <img src="assets/img/logo@2x.png" class="retina" alt="logo">
                    </a>
                </div>
                <!--  END Header Logo  -->
                <div class="secondary-menu">
                    <ul>
                        <li>聚焦安全领域，把握安全动态</li>
                       
                        <!-- Search Icon -->
                        <li class="search">
                            <i class="fa fa-search" aria-hidden="true"></i>

                                    
                               
                        </li>
                    </ul>
                </div>
            </div>
            <nav class="navbar navbar-default">
                <!--  Classic menu, responsive menu classic  -->
              
                <div class="dropdown">
                    <button class="btn dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
                    <text id="time">时间不限</text>
                    <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation"><a href="articles.php?time=1" role="menuitem" tabindex="-1" onclick="changeTime('时间不限')" >时间不限</a></li>
                    <li role="presentation"><a href="articles.php?time=2" role="menuitem" tabindex="-1" onclick="changeTime('一周之内')">一周之内</a></li>
                    <li role="presentation"><a href="articles.php?time=3" role="menuitem" tabindex="-1" onclick="changeTime('一月只内')">一月只内</a></li>
                    <li role="presentation"><a href="articles.php?time=4" role="menuitem" tabindex="-1" onclick="changeTime('一年之内')">一年之内</a></li>
                    </ul>
                </div>
               
                <div class="dropdown">
                    <button class="btn dropdown-toggle" type="button" id="dropdownMenu2" data-toggle="dropdown">
                    <text id="Field">领域不限</text>
                    <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li role="presentation"><a href="articles.php?area=1" role="menuitem" tabindex="-1" onclick="changeField('领域不限')">领域不限</a></li>
                    <li role="presentation"><a href="articles.php?area=A_前端" role="menuitem" tabindex="-1" onclick="changeField('前端')">前端</a></li>
                    <li role="presentation"><a href="articles.php?area=B_后端" role="menuitem" tabindex="-1" onclick="changeField('后端')">后端</a></li>
                    <li role="presentation"><a href="articles.php?area=C_移动端" role="menuitem" tabindex="-1" onclick="changeField('移动端')">移动端</a></li>
                    <li role="presentation"><a href="articles.php?area=D_浏览器" role="menuitem" tabindex="-1" onclick="changeField('浏览器')">浏览器</a></li>
                    <li role="presentation"><a href="articles.php?area=E_应用软件" role="menuitem" tabindex="-1" onclick="changeField('应用软件')">应用软件</a></li>
                    <!-- <li role="presentation" class="divider"></li> -->
                    <li role="presentation"><a role="menuitem" tabindex="-1" onclick="changeField('操作系统')">操作系统</a></li>
                    </ul>
                </div>
                
                <!--  END Classic menu, responsive menu classic  -->
                <!--  Button for Responsive Menu Classic  -->
                <div id="menu-responsive-classic">
                    <div class="menu-button">
                        <span class="bar bar-1"></span>
                        <span class="bar bar-2"></span>
                        <span class="bar bar-3"></span>
                    </div>
                </div>
                <!--  END Button for Responsive Menu Classic  -->
                
            </nav>
            <div id="header-searchform">
                <form class="search-form">
                    <div class="form-input">
                        <input type="text" placeholder="Search...">
                        <span class="form-button-close">
                            <button type="button"><i class="material-icons">close</i></button>
                        </span>
                        <span class="form-button">
                            <button type="button">Search</button>
                        </span>
                    </div>
                </form>
            </div>
        </header>
        <!--  END Header & Menu  -->
            
        <!--  Main Wrap  -->
        <div id="main-wrap">
            <!--  Page Content  -->
				  <!--  END Page Header  -->
                <div id="home-wrap" class="content-section fullpage-wrap">
            	  <?php

					    include('pdo.php');
						static $time = 1;
						static $area = 1;
						$pdo = new DBPDO;
						$perNumber=20;
						$page=$_GET['page']; //获得当前的页面值  
						if (!isset($page)) {  
						 	$page=1;  
						} 
						if (!isset($time)) { 
						
						}
						else
						{
							$time=intval($_GET['time']);
						}
						if (!isset($area)) { 
							
						}
						else
						{
							$area=intval($_GET['area']);
						}
							
						$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta`";
						$count=$pdo->count($sql);
						//$count=5;
						
						$total_pages=ceil($count/$perNumber);
						$startCount=($page-1)*$perNumber; 
						
						if($time==1)
						{
							if($area==1)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta`";
							}
							if($area==2)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'A_前端'";
							}
							if($area==3)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'B_后端'";
							}
							if($area==4)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'C_移动端'";
							}
							if($area==5)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'E_应用软件'";
							}
							if($area==6)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'F_操作系统'";
							}
						}
						if($time==2)
						{
							if($area==1)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
							if($area==2)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'A_前端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
							if($area==3)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'B_后端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
							if($area==4)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'C_移动端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
							if($area==5)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'E_应用软件' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
							if($area==6)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'F_操作系统' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=7";
							}
						}
						if($time==3)
						{
							if($area==1)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
							if($area==2)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'A_前端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
							if($area==3)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'B_后端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
							if($area==4)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'C_移动端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
							if($area==5)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'E_应用软件' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
							if($area==6)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'F_操作系统' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=31";
							}
						}
						if($time==4)
						{
							if($area==1)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
							if($area==2)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'A_前端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
							if($area==3)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'B_后端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
							if($area==4)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'C_移动端' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
							if($area==5)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'E_应用软件' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
							if($area==6)
							{
								$sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` WHERE `topic` = 'F_操作系统' AND CURDATE()-DATE_FORMAT(publish_time, '%Y-%m-%d')<=365";
							}
						}
					
						
						//$sql = $sql = "SELECT * FROM `SpiderFor36ker`，`SpiderFor51CTO`，`SpiderForCnbeta` limit $startCount,$perNumber"; //根据前面的计算出开始的记录和记录数  
						$result=$pdo->select($sql);
						foreach($result as $row){
							$id=$row['id'];
							$abstraction=$row['abstraction'];
							$news_url=$row['news_url'];
							$publish_time=$row['publish_time'];
							$title=$row['title'];
							$topic=$row['topic'];
							echo '<div class="container">
                        			<!-- Service -->
                        			<div class="row no-margin padding-lg">
                            				<div class="col-md-4 padding-leftright-null">
                               				<div class="text padding-topbottom-null">
                                   				<h2 class="margin-bottom-null left">'.$title.'</h2>
                               				</div>
                           				</div>
                            			<div class="col-md-8 padding-leftright-null">
                                		<div class="text padding-topbottom-null">
                                    		<h3>'.$publish_time.'</h3>
                                    		<p class="margin-bottom-null">'.$abstraction.'</p>
                                		</div>
                            			</div>
                        			</div>
                        			<!-- END Service -->
                    			</div>';
							
						}

				     ?>
                    
                
                 <?php
						
					if ($page != 1) { //页数不等于1  
				     ?>  
						<a href="articles.php?page=<?php echo $page - 1;?>">上一页</a> <!--显示上一页-->  
				   <?php  
	
						}  
					?>
					<a href="articles.php?page=<?php echo 1;?>"><?php echo 1;?></a> 
					<?php
						
					if($page-1>1&&$total_pages-$page>1)
					{
					?>
						<a href="articles.php?page=<?php echo $page-2;?>"><?php echo '...';?></a>
						<a href="articles.php?page=<?php echo $page-1;?>"><?php echo $page-1;?></a> 
						<a href="articles.php?page=<?php echo $page;?>"><?php echo $page;?></a> 
						<a href="articles.php?page=<?php echo $page+1;?>"><?php echo $page+1;?></a>
						<a href="articles.php?page=<?php echo $page+2;?>"><?php echo '...';?></a>
					<?php
					}
					if($page==2)
					{
					?>
						<a href="articles.php?page=<?php echo $page;?>"><?php echo $page;?></a>
						<a href="articles.php?page=<?php echo $page+1;?>"><?php echo $page+1;?></a>
						<a href="articles.php?page=<?php echo $page+2;?>"><?php echo '...';?></a>
					<?php
					}
					?>


					<?php	
					if($total_pages-$page==1)
					{
					?>
						<a href="articles.php?page=<?php echo $page-2;?>"><?php echo '...';?></a>
						<a href="articles.php?page=<?php echo $page-1;?>"><?php echo $page-1;?></a> 
						<a href="articles.php?page=<?php echo $page;?>"><?php echo $page;?></a> 
					<?php
					}
					?>

					<?php	
					if($page==1)
					{
					?>
						<a href="articles.php?page=<?php echo $page+1;?>"><?php echo $page+1;?></a> 
						<a href="articles.php?page=<?php echo $page+2;?>"><?php echo '...';?></a> 
					<?php
					}
					?>

					<?php	
					if($page==$total_pages)
					{
					?>
						<a href="articles.php?page=<?php echo $page-2;?>"><?php echo '...';?></a> 
						<a href="articles.php?page=<?php echo $page-1;?>"><?php echo $page-1;?></a> 
						
					<?php
					}
					?>
					<a href="articles.php?page=<?php echo $total_pages;?>"><?php echo $total_pages;?></a>   
					
				   <?php  
					if ($page<$total_pages) { //如果page小于总页数,显示下一页链接  
					?>  
					

						<a href="articles.php?page=<?php echo $page + 1;?>">下一页</a>  
					<?php  
						}   

				   	?>
					
                </div>
            </div>
            <!--  END Page Content -->
        </div>
        <!--  Main Wrap  -->
        

        <!--  Footer  -->
        <div id="copy">
            <div class="container">
                <div class="row no-margin">
                    <div class="col-md-6 text">
                        <p>Copyright &copy; 2017.Biancaguo All rights reserved.</p>
                    </div>
                   
                </div>
            </div>
        </div>
        <!--  END Footer. Class fixed for fixed footer  -->
        
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="assets/js/jquery.min.js"></script>
        <!-- All js library -->
        <script src="assets/js/bootstrap/bootstrap.min.js"></script>
        <script src="assets/js/jquery.flexslider-min.js"></script>
        <script src="assets/js/owl.carousel.min.js"></script>
        <script src="assets/js/isotope.min.js"></script>
        <script src="assets/js/jquery.magnific-popup.min.js"></script>
       
        <script src="assets/js/jquery.scrollTo.min.js"></script>
        <script src="assets/js/smooth.scroll.min.js"></script>
        <script src="assets/js/jquery.appear.js"></script>
        <script src="assets/js/jquery.countTo.js"></script>
        <script src="assets/js/jquery.scrolly.js"></script>
        <script src="assets/js/plugins-scroll.js"></script>
        <script src="assets/js/imagesloaded.min.js"></script>
        <script src="assets/js/pace.min.js"></script>
        <script src="assets/js/main.js"></script>
    </body>
</html>
