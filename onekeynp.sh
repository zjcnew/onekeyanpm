#!/bin/bash

# Generic script templates for Linux and class Unix platforms
# Supported: CentOS RedHat
# Version: 1.07
# QQ: 2850317601
# Updated: 2017/11/20


downnginx="http://nginx.org/download/nginx-1.12.2.tar.gz"
downphp="http://cn2.php.net/distributions/php-5.6.31.tar.gz"
downnginxconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/nginx.conf"
downphpconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/php.ini"
downphpfpmconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/php-fpm.conf"

location="/data"
soulocation="$location/src"
tarlocation="$location/app"
nginxtarlocation="$tarlocation/nginx"
phptarlocation="$tarlocation/php"





check_variable ()
{

	if [ ! "$downnginx" ]
	then
		echo 'Error,Nginx source package download location not specified!!'
		exit 1
	fi
	
	if [ ! "$downphp" ]
	then
		echo 'Error,PHP source package download location not specified!!'
		exit 1
	fi
	
	if [ ! "$downnginxconf" ]
	then
		echo 'Error,Nginx Configuration file download location not specified!!'
		exit 1
	fi
	
	if [ ! "$downphpconf" ]
	then
		echo 'Error,PHP Configuration file download location not specified!!'
		exit 1
	fi
	
	if [ ! "$location" ]
	then
		echo 'Error,You must specify the work directory first!!'
		exit 1
	fi
	
	if [ ! "$soulocation" ]
	then
		echo 'Error,Source package download directory not specified!!'
		exit 1
	fi
	
	if [ ! "$tarlocation" ]
	then
		echo 'Error,The software installation directory is not specified!!'
		exit 1
	fi
	
	if [ ! "$nginxtarlocation" ]
	then
		echo 'Error,The Nginx installation directory is not specified!!'
		exit 1
	fi
	
	if [ ! "$phptarlocation" ]
	then
		echo 'Error,The PHP installation directory is not specified!!'
		exit 1
	fi

}


check_location ()
{

	if [ ! -d $location ]
	then
		mkdir -p $location
	fi
	
	
	if [ ! -d $soulocation ]
	then
		mkdir -p $soulocation
	else
		if [ $(ls $soulocation/$* | wc -w) -ne 0 ]
		then
			echo 'Error, Source package directory $soulocation some files exists, Please clean up manually!!'
			exit 1
		fi
	fi
		
	
	if [ ! -d $tarlocation ]
	then
		mkdir -p $tarlocation
	else
		if [ $(ls $tarlocation/$* | wc -w) -ne 0 ]
		then
			echo 'Error, Installation directory $soulocation some files exists, Please clean up manually!!'
			exit 1
		fi
	fi
	
}
	
	
down_files ()
{	
	
	if [ -d $soulocation ]
	then
		if [ "$1" ]
		then
			cd $soulocation && \
			/usr/bin/curl -k -O $1 &&
			echo ''Downloaded $1 Successful'!'
		fi
	fi

}


detect_platform ()
{

	plaver=`uname -s`
	
	if [ "${plaver}" == "Linux" ]
	then
		platform="linux"
	elif [ "${plaver}" == "FreeBSD" ]
	then
		platform="freebsd"
	fi

}


detect_release_version ()
{

	if [ "${platform}" == "linux" ]
	then
	
		if [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'centos') -ge 1 ]
		then
			os="centos"
		elif [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'rhel') -ge 1 ]
		then
			os="rhel"
		elif [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'ubuntu') -ge 1 ]
		then
			os="ubuntu"
		elif [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'debian') -ge 1 ]
		then
			os="debian"
		elif [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'opensuse') -ge 1 ]
		then
			os="opensuse"
		elif [ -f /etc/os-release ] && [ $(grep -w '^ID' /etc/os-release | grep -c -i 'sles') -ge 1 ]
		then
			os="sles"
		elif [ ! -f /etc/os-release ]
		then
			if [ -f /etc/centos-release ]
			then
				os="centos"
			elif [ ! -f /etc/centos-release ] && [ -f /etc/redhat-release ]
			then
				os="rhel"
			fi
		else
			os="other" && echo 'Error,The System type cannot be determined!! '
		fi
		
	else
		
		echo 'Error,This is not the Linux platform!!'
		
   fi

}


detect_cenred_version ()
{

	if [ "${os}" == "centos" -o "${os}" == "rhel" ]
	then

		kerver=$(uname -r | awk -F'-' '{ print $1 }')
		
		if [ ${kerver} == "2.6.18" ]
		then
			osver=5
		elif [ ${kerver} == "2.6.32" ]
		then
			osver=6
		elif [ ${kerver} == "3.10.0" ]
		then
			osver=7
		fi

	fi
	
}


crrect_cenred_selinux ()
{

	if [ "${os}" == "centos" -o "${os}" == "rhel" ]
	then
	
		isdis=$(sed -n '/^\<SELINUX\>/p' /etc/selinux/config | grep -c 'disabled')
	
		if [ ${isdis} -eq 0 ]
		then
			sed -i "s/^\<SELINUX=.*/SELINUX=disabled/" /etc/selinux/config
			echo 'Warning,You must Restart the system to make the SELinux configuration take effect!'
			exit 0
		fi
	
	fi
	
}

correct_yum_repo ()
{

	#cd /etc/yum.repos.d && rename .repo .bak *
	rm -fr /etc/yum.repos.d/*
	
cat > /etc/yum.repos.d/CentOS-Base.repo << EOF
[base]
name=CentOS-\$releasever - Base - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
 
#released updates 
[updates]
name=CentOS-\$releasever - Updates - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
EOF

cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux \$releasever  - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/epel/\$releasever/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-\$releasever
EOF

yum clean all;yum makecache

}


correct_sys_time ()
{

	if [ "${os}" == "centos" -o "${os}" == "rhel" ]
	then
	
		if [ ${osver} -eq 7 ]
		then
			yum erase -y ntp ntpdate postfix mariadb-libs
			yum install -y chrony
			systemctl enable chronyd.service
			systemctl start chronyd.service 
		else
			yum erase -y postfix
			yum install ntp ntpdate -y
			chkconfig ntpd on
			chkconfig ntpdate on
			/etc/init.d/ntpd stop 2>/dev/null
			if [ ${osver} -eq 6 ]
			then
				/usr/sbin/ntpdate 0.centos.pool.ntp.org
			elif [ ${osver} -eq 5 ]
			then
				/sbin/ntpdate 0.centos.pool.ntp.org
			fi
			/etc/init.d/ntpd start
		fi
		
	fi
	
}


opt_sysctl ()
{

if [ $(grep -c "^net.ipv6.conf.all.disable_ipv6" /etc/sysctl.conf) -eq 0 ]
then
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
else
	sed -i "s#^net.ipv6.conf.all.disable_ipv6.*#net.ipv6.conf.all.disable_ipv6 = 1#" /etc/sysctl.conf 
fi

}

ins_depen_pac ()
{

	if [ $osver -eq 6 ]
	then
yum install -y \
gcc gcc-c++ telnet \
ncurses ncurses-devel \
libxml2 libxml2-devel curl-devel \
libpng libpng-devel bzip2 bzip2-devel \
libjpeg libjpeg-devel harfbuzz harfbuzz-devel \
pcre pcre-devel zlib zlib-devel \
freetype freetype-devel libmcrypt libmcrypt-devel \
openssl openssl-devel
	elif [ $osver -eq 7 ]
	then
yum install -y \
gcc gcc-c++ telnet \
ncurses ncurses-devel \
libxml2 libxml2-devel curl-devel \
libpng libpng-devel bzip2 bzip2-devel \
libjpeg libjpeg-devel harfbuzz harfbuzz-devel \
pcre pcre-devel zlib zlib-devel \
freetype freetype-devel libmcrypt libmcrypt-devel \
openssl openssl-devel
	fi


}


ins_nginx_app ()
{

	if [ -f $soulocation/nginx*.tar.gz ]
	then
		cd $soulocation && \
		tar zxvf nginx*.tar.gz && \
		cd nginx-* && \
		sed -i 's:CFLAGS="$CFLAGS -g":#CFLAGS="$CFLAGS -g":' auto/cc/gcc
		sed -i 's:"1.12.1":"":' src/core/nginx.h
		sed -i 's:"nginx/":"":' src/core/nginx.h
		sed -i 's:"Server\: nginx":"Server\: ":' src/http/ngx_http_header_filter_module.c
		sed -i 's:" NGINX_VER "::' src/http/ngx_http_special_response.c
		sed -i 's:"<hr><center>nginx</center>":"<hr><center></center>":' src/http/ngx_http_special_response.c
	
./configure --prefix=$nginxtarlocation \
--pid-path=$nginxtarlocation/run/nginx.pid \
--user=nginx --group=nginx \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-pcre
	
		if [ $? -eq 0 ]
		then
			make && make install
		else
			echo 'Error, There was an error in configuring nginx Before compiling!!'
			exit 2
		fi
	
		if [ -f $nginxtarlocation/sbin/nginx ]
		then
			if [ $(id nginx 2> /dev/null) -eq 0 ]
			then
				if [ $(grep '^nginx' /etc/passwd | grep -c '/sbin/nologin') -eq 0 ]
				then
					usermod -s /sbin/nologin nginx
				fi
			else
				useradd -M -s /sbin/nologin nginx
			fi

			[ -f $soulocation/nginx.conf ] && /bin/cp -f $soulocation/nginx.conf $nginxtarlocation/conf/
			chown -R nginx.nginx /data/app/nginx/
		else
			echo 'Error, nginx installation failed!!'
			exit 2
		fi
	
	
		if [ $osver -eq 6 ]
		then
			if [ -f /etc/init.d/nginx ]
			then
				echo 'Error,The nginx service is already exists!!'
				exit 2
			else
cat > /etc/init.d/nginx << EOF
#!/bin/bash
#
# chkconfig: 2345 66 34
# description: A very fast and reliable nginx engine
#
#
BASEDIR=$nginxtarlocation
DAEMON=\$BASEDIR/sbin/nginx
PIDFILE=\$BASEDIR/run/nginx.pid

set -e
if [ ! -x "\$DAEMON" ];then
  echo 'nginx deamon not exist!!'
  exit 1
fi

if [ ! "\$1" ];then
  echo "Usage: {start|stop|reload|restart}"
  exit 2
fi

_start() {
  \$DAEMON
}

_stop() {
  \$DAEMON -s stop
}

_reload() {
  \$DAEMON -s reload
}

case "\$1" in
start)
_start
echo -e "Starting Nginx: [  \e[0;32mOK\e[0m  ]"
;;
stop)
_stop
echo -e "Stoping Nginx: [  \e[0;32mOK\e[0m  ]"
;;
reload|graceful)
_reload
echo -e "Reloading Nginx: [  \e[0;32mOK\e[0m  ]"
;;
restart)
_stop
echo -e "Stoping Nginx: [  \e[0;32mOK\e[0m  ]"
_start
echo -e "Starting Nginx: [  \e[0;32mOK\e[0m  ]"
esac

exit 0
EOF

			fi
			
			if [ "$?" ]
			then
				chmod 755 /etc/init.d/nginx
				install_nginx_status=1
				chkconfig --add nginx
			fi
			
		elif [ $osver -eq 7 ]
		then
			if [ -f /usr/lib/systemd/system/nginx.service ]
			then
				echo 'Error,The nginx service is already exists!!'
				exit 2
			else
cat > /usr/lib/systemd/system/nginx.service << EOF
[Unit]
Description=nginx - A very fast and reliable nginx engine
After=network.target nss-lookup.target

[Service]
Type=forking
LimitNOFILE=655360
LimitNPROC=655360
PIDFile=$nginxtarlocation/run/nginx.pid
ExecStartPre=$nginxtarlocation/sbin/nginx -t -c $nginxtarlocation/conf/nginx.conf
ExecStart=$nginxtarlocation/sbin/nginx
ExecReload=$nginxtarlocation/sbin/nginx -s reload
ExecStop=$nginxtarlocation/sbin/nginx -s stop

[Install]
WantedBy=multi-user.target
EOF

				if [ "$?" ]
				then
					systemctl enable nginx
					install_nginx_status=1
				fi
			
			fi
		fi
	else
		echo 'Error,The nginx source package does not exist!!'
		exit 2
	fi
	
}


ins_php_app ()
{

	if [ -f $soulocation/php*.tar.gz ]
	then
		if [ $install_nginx_status -eq 1 ]
		then
cd $soulocation && tar zxvf php*.tar.gz && cd php-*
./configure --prefix=$phptarlocation \
--with-config-file-path=$phptarlocation/etc \
--with-mcrypt \
--with-freetype-dir \
--with-openssl --enable-fpm \
--with-fpm-user=nginx --with-fpm-group=nginx \
--enable-mysqlnd --with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd --enable-mbstring \
--enable-gd-native-ttf \
--with-gd --with-iconv \
--with-zlib --enable-xml \
--enable-shmop --enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex --enable-sockets \
--enable-zip --enable-soap \
--with-gettext --enable-session \
--with-curl --enable-opcache \
--with-mhash --enable-ftp \
--with-jpeg-dir --with-png-dir \
--with-libxml-dir --enable-bcmath \
--enable-intl --enable-pcntl \
--with-xmlrpc --enable-exif

		if [ $? -eq 0 ]
		then
			make && make install
			rm -f /etc/php.ini
			[ -f $soulocation/php.ini ] && /bin/cp -f $soulocation/php.ini $phptarlocation/etc/
			[ -f $soulocation/php-fpm.conf ] && /bin/cp -f $soulocation/php-fpm.conf $phptarlocation/etc/php-fpm.conf
			
			if [ $install_nginx_status -eq 1 ]
			then
				mkdir /data/app/php/tmp
				chown nginx.nginx /data/app/php/tmp/
			else
				echo 'Warning,nginx is not installed successfully!'
			fi
			
			cd ..
			yum install autoconf git -y
			git clone https://github.com/phpredis/phpredis.git
			cd phpredis
			/data/app/php/bin/phpize
			./configure --with-php-config=$phptarlocation/bin/php-config
			if [ $? -eq 0 ]
			then
				make && make install
			else
				echo 'Error, There was an error in configuring phpredis Before compiling!!'
				exit 2
			fi

			cd ..
			curl -O http://downloads.zend.com/guard/7.0.0/zend-loader-php5.6-linux-x86_64_update1.tar.gz
			tar zxf zend-loader-php5.6-linux-x86_64_update1.tar.gz 
			cp zend-loader-php5.6-linux-x86_64/ZendGuardLoader.so $phptarlocation/lib/php/extensions/no-debug-non-zts-20131226/
		else
			echo 'Error, There was an error in configuring php Before compiling!!'
			exit 2
		fi


                if [ $osver -eq 6 ]
                then
                        if [ -f /etc/init.d/nginx ]
                        then
                                echo 'Error,The nginx service is already exists!!'
                                exit 2
                        else
				echo "php service"

			fi

                elif [ $osver -eq 7 ]
                then
                        if [ -f /usr/lib/systemd/system/php-fpm.service ]
                        then
                                echo 'Error,The php-fpm service is already exists!!'
                                exit 2
                        else
cat > /usr/lib/systemd/system/php-fpm.service << EOF
[Unit]
Description=php-fpm
After=network.target

[Service]
Type=forking
LimitNOFILE=655360
LimitNPROC=655360
PIDFile=$phptarlocation/var/run/php-fpm.pid
ExecStart=$phptarlocation/sbin/php-fpm --daemonize --fpm-config $phptarlocation/etc/php-fpm.conf --pid $phptarlocation/var/run/php-fpm.pid
ExecReload=/usr/bin/kill -USR2 $MAINPID
ExecStop=/usr/bin/kill -QUIT $MAINPID

[Install]
WantedBy=multi-user.target
EOF

                                if [ "$?" ]
                                then
                                        systemctl enable php-fpm
					install_php_fpm_status=1
                                fi

                        	fi
			fi
                fi
        else
                echo 'Error,The php source package does not exist!!'
                exit 2
        fi
}		


logrotate ()
{

	if [ $install_nginx_status -eq 1 ]
	then

cat > /etc/logrotate.d/nginx << EOF
$nginxtarlocation/logs/*.log {
    create 0644 nginx nginx
    daily
    rotate 30
    dateext
    missingok
    notifempty
    compress
    sharedscripts
    postrotate
        /bin/kill -USR1 \`cat $nginxtarlocation/run/nginx.pid 2>/dev/null\` 2>/dev/null || true
    endscript
}
EOF

	fi


	if [ $install_php_fpm_status -eq 1 ]
	then

cat > /etc/logrotate.d/php-fpm << EOF
$phptarlocation/log/*.log {
    daily
    rotate 30
    dateext
    missingok
    notifempty
    compress
    sharedscripts
    postrotate
        /usr/bin/systemctl reload php-fpm 2>/dev/null
    endscript
}
EOF

	fi
}


start_service ()
{

	[ $install_nginx_status -eq 1 ] && systemctl start nginx
	[ $install_php_fpm_status -eq 1 ] && systemctl start php-fpm

}







detect_platform
detect_release_version
detect_cenred_version

check_variable 
check_location
crrect_cenred_selinux
correct_yum_repo
correct_sys_time
down_files $downnginx
down_files $downphp
down_files $downnginxconf
down_files $downphpconf
down_files $downphpfpmconf
ins_depen_pac 
ins_nginx_app
ins_php_app
logrotate
start_service
