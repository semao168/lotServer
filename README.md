## 用户安装  

 > 修改SSH端口
```
yum install wget -y && wget -O sshd.sh "https://raw.githubusercontent.com/semao168/lotServer/main/sshd.sh" && chmod +x sshd.sh && ./sshd.sh
```



 > 更换安装（更换锐速内核）
```
wget -O ruisu.sh --no-check-certificate https://raw.githubusercontent.com/semao168/lotServer/main/ruisu.sh && chmod +x ruisu.sh && bash ruisu.sh
```

 ~~（脚本内置许可证的接口为我自己的接口了，有效期9999年那种 笑）~~
 > 常规自动安装（推荐，自动检测内核）
```
bash <(wget --no-check-certificate -qO-  https://raw.githubusercontent.com/semao168/lotServer/main/lotServerInstall.sh) install
```

 > 指定内核安装（centos6选2.6.32-754.el6.x86_64，centos7选3.10.0-957.el7.x86_64）
```
bash <(wget --no-check-certificate -qO-  https://raw.githubusercontent.com/semao168/lotServer/main/lotServerInstall.sh) install 2.6.32-754.el6.x86_64
```

 > 完全卸载
```
bash <(wget --no-check-certificate -qO-  https://raw.githubusercontent.com/semao168/lotServer/main/lotServerInstall.sh) uninstall
```
***
***
## 使用方法
- 启动命令 /appex/bin/lotServer.sh start
- 停止加速 /appex/bin/lotServer.sh stop
- 状态查询 /appex/bin/lotServer.sh status
- 重新启动 /appex/bin/lotServer.sh restart

***
***
## Centos 7开机启动
```
echo "/usr/bin/sh /appex/bin/lotServer.sh restart" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
```

 > 腾讯TCPA单边加速
```
yum install wget -y && wget -O tcpa.sh "https://raw.githubusercontent.com/semao168/lotServer/main/TCPAspeed/tcpa.sh" && chmod +x tcpa.sh && ./tcpa.sh
```
***
##
默认80 443 8080端口 以下代码自己添加端口
重启后安装自动完成,lsmod|grep tcpa查看是否开启成功.
##
```
vim /usr/local/storage/tcpav2/start.sh
```
***
***
## 使用方法
- 启动命令 /usr/local/storage/tcpav2/start.sh
- 停止加速 /usr/local/storage/tcpav2/stop.sh

***