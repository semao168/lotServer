#!/bin/bash

# 检查用户是否为root
if [ "$(id -u)" != "0" ]; then
   echo "此脚本必须由root用户运行" 1>&2
   exit 1
fi

# 检查是否已安装openssh-server
if ! rpm -qa | grep -qw openssh-server; then
    echo "openssh-server未安装。安装中..."
    yum install -y openssh-server
fi

# 询问新的SSH端口
read -p '请输入新的SSH端口号: ' port

# 备份原始的sshd_config文件
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 修改SSH端口
sed -i "s/^#Port 22/Port $port/g" /etc/ssh/sshd_config

#临时关闭SElinux
setenforce 0
#sed修改配置文件，实现永久禁用selinux
sed -i "s/SELINUX=enforcing/SELINUX=disable/g" /etc/selinux/config

echo "添加新端口到防火墙 $port..."
firewall-cmd --zone=public --add-port="$port"/tcp --permanent

echo "SSH端口已经更改为 $port. 重启SSH服务中..."


# 重启SSH服务
systemctl restart sshd.service

echo "SSH服务已经重启. 新的SSH端口为 $port."

# 结束脚本
exit 0