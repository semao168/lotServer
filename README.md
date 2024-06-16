## 用户安装  


 > 更换安装（更换锐速内核）
```
yum install wget -y && wget --no-check-certificate -O ruisu.sh https://raw.githubusercontent.com/semao168/lotServer/main/ruisu.sh && bash ruisu.sh
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
## Centos 7开机启动  和设置默认内核
```

echo "/usr/bin/sh /appex/bin/lotServer.sh restart" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

grubby --set-default /boot/vmlinuz-3.10.0-229.1.2.el7.x86_64
```

## CentOS6和CentOS7 一键更换内核，一键安装锐速[lotServer][serverSpeeder ]

 支持KVM VMWARE Hyper-v XEN 虚拟化技术

CentOS6和CentOS7 一键更换内核，完成后会重启
```
wget --no-check-certificate https://blog.asuhu.com/sh/ruisu.sh
bash ruisu.sh
```
CentOS6和CentOS更换内核完成后一键安装锐速[lotServer]  感谢V大
```
wget --no-check-certificate -O appex.sh https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh && chmod +x appex.sh && bash appex.sh install
```