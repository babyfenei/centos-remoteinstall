#!/bin/bash
 
# Centos AutoInstall 
# VER. 1.1.0 - http://www.fenei.net
# 此脚本主要为方便远程重装centos系统使用，目前因空间问题只做到6.1-7.0的64位版本
# 此脚本需要搭建一套http服务器并启用目录浏览，将需要远程安装的镜像解压到http服务器
# 脚本运行完成以后需要使用vnc客户端连接服务器进行安装.重装系统的服务器需和VNC客户端互通
# 
# 2016年5月20日3

# VER. 2.1.0 - http://www.fenei.net
# 新增镜像站点网络连接判断
# 新增centos7系列grub2的安装
# 
# 2018年1月30日
# 整体重新编写脚本
# 支持双网卡远程重装
# 目前支持最新centos版本为7.4
#
# 
#
# babyfenei@gmail.com
# http://www.fenei.net
#
#=====================================================================

# 获取本机IP及版本信息
#IPADDRESS=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
#NETMASK=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $4}'|tr -d "Mask:")
#GATEWAY=$(ip route |grep default|awk '{print $3}')
#DNS=$(cat /etc/resolv.conf | awk 'NR>1' |awk '{print $2}' | head -n 1)
RELEASE=$(rpm -q centos-release | cut -d '-' -f 3)
#centos 镜像源服务器IP或域名地址
#IMG_IP=vault.centos.org
IMG_IP=mirrors.xipunet.com




Dev_info() {
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +            Which device you need to reinstall      +\n"
	printf "             +    This device must be connected to your computer  +\n"
	printf "             +             eg：    eth0 ens32 p2p1                +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read DEV
	echo "Your Device is $DEV"
	}
	
Mac_info() {
	MAC=`LANG=C ip address show $DEV |awk '/link\/ether/{ print $2 }' `
	echo "Your Mac address is $MAC"

	}

Check_img_ip() {
	ping -I $DEV -c2 $IMG_IP >>/dev/null
	if [ $? -eq 0 ];then
		echo “Mirrors network is ok,wait to install ...” 
		ping -I $DEV -c5 $IMG_IP >>/dev/null
	else
		echo "network is Unreachable,This script can not run! Now Exit!!!"
		exit
	fi

	}	

Vnc_info() {
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +             Pls input your vnc's password          +\n"
	printf "             +                  ■ Must be 6-8 digits ■            +\n"
	printf "             +                    eg：    12345678                +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read PASSWD
	echo "Your Password is $PASSWD"
	}
	
Ip_info() {
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +                Pls input your IP address           +\n"
	printf "             +                    eg：192.168.1.200               +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read IPADDRESS

	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +                 Pls input your netmask             +\n"
	printf "             +                   eg：255.255.255.252              +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read NETMASK
	
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +                Pls input your IP gateway           +\n"
	printf "             +                    eg：192.168.1.1                 +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read GATEWAY
	
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +                                                    +\n"
	printf "             +                Pls input your DNS address          +\n"
	printf "             +                    eg：114.114.114.114             +\n"
	printf "             +                                                    +\n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read DNS

	}

Ip_display() {
	clear
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             ++++++++++++++++++ Your Ip Information  +++++++++++++++++++++++\n"
	printf "                     IP      : $IPADDRESS 									\n"
	printf "                     MASK    ：$NETMASK	       						  	    \n"
	printf "                     GATEWAY ：$GATEWAY   								    \n"
	printf "                     DNS     : $DNS	   	         				            \n"
	printf "                     Ethernet: $DEV	   	         				            \n"
	printf "                 Make sure the configuration information is correct         \n"
	printf "                 or you will not be able to login remotely!!                \n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read anykey

	}

Ver_select() {
	clear                        
	printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +++++++++++Pls.select your Centos version++++++++++\n"
	printf "             +                                                 +\n"
	printf "             +    1.CentOS 6.1-X86_64   2.CentOS 6.2-X86_64    +\n"
	printf "             +    3.CentOS 6.3-X86_64   4.CentOS 6.4-X86_64    +\n"
	printf "             +    5.CentOS 6.5-X86_64   6.CentOS 6.6-X86_64    +\n"
	printf "             +    7.CentOS 6.7-X86_64   8.CentOS 6.8-X86_64    +\n"
	printf "             +    9.CentOS 6.9-X86_64   a.CentOS 7.0-X86_64    +\n"
	printf "             +    b.CentOS 7.1-X86_64   c.CentOS 7.2-X86_64    +\n"
	printf "             +    d.CentOS 7.3-X86_64   e.CentOS 7.4-X86_64    +\n"
	printf "             +                                                 +\n"
	printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read selec
	case "$selec" in
			"1")
			Ver=6.1
			;;
		
			"2")
			Ver=6.2
			;;
		
			"3")
			Ver=6.3
			;;
		
			"4")
			Ver=6.4
			;;

			"5")
			Ver=6.5
			;;

			"6")
			Ver=6.6
			;;
		
			"7")
			Ver=6.7
			;;
		
			"8")
			Ver=6.8
			;;
		
			"9")
			Ver=6.9
			;;
		
			"a")
			Ver=7.0.1406
			;;
		
			"b")
			Ver=7.1.1503
			;;
		
			"c")
			Ver=7.2.1511
			;;
		
			"d")
			Ver=7.3.1611
			;;
		
			"e")
			Ver=7.4.1708
			;;
		esac
	echo "Your select centos version is ${Ver}"

	}


grub_6() {
	clear
	rm -rf /centos_install /boot/vmlinuz.cent.pxe /boot/initrd.img.cent.pxe
	cp /boot/grub/grub.conf /boot/grub/grub.conf.bak
	sed -i '/PXE/,+3d' /boot/grub/grub.conf
	sed -i '/fallback/d' /boot/grub/grub.conf
	mkdir /centos_install
	cd /centos_install
	curl -O  http://${IMG_IP}/${Ver}/os/x86_64/images/pxeboot/initrd.img
	curl -O  http://${IMG_IP}/${Ver}/os/x86_64/images/pxeboot/vmlinuz
	\cp -fr vmlinuz /boot/vmlinuz.cent.pxe
	\cp -fr initrd.img /boot/initrd.img.cent.pxe
	chmod 755 /boot/vmlinuz.cent.pxe
	chmod 600 /boot/initrd.img.cent.pxe
	#在"hiddenmenu" 和 "title CentOS..." 增加一项:
	#repo中的url为安装centos的源
	sed -i -e "/timeout=5/a \fallback=1" /boot/grub/grub.conf
	sed -i -e "/hiddenmenu/a\title CentOS ${Ver}-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} headless ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice=${DEV}   method=http:\/\/${IMG_IP}\/${Ver}\/os\/x86_64\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
	#sed -i -e "/hiddenmenu/a\title CentOS ${Ver}-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice=${MAC} method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/${Ver} lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
	}

grub_7() {
	clear
	rm -rf /centos_install /boot/vmlinuz.cent.pxe /boot/initrd.img.cent.pxe
	cp /etc/grub.d/40_custom /etc/40_custom.bak
	sed -i '/NetInstall/,+4d' /etc/grub.d/40_custom
	sed -i '/NetInstall/,+4d' /boot/grub2/grub.cfg
	mkdir /centos_install
	cd /centos_install
	curl -O  http://${IMG_IP}/${Ver}/os/x86_64/images/pxeboot/initrd.img
	curl -O  http://${IMG_IP}/${Ver}/os/x86_64/images/pxeboot/vmlinuz
	\cp -fr vmlinuz /boot/vmlinuz.cent.pxe
	\cp -fr initrd.img /boot/initrd.img.cent.pxe
	
	if [[ ${Ver:0:1} -eq "6" ]];
	then	
		echo "menuentry \"NetInstall_Centos_${Ver}\" {" >>/etc/grub.d/40_custom
		echo "set root=(hd0,1)" >>/etc/grub.d/40_custom
		echo "linux /vmlinuz.cent.pxe method=http://${IMG_IP}/${Ver}/os/x86_64 vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice=${MAC} noselinux headless lang=en_US keymap=us" >>/etc/grub.d/40_custom
		echo "initrd /initrd.img.cent.pxe" >>/etc/grub.d/40_custom
		echo "}" >>/etc/grub.d/40_custom
		grub2-mkconfig --output=/boot/grub2/grub.cfg
		grub2-reboot NetInstall_Centos_${Ver}
	elif [[ ${Ver:0:1} -eq "7" ]];
	then
		echo "menuentry \"NetInstall_Centos_${Ver}\" {" >>/etc/grub.d/40_custom
		echo "set root=(hd0,1)" >>/etc/grub.d/40_custom
		echo "linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/${Ver}/os/x86_64 vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} ksdevice=${MAC} noselinux headless lang=en_US keymap=us" >>/etc/grub.d/40_custom
		echo "initrd /initrd.img.cent.pxe" >>/etc/grub.d/40_custom
		echo "}" >>/etc/grub.d/40_custom
		grub2-mkconfig --output=/boot/grub2/grub.cfg
		grub2-reboot NetInstall_Centos_${Ver}
	fi

	}

vnc_dispaly(){
	
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             + Please reboot the server and use the VNC client to  \n" 
	printf "             + remotely install the system.                        \n"
	printf "             +                                                     \n"
	printf "             +             VNC_address ：$IPADDRESS:1   	   	   \n"
	printf "             +             VNC_password：$PASSWD                   \n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read anykey	

	}

Vnc_info
Dev_info
Mac_info
Check_img_ip
if [[ $MAC =~ ":" ]];
	then 
		Ip_info
		Ip_display
		Ver_select
		if [ "$RELEASE" = "6" ];
			then	
			grub_6
		elif [ "$RELEASE" = "7" ];
		then
			grub_7
		else
			echo "The current system does not support this script, can not be installed!"
		fi
		vnc_dispaly
	else
		echo "your device's mac address is error,Pls Re run this script!!" 
	fi
exit
