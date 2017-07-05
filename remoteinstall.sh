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
# 2017年4月24日
# 
#
# Fenei@ Sinpul Network
# http://www.fenei.net
#
#=====================================================================

# 获取本机IP及版本信息
IPADDRESS=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
NETMASK=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $4}'|tr -d "Mask:")
GATEWAY=$(ip route |grep default|awk '{print $3}')
DNS=$(cat /etc/resolv.conf | awk 'NR>1' |awk '{print $2}' | head -n 1)
RELEASE=$(rpm -q centos-release | cut -d '-' -f 3)
#centos 镜像源服务器IP或域名地址
IMG_IP=img.fenei.net
stty erase ^h 
stty erase ^H
stty erase ^?
#将shell运行过程中读取退格键 替换为退格命令，否则会输出 ^H！^?


ping -c2 $IMG_IP >>/dev/null
if [ $? -eq 0 ];then
echo “Mirrors network is ok,wait to install ...” 
ping -c5 $IMG_IP >>/dev/null

	if [ "$RELEASE" = "6" ];
		then	
			clear
			printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
			printf "             +                                                    +\n"
			printf "             +                  请输入VNC远程密码                 +\n"
			printf "             +                    ■ 必须6-8位 ■                   +\n"
			printf "             +                    eg：    12345678                +\n"
			printf "             +                                                    +\n"
			printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
			read PASSWD
				clear
				printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
				printf "             +              您的服务器IP配置信息为                           \n"
				printf "             +        IP地址  : $IPADDRESS 									 \n"
				printf "             +        子网掩码：$NETMASK	       						     \n"
				printf "             +        网关    ：$GATEWAY   								     \n"
				printf "             +        DNS     : $DNS	   	         				         \n"
				printf "             +        请确保配置信息正确，否则将无法远程登录                 \n"
				printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
				read anykey
					clear                        
					printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
					printf "             ++++++请选择需要安装的Centos系统版本+++++++++++++++\n"
					printf "             +                                                 +\n"
					printf "             +    1.CentOS 6.1-X86_64   2.CentOS 6.2-X86_64    +\n"
					printf "             +    3.CentOS 6.3-X86_64   4.CentOS 6.4-X86_64    +\n"
					printf "             +    5.CentOS 6.5-X86_64   6.CentOS 6.6-X86_64    +\n"
					printf "             +    7.CentOS 6.7-X86_64   8.CentOS 6.8-X86_64    +\n"
					printf "             +    9.CentOS 6.9-X86_64   a.CentOS 7.0-X86_64    +\n"
					printf "             +    b.CentOS 7.1-X86_64   c.CentOS 7.2-X86_64    +\n"
					printf "             +    d.CentOS 7.3-X86_64                          +\n"
					printf "             +                                                 +\n"
					printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
					printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
					read selec
					case "$selec" in
							"1")
							##### CentOS 6.1-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.1/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.1/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.1-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.1\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
						

							"2")
							##### CentOS 6.2-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.2/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.2/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.2-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.2\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							

							"3")
							##### CentOS 6.3-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.3/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.3/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.3-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.3\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							

							"4")
							##### CentOS 6.4-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.4/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.4/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.4-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.4\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							

							"5")
							##### CentOS 6.5-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.5/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.5/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.5-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.5\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							

							"6")
							##### CentOS 6.6-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.6/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.6/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.6-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.6\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;

							
							"7")
							##### CentOS 6.7-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.7/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.7/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.7-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.7\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							
							"8")
							##### CentOS 6.8-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.8/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.8/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.8-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.8\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							
							"9")
							##### CentOS 6.9-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.9/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/6.9/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 6.9-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/6.9\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;

							"a")
							##### CentOS 7.0-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.0/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.0/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 7.0-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/7.0\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							
							"b")
							##### CentOS 7.1-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.1/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.1/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 7.1-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/7.1\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							
							"c")
							##### CentOS 7.2-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.2/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.2/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 7.2-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/7.2\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;
							
							"d")
							##### CentOS 7.3-X86_64 #####
							clear
							mkdir /centos_install
							cd /centos_install
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.3/images/pxeboot/initrd.img
							curl -O  http://${IMG_IP}/linux/centos/x86_64/7.3/images/pxeboot/vmlinuz
							cp vmlinuz /boot/vmlinuz.cent.pxe
							cp initrd.img /boot/initrd.img.cent.pxe
							#在"hiddenmenu" 和 "title CentOS..." 增加一项:
							#repo中的url为安装centos的源
							sed -i -e "/hiddenmenu/a\title CentOS 7.3-X86_64  Install (PXE)\nroot (hd0,0) \nkernel \/vmlinuz.cent.pxe vnc vncpassword=${PASSWD} noselinux headless ip=${IPADDRESS} IP netmask=${NETMASK} gateway=${GATEWAY} dns=${DNS} ksdevice= method=http:\/\/${IMG_IP}\/linux\/centos\/x86_64\/7.3\/ lang=en_US keymap=us\ninitrd \/initrd.img.cent.pxe" /boot/grub/grub.conf
							;;			
							
						esac

	elif [ "$RELEASE" = "7" ];
	then
		clear
		printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
		printf "             +                                                    +\n"
		printf "             +                  请输入VNC远程密码                 +\n"
		printf "             +                    ■ 必须6-8位 ■                   +\n"
		printf "             +                  eg：     12345678                 +\n"
		printf "             +                                                    +\n"
		printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
		read PASSWD
			clear
			printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
			printf "             +              您的服务器IP配置信息为                           \n"
			printf "             +        IP地址  : $IPADDRESS 									 \n"
			printf "             +        子网掩码：$NETMASK	       						     \n"
			printf "             +        网关    ：$GATEWAY   								     \n"
			printf "             +        DNS     : $DNS	   	         				         \n"
			printf "             +        请确保配置信息正确，否则将无法远程登录                 \n"
			printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
			read anykey
				clear                        
				printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
				printf "             ++++++请选择需要安装的Centos系统版本+++++++++++++++\n"
				printf "             +                                                 +\n"
				printf "             +    1.CentOS 6.1-X86_64   2.CentOS 6.2-X86_64    +\n"
				printf "             +    3.CentOS 6.3-X86_64   4.CentOS 6.4-X86_64    +\n"
				printf "             +    5.CentOS 6.5-X86_64   6.CentOS 6.6-X86_64    +\n"
				printf "             +    7.CentOS 6.7-X86_64   8.CentOS 6.8-X86_64    +\n"
				printf "             +    9.CentOS 6.9-X86_64   a.CentOS 7.0-X86_64    +\n"
				printf "             +    b.CentOS 7.1-X86_64   c.CentOS 7.2-X86_64    +\n"
				printf "             +    d.CentOS 7.3-X86_64                          +\n"
				printf "             +                                                 +\n"
				printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
				printf "             +++++++++++++++++++++++++++++++++++++++++++++++++++\n"
				read selec
				case "$selec" in
					"1")
					##### CentOS 6.1-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.1/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.1/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
			
			
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.1/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
				

					"2")
					##### CentOS 6.2-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.2/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.2/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.2/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					

					"3")
					##### CentOS 6.3-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.3/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.3/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.3/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					

					"4")
					##### CentOS 6.4-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.4/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.4/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.4/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					

					"5")
					##### CentOS 6.5-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.5/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.5/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.5/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					

					"6")
					##### CentOS 6.6-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.6/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.6/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.6/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;

					
					"7")
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.7/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.7/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.7/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					
					"8")
					##### CentOS 6.8-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.8/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.8/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.8/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					
					"9")
					##### CentOS 6.9-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.9/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/6.9/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/6.9/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;

					"a")
					##### CentOS 7.0-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.0/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.0/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/7.0/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					
					"b")
					##### CentOS 7.1-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.1/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.1/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/7.1/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;
					
					"c")
					##### CentOS 7.2-X86_64 #####
					clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.2/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.2/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/7.2/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall
					;;
					
					"d")
					##### CentOS 7.3-X86_64 #####
								clear
					mkdir /centos_install
					cd /centos_install
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.3/images/pxeboot/initrd.img
					curl -O  http://${IMG_IP}/linux/centos/x86_64/7.3/images/pxeboot/vmlinuz
					cp vmlinuz /boot/vmlinuz.cent.pxe
					cp initrd.img /boot/initrd.img.cent.pxe
					
					
					cat >> /etc/grub.d/40_custom << EOF
				menuentry "NetInstall" {
					set root=(hd0,1)
					linux /vmlinuz.cent.pxe repo=http://${IMG_IP}/linux/centos/x86_64/7.3/ vnc vncpassword=${PASSWD} ip=${IPADDRESS} netmask=${NETMASK} gateway=${GATEWAY} nameserver=${DNS} noselinux headless
					initrd /initrd.img.cent.pxe
				}
EOF

			

					grub2-mkconfig --output=/boot/grub2/grub.cfg
					grub2-reboot NetInstall			
					;;			
					
				esac
	else
		echo "当前系统不支持此安装脚本,无法进行安装"
	fi

	

	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	printf "             +              Centos重装脚本执行成功                 \n"
	printf "             +     请重启服务器后使用VNC客户端远程进行系统安装	   \n"
	printf "             +             VNC服务器地址：$IPADDRESS:1   	   	   \n"
	printf "             +             VNC服务器密码：$PASSWD                  \n"
	printf "             ++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
	read anykey	
		exit
else
echo “network is Unreachable,This script can not run! Now Exit!!!” 
exit
fi	

		

