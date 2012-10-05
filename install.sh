#! /bin/bash
#====================================================================
# install.sh
#
# Transmission Auto Install Script
#
# Copyright (c) 2012, WangYan <WangYan@188.com>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
# Intro: http://wangyan.org/blog/transmission.html
#
#====================================================================

if [ $(id -u) != "0" ]; then
    clear && echo "Error: You must be root to run this script!"
    exit 1
fi

TRANS_PATH=`pwd`
if [ `echo $TRANS_PATH | awk -F/ '{print $NF}'` != "trans" ]; then
	clear && echo "Please enter trans script path:"
	read -p "(Default path: ${TRANS_PATH}/trans):" TRANS_PATH
	[ -z "$TRANS_PATH" ] && TRANS_PATH=$(pwd)/trans
	cd $TRANS_PATH/
fi

DISTRIBUTION=`awk 'NR==1{print $1}' /etc/issue`

if echo $DISTRIBUTION | grep -Eqi '(Red Hat|CentOS|Fedora|Amazon)';then
    PACKAGE="rpm"
elif echo $DISTRIBUTION | grep -Eqi '(Debian|Ubuntu)';then
    PACKAGE="deb"
else
    if cat /proc/version | grep -Eqi '(redhat|centos)';then
        PACKAGE="rpm"
    elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
        PACKAGE="deb"
    else
        echo "Please select the package management! (rpm/deb)"
        read -p "(Default: rpm):" PACKAGE
        if [ -z "$PACKAGE" ]; then
            PACKAGE="rpm"
        fi
        if [[ "$PACKAGE" != "rpm" && "$PACKAGE" != "deb" ]];then
            echo -e "\nNot supported linux distribution!"
            echo "Please contact me! WangYan <WangYan@188.com>"
            exit 0
        fi
    fi
fi

[ -r "$TRANS_PATH/fifo" ] && rm -rf $TRANS_PATH/fifo
mkfifo $TRANS_PATH/fifo
cat $TRANS_PATH/fifo | tee $TRANS_PATH/log.txt &
exec 1>$TRANS_PATH/fifo
exec 2>&1

/bin/bash ${TRANS_PATH}/${PACKAGE}.sh

sed -i '/password/d' $TRANS_PATH/log.txt
rm -rf $TRANS_PATH/fifo
