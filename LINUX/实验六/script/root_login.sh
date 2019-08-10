#!/bin/bash
source  global_var.sh



#在本地系统生成密钥
if [ ! -f "$HOME/.ssh/id_rsa.pub" ];
then
mkdir $HOME/.ssh
/usr/bin/expect << EOF
set timeout -1
spawn ssh-keygen -t rsa
expect { 
"file"   {send "\r";exp_continue }
"passphrase" { send "\r" ; exp_continue }
"passphrase" { send "\r";}
}
expect eof
EOF
fi
sudo systemctl restart sshd

#获取配置文件到本地
if [ ! -d "config/" ];then
sudo mkdir config/
else
sudo cp -rp config/ config_old/
sudo rm -rf config/
sudo mkdir config/
fi
sudo git clone https://github.com/CUCCS/2015-linux-public-BiancaGuo.git -b 实验六 config/



#连接目标系统普通账户
/usr/bin/expect << EOF

#永不超时
set timeout -1
spawn ssh -o StrictHostKeyChecking=no -l $AIM_USER_GENERAL $HOST
expect "password:"   
send "$AIM_USER_GENERAL_PASS\r"
sleep 1
#对ssh配置文件进行替换
send "mkdir config_bianca/\r"
send "git clone https://github.com/CUCCS/2015-linux-public-BiancaGuo.git -b 实验六 config_bianca/\r"
send "sudo cp config_bianca/实验六/config/sshd_config /etc/ssh/sshd_config\r"
expect "password" 
send "$AIM_USER_GENERAL_PASS\r"
sleep 1
send "sudo systemctl restart sshd\r"
sleep 1
send "sudo rm -rf config_bianca/\r"
#expect "password" 
#send "$aim_user_general_pass\r"
#重设root密码
send "sudo passwd root\r"
expect "*password:" 
send "$RPSW\r"
expect "*password:"
send "$RPSW\r"
send "exit\r"
expect eof

#退出远程普通用户
EOF

#公钥copy
/usr/bin/expect << EOF
set timeout -1
spawn ssh-copy-id -o StrictHostKeyChecking=no -i "$HOME/.ssh/id_rsa.pub" ${AIM_USER_ROOT}@${HOST} -p ${PORT}
expect "*password:"
send "$RPSW\r"
expect eof
EOF
#root登录
#ssh -p 22 'root@192.168.227.5'
#拷贝所有配置文件到目标系统
#scp -r config/实验六/config/ ${aim_user_root}@${hosts}:~/config
#done
