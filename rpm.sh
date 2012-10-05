#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

if [ $(id -u) != "0" ]; then
	printf "Error: You must be root to run this script!"
	exit 1
fi

TRANS_PATH=`pwd`
if [ `echo $TRANS_PATH | awk -F/ '{print $NF}'` != "trans" ]; then
	clear && echo "Please enter trans script path:"
	read -p "(Default path: ${TRANS_PATH}/trans):" TRANS_PATH
	[ -z "$TRANS_PATH" ] && TRANS_PATH=$(pwd)/trans
	cd $TRANS_PATH/
fi

clear
echo "#############################################################"
echo "# Transmission Auto Install Shell Script"
echo "# Env: Redhat/CentOS"
echo "# Intro: http://wangyan.org/blog/transmission.html"
echo "# Version: $(awk '/version/{print $2}' $TRANS_PATH/Changelog)"
echo "#"
echo "# Copyright (c) 2012, WangYan <WangYan@188.com>"
echo "# All rights reserved."
echo "# Distributed under the GNU General Public License, version 3.0."
echo "#"
echo "#############################################################"
echo ""

echo "Please enter remote login username:"
read -p "(Default username: demo):" USERNAME
if [ -z $USERNAME ]; then
	USERNAME="demo"
fi
echo "---------------------------"
echo "login username = $USERNAME"
echo "---------------------------"
echo ""

echo "Please enter remote login password:"
read -p "(Default password: demo):" PASSWORD
if [ -z $PASSWORD ]; then
	PASSWORD="demo"
fi
echo "---------------------------"
echo "login password = $PASSWORD"
echo "---------------------------"
echo ""

echo "Please enter the download dir:"
read -p "(Default download dir: /root/Downloads):" DLDIR
if [ -z $DLDIR ]; then
	DLDIR="/root/Downloads"
fi
echo "---------------------------"
echo "download dir=$DLDIR"
echo "---------------------------"
echo ""

get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo "Press any key to start install..."
echo ""
char=`get_char`

echo "---------- Disable SeLinux ----------"

if [ -s /etc/selinux/config ]; then
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi

echo "---------- Set Library  ----------"

if [ ! `grep -iqw /lib /etc/ld.so.conf` ]; then
	echo "/lib" >> /etc/ld.so.conf
fi

if [ ! `grep -iqw /usr/lib /etc/ld.so.conf` ]; then
	echo "/usr/lib" >> /etc/ld.so.conf
fi

if [ -d "/usr/lib64" ] && [ ! `grep -iqw /usr/lib64 /etc/ld.so.conf` ]; then
	echo "/usr/lib64" >> /etc/ld.so.conf
fi

if [ ! `grep -iqw /usr/local/lib /etc/ld.so.conf` ]; then
	echo "/usr/local/lib" >> /etc/ld.so.conf
fi

echo "---------- Dependent Packages ----------"

yum -y install gcc gcc-c++ m4 make automake libtool gettext openssl-devel pkgconfig curl curl-devel intltool

echo "================ Transmission Install ==============="

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

echo "---------- libevent ----------"

if [ ! -s libevent-*.tar.gz ]; then
	wget -c https://github.com/downloads/libevent/libevent/libevent-2.0.20-stable.tar.gz
fi
tar -zxf libevent-*.tar.gz
cd libevent-*
./configure
make && make install && ldconfig

echo "---------- transmission ----------"

cd $TRANS_PATH/

if [ ! -s transmission-*.tar.bz2 ]; then
	wget -c http://download.transmissionbt.com/files/transmission-2.71.tar.bz2
fi
tar -jxf transmission-*.tar.bz2
cd transmission-*

if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
	./configure --prefix=/usr/local/transmission CFLAGS=-liconv
else
	./configure --prefix=/usr/local/transmission
fi
make && make install

echo "---------- transmission config ----------"

for i in `ls /usr/local/transmission/bin/`; do ln -s /usr/local/transmission/bin/$i /usr/bin/$i; done

cp $TRANS_PATH/init.d.transmission /etc/init.d/transmission
chmod 755 /etc/init.d/transmission
#chkconfig transmission on

mkdir -p $DLDIR > /dev/null 2>&1
mkdir -p /usr/local/transmission/etc/
/etc/init.d/transmission start > /dev/null 2>&1

sed -i 's/240/512/g' /usr/local/transmission/etc/settings.json
sed -i 's/60/128/g' /usr/local/transmission/etc/settings.json
sed -i 's#/root/Downloads#'$DLDIR'#g' /usr/local/transmission/etc/settings.json
sed -i 's/^.*rpc-authentication-required.*/"rpc-authentication-required": true,/' /usr/local/transmission/etc/settings.json
sed -i 's/^.*rpc-password.*/"rpc-password": "'$PASSWORD'",/' /usr/local/transmission/etc/settings.json
sed -i 's/^.*rpc-username.*/"rpc-username": "'$USERNAME'",/' /usr/local/transmission/etc/settings.json
sed -i 's/^.*rpc-whitelist-enabled.*/"rpc-whitelist-enabled": false,/' /usr/local/transmission/etc/settings.json

\cp /usr/local/transmission/etc/settings.json /usr/local/transmission/etc/settings.json.bak

/etc/init.d/transmission restart

service iptables stop > /dev/null 2>&1

clear
echo ""
echo "===================== Install completed ====================="
echo ""
echo "Transmission install completed!"
echo "Intro http://wangyan.org/blog/transmission.html"
echo ""
echo "Transmission Config: /usr/local/transmission/etc/settings.json.bak"
echo "Transmission Web Url: http://IP_ADDRESS:9091"
echo ""
echo "============================================================="
echo ""
