<?php
session_start(); 
 
function msectime() {
    list($msec, $sec) = explode(' ', microtime());
    $msectime =  (float)sprintf('%.0f', (floatval($msec) + floatval($sec)) * 1000);
    return $msectime;
}

if(!isset($_SESSION['time']))
{
	$_SESSION['time']=msectime();
}
else
{
	$new_time=msectime();
	$time=$new_time-$_SESSION['time'];
	$_SESSION['time']=$new_time;
}

if($time>1000)
{
	echo "Try your fastest!";
	
}
else
{

	$answer=$_POST['Flag'];
	$answer2=$_GET['Flag'];
	
	if(isset($answer2))
	{
		$answer=$answer2;
	}
	if(isset($answer))
	{
		
	 	if($answer==$_SESSION['vFlag'])
		{
			echo "tCTF{Sp1der_1s_Interest1ng}";
		}
		else
		{
			echo "Try your fastest!";

		}
	}
	else
	{
	     echo "Try your fastest!";

	}

}
$str="QWERTYUIOPASDFGHJKLZXCVBNM1234567890qwertyuiopasdfghjklzxcvbnm";
str_shuffle($str);
$flag=substr(str_shuffle($str),26,10);
$flag_base64=base64_encode($flag);
header("Flag:".$flag_base64);
$_SESSION['vFlag']=$flag;
