#!/bin/bash
cores=$(cat /proc/cpuinfo | grep 'model name'| wc -l)
cname=$( cat /proc/cpuinfo | grep 'model name' | uniq | awk -F : '{print $2}')
tram=$( free -m | awk '/Mem/ {print $2}' )
swap=$( free -m | awk '/Swap/ {print $2}' )

#如果没有/etc/redhat-release，则退出
if [ ! -e '/etc/redhat-release' ]; then
echo "Only Support CentOS6 CentOS7 RHEL6 RHEL7"
exit
fi

#检测版本6还是7
if  [ -n "$(grep ' 7\.' /etc/redhat-release)" ] ;then
CentOS_RHEL_version=7
elif
[ -n "$(grep ' 6\.' /etc/redhat-release)" ]; then
CentOS_RHEL_version=6
fi

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

#清屏
clear

next
echo "总内存  : $tram MB"
echo "总虚拟Swap : $swap MB"
echo "CPU型号            : $cname"
echo "核心数量      : $cores"
next

if [ "$CentOS_RHEL_version" -eq 6 ];then
rpm -ivh https://raw.githubusercontent.com/semao168/lotServer/main/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm
rpm -ivh https://raw.githubusercontent.com/semao168/lotServer/main/kernel-2.6.32-504.3.3.el6.x86_64.rpm --force
number=$(cat /boot/grub/grub.conf | awk '$1=="title" {print i++ " : " $NF}'|grep '2.6.32-504'|awk '{print $1}')
sed -i "s/^default=.*/default=$number/g" /boot/grub/grub.conf
echo "内核安装完毕,3秒后将自动重启..."
echo "重启后查看内核版本grubby --default-kernel"
sleep 3
reboot
else
rpm -ivh https://raw.githubusercontent.com/semao168/lotServer/main/kernel-3.10.0-229.1.2.el7.x86_64.rpm  --nodeps --force
grub2-set-default `awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep '(3.10.0-229.1.2.el7.x86_64) 7 (Core)'|awk '{print $1}'`
echo "内核安装完毕,3秒后将自动重启..."
echo "重启后查看内核版本grubby --default-kernel"
sleep 3
reboot
fi