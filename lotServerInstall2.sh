#!/bin/bash

function Welcome()
{
clear
echo -n "                      Local Time :   " && date "+%F [%T]       ";
echo "            ======================================================";
echo "            |                      lotServer                     |";
echo "            |                                     for Linux      |";
echo "            |----------------------------------------------------|";
echo "            |                                   --By sakura      |";
echo "            ======================================================";
echo "";
root_check;
mkdir -p /tmp
cd /tmp
}

function root_check()
{
if [[ $EUID -ne 0 ]]; then
  echo "错误：此脚本必须以 root 身份运行！" 1>&2
  exit 1
fi
}

function pause()
{
read -n 1 -p "按 Enter 继续..." INP
if [ "$INP" != '' ] ; then
  echo -ne '\b \n'
  echo "";
fi
}

function dep_check()
{
  apt-get >/dev/null 2>&1
  [ $? -le '1' ] && apt-get -y -qq install sed grep gawk ethtool >/dev/null 2>&1
  yum >/dev/null 2>&1
  [ $? -le '1' ] && yum -y -q install sed grep gawk ethtool >/dev/null 2>&1
}

function acce_check()
{
  local IFS='.'
  read ver01 ver02 ver03 ver04 <<<"$1"
  sum01=$[$ver01*2**32]
  sum02=$[$ver02*2**16]
  sum03=$[$ver03*2**8]
  sum04=$[$ver04*2**0]
  sum=$[$sum01+$sum02+$sum03+$sum04]
  [ "$sum" -gt '12885627914' ] && echo "1" || echo "0"
}

function Install()
{
  Welcome;
  echo '正在检测lotServer环境...';
  Uninstall;
  dep_check;
  [ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
  [ -f /etc/os-release ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
  [ -f /etc/lsb-release ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)
  KNB=$(getconf LONG_BIT)
  [ ! -f /proc/net/dev ] && echo -ne "我找不到网络设备! \n\n" && exit 1;
  Eth_List=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet' |awk 'NR==1 {print $0}'`
  [ -z "$Eth_List" ] && echo "我找不到公共以太网服务器！ " && exit 1
  Eth=$(echo "$Eth_List" |head -n1)
  [ -z "$Eth" ] && Uninstall "错误！未找到有效的网卡. "
  Mac=$(cat /sys/class/net/${Eth}/address)
  [ -z "$Mac" ] && Uninstall "错误！未找到 mac 代码. "

  Welcome;
  wget --no-check-certificate -qO "/tmp/lotServer.tar" "https://raw.githubusercontent.com/semao168/lotServer/main/lotServer.tar"
  tar -xvf "/tmp/lotServer.tar" -C /tmp
  acce_ver=$(acce_check ${KNV})

  echo "acce_ver:${acce_ver}  MAC:${Mac}"

  # 如果有自己搭建的或者api失效，这里修改成你自己的api
  wget --no-check-certificate -qO "${AcceTmp}/etc/apx.lic" "http://103.144.149.225/keygen.php?ver=${acce_ver}&mac=${Mac}"
  [ "$(du -b ${AcceTmp}/etc/apx.lic |cut -f1)" -lt '152' ] && Uninstall "错误！我无法为您生成许可证，请稍后重试. "
  echo "Lic generate success! "
  sed -i "s/^accif\=.*/accif\=\"$Eth\"/" "${AcceTmp}/etc/config"
  sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$AcceBin\"/" "${AcceTmp}/etc/config"
  bash "${AcceRoot}/install.sh" -in 10000000 -out 10000000 -t 0 -r -b -i ${Eth}
  rm -rf /tmp/*lotServer* >/dev/null 2>&1
  Welcome;
  if [ -f /appex/bin/serverSpeeder.sh ]; then
    bash /appex/bin/serverSpeeder.sh status
  elif [ -f /appex/bin/lotServer.sh ]; then
    bash /appex/bin/lotServer.sh status
 chmod +x /etc/rc.d/rc.local
isExit=$(grep -q   "su - root -c '/appex/bin/lotServer.sh restart'"  /etc/rc.local && echo "yes" || echo "no")
FIND_FILE="/etc/rc.local"
FIND_STR="/appex/bin/lotServer.sh restart"
# 判断匹配函数，匹配函数不为0，则包含给定字符
if [ `grep -c "$FIND_STR" $FIND_FILE` -ne '0' ];then
echo "自启动已经存在，请查看vi /etc/rc.local"
else
echo "添加开机自启动成功...自启动配置请查看vi /etc/rc.local"
cat>>/etc/rc.local<<EOF
/appex/bin/lotServer.sh restart
EOF
fi
    echo -e "使用方法\n
    启动命令 /appex/bin/lotServer.sh start\n
    停止加速 /appex/bin/lotServer.sh stop\n
    状态查询 /appex/bin/lotServer.sh status\n
    重新启动 /appex/bin/lotServer.sh restart\n
"
  fi
  exit 0
}

function Uninstall()
{
    echo '正在卸载lotServer环境...';
  AppexName="lotServer"
  [ -e /appex ] && chattr -R -i /appex >/dev/null 2>&1
  if [ -d /etc/rc.d ]; then
    rm -rf /etc/rc.d/init.d/serverSpeeder >/dev/null 2>&1
    rm -rf /etc/rc.d/rc*.d/*serverSpeeder >/dev/null 2>&1
    rm -rf /etc/rc.d/init.d/lotServer >/dev/null 2>&1
    rm -rf /etc/rc.d/rc*.d/*lotServer >/dev/null 2>&1
  fi
  if [ -d /etc/init.d ]; then
    rm -rf /etc/init.d/*serverSpeeder* >/dev/null 2>&1
    rm -rf /etc/rc*.d/*serverSpeeder* >/dev/null 2>&1
    rm -rf /etc/init.d/*lotServer* >/dev/null 2>&1
    rm -rf /etc/rc*.d/*lotServer* >/dev/null 2>&1
  fi
  rm -rf /etc/lotServer.conf >/dev/null 2>&1
  rm -rf /etc/serverSpeeder.conf >/dev/null 2>&1
  [ -f /appex/bin/lotServer.sh ] && AppexName="lotServer" && bash /appex/bin/lotServer.sh uninstall -f >/dev/null 2>&1
  [ -f /appex/bin/serverSpeeder.sh ] && AppexName="serverSpeeder" && bash /appex/bin/serverSpeeder.sh uninstall -f >/dev/null 2>&1
  rm -rf /appex >/dev/null 2>&1
  rm -rf /tmp/*${AppexName}* >/dev/null 2>&1
  [ -n "$1" ] && echo -ne "$AppexName 卸载完毕! \n" && echo "$1" && echo -ne "\n\n\n" && exit 0
}

if [ $# == '1' ]; then
  [ "$1" == 'install' ] && KNK="$(uname -r)" && Install;
  [ "$1" == 'uninstall' ] && Welcome  && Uninstall "Done.";
elif [ $# == '2' ]; then
  [ "$1" == 'install' ] && KNK="$2" && Install;
else
  echo -ne "Usage:\n     bash $0 [install |uninstall |install '{Kernel Version}']\n"
fi
