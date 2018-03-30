#!/bin/bash


# Nginx源码包下载地址，默认从官网下载。
downnginx="http://nginx.org/download/nginx-1.12.2.tar.gz"

# Apache源码包下载地址，默认从官网下载。
downapache="https://mirrors.tuna.tsinghua.edu.cn/apache/httpd/httpd-2.4.29.tar.gz"

# PHP源码包下载地址，默认从官网下载。
downphp="http://cn2.php.net/distributions/php-5.6.34.tar.gz"

# MySQL源码包下载地址，默认从官网下载。
downmysql="https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.39.tar.gz"

# Nginx配置文件下载地址
downnginxconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/nginx.conf"

# PHP配置文件下载地址
downphpconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/php.ini"

# PHP-FPM配置文件下载地址
downphpfpmconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/php-fpm.conf"

# MySQL配置文件下载地址
downmysqlconf="https://raw.githubusercontent.com/zjcnew/onekeynp/master/my.cnf"


# 源码包存储位置
soulocation="/data/src"

# 软件包的安装位置
tarlocation="/data/app"

# Nginx的安装位置
nginxtarlocation="$tarlocation/nginx"

# Apache的安装位置
apachetarlocation="$tarlocation/apache"

# PHP的安装位置
phptarlocation="$tarlocation/php"

# MySQL的安装位置
mysqltarlocation="$tarlocation/mysql"



input=""

if [ ! "$input" ]
then

  choose() {
    echo ""
    echo "1. Nginx"
    echo "2. Apache"
    echo "3. Nginx + PHP + PHP-FPM"
    echo "4. Apache + PHP"
    echo "5. Nginx + PHP + PHP-FPM + MySQL"
    echo "6. Apache + PHP + MySQL"  
    echo ""
    read -p "Please choose the type of deploy environment：" input
    echo ""
  }

fi


init_params() {
    choose
    case $input in
    1)
      downapache=""
      downphp=""
      downmysql=""
      downphpconf=""
      downphpfpmconf=""
      downmysqlconf=""
    ;;
    2)
      downnginx=""
      downphp=""
      downmysql=""
      downnginxconf=""
      downphpconf=""
      downphpfpmconf=""
      downmysqlconf=""
    ;;
    3)
      downapache=""
      downmysql=""
      downmysqlconf=""
    ;;
    4)
      downnginx=""
      downmysql=""
      downnginxconf=""
      downmysqlconf=""
    ;;
    5)
      downapache=""
    ;;
    6)
      downnginx=""
      downnginxconf=""
    ;;
    *)
      echo "error, choose again please"'!!'
      exit 1
    esac
}


check_variable ()
{
	
  if [ ! "$soulocation" ]
  then
    soulocation="/usr/src"
  fi
	
  if [ ! -d $soulocation ]
  then
    mkdir -p $soulocation
  fi

  if [ "$downnginx" ]
  then

    ls $soulocation/nginx* >/dev/null 2>&1

    if [ $? -eq 0 ]
    then
      echo "error, there are sommethings about nginx in $soulocation, Please clean up manually"'!!'
      exit 1
    fi

    if [ ! "$downnginxconf" ]
    then
      echo "error,Nginx Configuration file download location not specified"'!!'
      exit 1
    fi

    if [ ! "$nginxtarlocation" ]
    then
      nginxtarlocation="/usr/local/nginx"
    fi

  fi

	
  if [ "$downphp" ]
  then

    ls $soulocation/php* >/dev/null 2>&1

    if [ $? -eq 0 ]
    then
      echo "error, There are sommethings about php in $soulocation, Please clean up manually"'!!'
      exit 1
    fi

    if [ "$downnginx" ]
    then

      if [ ! "$downphpfpmconf" ]
      then
        echo "error,PHP-FPM Configuration file download location not specified"'!!'
        exit 1
      fi

    fi

    if [ ! "$phptarlocation" ]
    then
      phptarlocation="/usr/local/php"
    fi

  fi

	
  if [ "$downmysql" ]
  then

    ls $soulocation/mysql* >/dev/null 2>&1

    if [ $? -eq 0 ]
    then
      echo "error, There are sommethings about mysql in $soulocation, Please clean up manually"'!!'
      exit 1
    fi

    if [ ! "$downmysqlconf" ]
    then
      echo "error,MySQL Configuration file download location not specified"'!!'
      exit 1
    fi

    if [ ! "$mysqltarlocation" ]
    then
      mysqltarlocation="/usr/local/mysql"
    fi

  fi


  if [ "$downapache" ]
  then

    ls $soulocation/httpd* >/dev/null 2>&1

    if [ $? -eq 0 ]
    then
      echo "error, There are sommethings about apache in $soulocation, Please clean up manually"'!!'
      exit 1
    fi

  fi
		
}
	
	
download ()
{

  get_file ()
  {	
	
    if [ "$1" ]
    then
      cd $soulocation && \
      /usr/bin/curl -k -O $1 &&
      echo ''Downloaded $1 Successful'!'
    fi

  }

  get_file $downnginx
  get_file $downapache
  get_file $downphp
  get_file $downmysql
  get_file $downnginxconf
  get_file $downphpconf
  get_file $downphpfpmconf
  get_file $downmysqlconf

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
  else
    echo 'Sorry,This platform is not supported!!'
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
      os="other" && echo 'Error,The System type cannot be determined!!'
    fi
		
  else		
     echo 'Error,This is not a Linux platform!!'		
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
      sed -i "s/^\<SELINUX=.*/SELINUX=disabled/" /etc/sysconfig/selinux
      setenforce 0
      echo 'Warning,You must Restart the system to make the SELinux configuration take effect!'
      exit 0
    fi
	
  fi
	
}

correct_yum_repo ()
{

  cd /etc/yum.repos.d && rename .repo .bak *
  #rm -fr /etc/yum.repos.d/*
	
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
      yum install ntp ntpdate -y
      chkconfig ntpd on
      chkconfig ntpdate on
      chkconfig postfix off 2>/dev/null
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

if [ "$downnginx" -a "$downphp" ]
then
yum install -y \
gcc gcc-c++ telnet \
ncurses ncurses-devel \
libxml2 libxml2-devel curl-devel \
libpng libpng-devel bzip2 bzip2-devel \
libjpeg libjpeg-devel harfbuzz harfbuzz-devel \
pcre pcre-devel zlib zlib-devel \
freetype freetype-devel libmcrypt libmcrypt-devel \
openssl openssl-devel libicu-devel
fi

if [ "$downapache" -a "$downphp" ]
then
yum install -y \
gcc gcc-c++ perl \
libxml2-devel \
expat-devel libpng-devel \
gmp-devel libmcrypt-devel \
pcre-devel openssl-devel \
freetype-devel curl-devel


fi

if [ "$downmysql" ]
then
yum install -y make cmake gcc gcc-c++ \
ncurses-devel openssl-devel zlib-devel bison perl
fi

  elif [ $osver -eq 7 ]
  then

if [ "$downnginx" -a "$downphp" ]
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

if [ "$downapache" -a "$downphp" ]
then
yum install -y gcc cmake gcc-c++ \
apr-devel apr-util-devel \
openssl-devel apr-util-devel \
libxml2-devel libpng-devel \
libmcrypt-devel zlib-devel \
gmp-devel curl-devel \
freetype-devel
fi


if [ "$downmysql" ]
then
yum install -y \
make cmake gcc gcc-c++ \
chrony ncurses-devel openssl-devel \
zlib-devel bison perl-Data-Dumper
fi

  fi

}


ins_nginx_app ()
{

  if [ "$downnginx" ]
  then
    ls $soulocation/nginx*.tar.gz 2>/dev/null
    
    if [ $? -eq 0 ]
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

      id nginx 2> /dev/null

        if [ $? -eq 0 ]
        then

          if [ $(grep '^nginx' /etc/passwd | grep -c '/sbin/nologin') -eq 0 ]
	  then
	    usermod -s /sbin/nologin nginx
	  fi

        else
	  useradd -M -s /sbin/nologin nginx
        fi

        [ -f $soulocation/nginx.conf ] && /bin/cp -f $soulocation/nginx.conf $nginxtarlocation/conf/
        rm -fr $nginxtarlocation/html/*
        chown -R nginx.nginx $nginxtarlocation

      else
        echo 'Error, nginx installation failed!!'
        exit 2
      fi
	
	
      if [ $osver -eq 6 ]
      then

        if [ -f /etc/init.d/nginx ]
        then
          echo 'Warning,The nginx service is already exists!'
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
			
        if [ $? -eq 0 ]
        then
          chmod 755 /etc/init.d/nginx
	  install_nginx_status=1
	  chkconfig --add nginx
        fi
			
      elif [ $osver -eq 7 ]
      then

        if [ -f /usr/lib/systemd/system/nginx.service ]
        then
          echo 'Warning,The nginx service is already exists!'
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

    fi

  fi
	
}



ins_apache_app ()
{

  if [ "$downapache" ]
  then

    ls $soulocation/httpd*.tar.gz  2>/dev/null

    if [ $? -eq 0 ]
    then
      cd $soulocation && \
      tar zxvf httpd*.tar.gz && \
      cd httpd-*

      if [ $osver -eq 6 ]
      then
        aprtarlocation="$apachetarlocation/../apr" 2>/dev/null
        aprutiltarlocation="$apachetarlocation/../apr-util" 2>/dev/null

        cd $soulocation && \
        curl -O https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-1.6.3.tar.gz

        ls apr-*.tar.gz 2>/dev/null

        if [ $? -eq 0 ]
        then
          tar zxvf apr-*.tar.gz
          cd apr-* && ./configure --prefix=$aprtarlocation && make && make install && install_apr_status=1
        fi

        if [ "$install_apr_status" ]
        then

          if [ "$install_apr_status" -eq 1 ]
          then

	    cd $soulocation && \
            curl -O https://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-util-1.6.1.tar.gz

	    ls apr-util-*.tar.gz 2>/dev/null

            if [ $? -eq 0 ]
            then
	      tar zxvf apr-util-*.tar.gz
              cd apr-util-* && ./configure --prefix=$aprutiltarlocation --with-apr=$aprtarlocation && \
	      make && make install && install_aprutil_status=1
            fi

          fi

        else
          echo 'Error,apr compilation failed!!'
          exit 2
        fi


        if [ "$install_aprutil_status" ]
        then

          if [ "$install_aprutil_status" -eq 1 ]
          then
cd $soulocation/httpd-*
./configure --prefix=$apachetarlocation \
--enable-ssl --enable-so --with-pcre \
--enable-rewrite --with-mpm=worker \
--with-apr=$aprtarlocation \
--with-apr-util=$aprutiltarlocation
	  fi

        else
          echo "Error,apr-util compilation failed!!"
          exit 2
        fi

      elif [ $osver -eq 7 ]
      then
cd $soulocation/httpd-*
./configure --prefix=$apachetarlocation \
--enable-ssl --enable-so --with-pcre \
--enable-rewrite --with-mpm=worker
      fi


      if [ $? -eq 0 ]
      then
	make && make install

        if [ $? -eq 0 ]
        then
          #sed -i "242s/AllowOverride None/AllowOverride All/" $apachetarlocation/conf/httpd.conf
          sed -i "s/Options Indexes FollowSymLinks/Options  FollowSymLinks/" $apachetarlocation/conf/httpd.conf
          sed -i ':a;N;$!ba;s/AllowOverride None/AllowOverride All/' $apachetarlocation/conf/httpd.conf
          sed -i "s/DirectoryIndex index.html.*/DirectoryIndex index.html index.php/" $apachetarlocation/conf/httpd.conf
          sed -i "s/^Listen 80/Listen 0.0.0.0:80/" $apachetarlocation/conf/httpd.conf
	  sed -i "s/^#ServerName www.example.com:80/ServerName www.example.com:80/" $apachetarlocation/conf/httpd.conf
	  sed -i "s/^#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/" $apachetarlocation/conf/httpd.conf
	  sed -i "s/^#EnableSendfile on/EnableSendfile on/" $apachetarlocation/conf/httpd.conf
          sed -i "s:^#Include conf/extra/httpd-default.conf:Include conf/extra/httpd-default.conf:" $apachetarlocation/conf/httpd.conf
          sed -i "s/^ServerTokens.*/ServerTokens Prod/" $apachetarlocation/conf/httpd.conf
          sed -i "s:^#LoadModule deflate_module modules/mod_deflate.so:LoadModule deflate_module modules/mod_deflate.so:" $apachetarlocation/conf/httpd.conf
	  rm -f  $apachetarlocation/htdocs/*
	  chown -R daemon.daemon $apachetarlocation

cat >> $apachetarlocation/conf/httpd.conf << EOF

<FilesMatch "\.ph(p[2-6]?|tml)$">
    SetHandler application/x-httpd-php
</FilesMatch>

<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>

EOF

            if [ $osver -eq 6  ]
	    then

	      if [ -f /etc/init.d/apache ]
              then
                echo 'Warning,The apache service is already exists!'
              else
                /bin/cp -f $apachetarlocation/bin/apachectl /etc/init.d/apache
                sed -i "/#!\/bin\/sh/a# chkconfig: 2345 65 35" /etc/init.d/apache
                chmod 755 /etc/init.d/apache
                chkconfig --add apache
	      fi

              install_apache_status=1

	    elif [ $osver -eq 7 ]
	    then
cat > /usr/lib/systemd/system/apache.service << EOF
[Unit]
Description=Apache - HTTP Server
After=network.target mysql.service

[Service]
Type=forking
PIDFile=$apachetarlocation/logs/httpd.pid
ExecStart=$apachetarlocation/bin/httpd -k start
ExecStop=$apachetarlocation/bin/httpd -k stop
ExecReload=$apachetarlocation/bin/httpd -k graceful

[Install]
WantedBy=multi-user.target
EOF
	    systemctl enable apache.service
  	    install_apache_status=1

	    fi

        else
          echo 'Error,apache Compilation failed!!'
          exit 2
        fi

      fi

    fi

  fi

}


ins_php_app ()
{

  if [ "$downphp" ]
  then

    ls $soulocation/php*.tar.gz 2>/dev/null

    if [ $? -eq 0 ]
    then

      if [ "$install_nginx_status" ]
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
          make -j$(grep -c pro /proc/cpuinfo) && make install
	  rm -f /etc/php.ini
	  [ -f $soulocation/php.ini ] && /bin/cp -f $soulocation/php.ini $phptarlocation/etc/
	  [ -f $soulocation/php-fpm.conf ] && /bin/cp -f $soulocation/php-fpm.conf $phptarlocation/etc/php-fpm.conf
			
	  if [ $install_nginx_status -eq 1 ]
	  then
	    mkdir $phptarlocation/tmp
	    ln -s $phptarlocation/bin/* /usr/local/bin/ 2>/dev/null
	    chown nginx.nginx $phptarlocation/tmp/
            sed -i "s#^session.save_path =.*#session.save_path = \"$phptarlocation/tmp\"#" $phptarlocation/etc/php.ini
	  else
	    echo 'Warning,nginx is not installed successfully!'
	  fi
			
	  cd ..
	  yum install autoconf git -y
	  git clone https://github.com/phpredis/phpredis.git
	  cd phpredis && $phptarlocation/bin/phpize && ./configure --with-php-config=$phptarlocation/bin/php-config
	
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

          if [ -f /etc/init.d/php-fpm ]
          then
            echo 'Warning,The php-fpm service is already exists!'
          else
	    cd $soulocation/php-* && cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm

            if [ -f /etc/init.d/php-fpm ]
            then
	      sed -i "/# Required-Stop:/a# chkconfig: 2345 67 33" /etc/init.d/php-fpm
	      chmod 755 /etc/init.d/php-fpm
	      chkconfig --add php-fpm
	    fi

	  fi

	  install_php_fpm_status=1

        elif [ $osver -eq 7 ]
        then

          if [ -f /usr/lib/systemd/system/php-fpm.service ]
          then
            echo 'Warning,The php-fpm service is already exists!'
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

    fi




    if [ "$install_apache_status" ]
    then

      if [ "$install_apache_status" -eq 1 ]
      then
        cd $soulocation && tar zxvf php*.tar.gz && cd php-*
./configure --prefix=$phptarlocation \
--with-config-file-path=$phptarlocation/etc \
--with-apxs2=$apachetarlocation/bin/apxs \
--with-gd --with-openssl --with-mcrypt \
--enable-mbstring --with-zlib --with-curl \
--enable-sockets --with-gmp --enable-bcmath \
--enable-gd-native-ttf --with-freetype-dir \
--enable-mysqlnd --with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd 

        if [ $? -eq 0 ]
        then
	  make -j$(grep -c pro /proc/cpuinfo) && make install

	  if [ $? -eq 0 ]
	  then
       	    rm -f /etc/php.ini
            /bin/cp -f php.ini-production $phptarlocation/etc/php.ini
            mkdir -p $phptarlocation/tmp
            chown daemon.daemon $phptarlocation/tmp
	    sed -i "s/;date.timezone =/date.timezone = Asia\/Shanghai/" $phptarlocation/etc/php.ini
	    sed -i "s/^upload_max_filesize = 2M/upload_max_filesize = 15M/" $phptarlocation/etc/php.ini
            sed -i "s#;session.save_path = .*#session.save_path = \"$phptarlocation/tmp\"#" $phptarlocation/etc/php.ini
            sed -i "s/expose_php.*/expose_php = Off/" $phptarlocation/etc/php.ini
	    ln -s $soulocation/bin/php /usr/local/bin/ 2>/dev/null
            install_php_status=1
          else
	    echo 'Warning,php is not installed successfully!!'
 	    exit 2
	  fi

        else
	  echo 'Error, There was an error in configuring php Before compiling!!'
	fi

      fi

    fi

   fi

  fi

}		


ins_mysql_app ()
{

  if [ "$downmysql" ]
  then

    ls $soulocation/mysql*.tar.gz 2>/dev/null

    if [ $? -eq 0 ]
    then
      cd $soulocation && tar zxf mysql*.tar.gz
      cd $soulocation/mysql-*
cmake . -DCMAKE_INSTALL_PREFIX=$mysqltarlocation \
-DDEFAULT_SYSCONFDIR=$mysqltarlocation/etc \
-DMYSQL_DATADIR=$mysqltarlocation/data \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_UNIX_ADDR=$mysqltarlocation/mysql.sock \
-DENABLED_LOCAL_INFILE=1 -DWITH_SSL=system \
-DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_ZLIB=system -DWITH_LIBWRAP=0

      if [ $? -eq 0 ]
      then
        make -j$(grep -c pro /proc/cpuinfo)  && make install

        if [ $? -eq 0 ]
        then

          id mysql 2> /dev/null
	
	  if [ $? -eq 0 ]
          then

            if [ $(grep '^mysql' /etc/passwd | grep -c '/sbin/nologin') -eq 0 ]
            then
              usermod -s /sbin/nologin mysql
            fi

          else
            useradd -M -s /sbin/nologin mysql
          fi

	  mkdir -p $mysqltarlocation/{etc,log,run,tmp}
	  [ -f /etc/my.cnf ] && mv -f /etc/my.cnf /etc/my.cnf.bak
	  [ -d /etc/my.cnf.d ] && mv -f /etc/my.cnf.d /etc/my.cnf.d.bak
	  sed -i "s#^socket.*#socket          = $mysqltarlocation/mysql.sock#" $soulocation/my.cnf
	  sed -i "s#^log-error.*#log-error       = $mysqltarlocation/log/mysql.log#" $soulocation/my.cnf
	  sed -i "s#^pid-file.*#pid-file        = $mysqltarlocation/run/mysqld.pid#" $soulocation/my.cnf
	  sed -i "s#^datadir.*#datadir         = $mysqltarlocation/data#" $soulocation/my.cnf
	  sed -i "s#^tmpdir.*#tmpdir          = $mysqltarlocation/tmp#" $soulocation/my.cnf
	  /bin/cp -f $soulocation/my.cnf $mysqltarlocation/etc/
	  chown -R mysql.mysql  $mysqltarlocation

          if [ "$install_php_fpm_status" ]
          then
              if [ "$install_php_fpm_status" -eq 1 ]
              then
                  sed -i "s#^pdo_mysql.default_socket=.*#pdo_mysql.default_socket=$mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
                  sed -i "s#^mysql.default_socket =.*#mysql.default_socket = $mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
                  sed -i "s#^mysqli.default_socket =.*#mysqli.default_socket = $mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
              fi
          elif [ "$install_php_status" ]
          then
               if [ "$install_php_status" -eq 1 ]
               then
                   sed -i "s#^pdo_mysql.default_socket=.*#pdo_mysql.default_socket=$mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
                   sed -i "s#^mysql.default_socket =.*#mysql.default_socket = $mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
                   sed -i "s#^mysqli.default_socket =.*#mysqli.default_socket = $mysqltarlocation/mysql.sock#" $phptarlocation/etc/php.ini
               fi
          fi

          if [ $osver -eq 6 ]
          then

            if [ -f /etc/init.d/mysql ]
            then
              echo 'Warning,The mysql service is already exists!'
            else
              cp $mysqltarlocation/support-files/mysql.server /etc/init.d/mysql
              sed -i "/# Required-Stop:/a# chkconfig: 2345 67 33" /etc/init.d/mysql
              chmod 755 /etc/init.d/mysql
	      ln -s $mysqltarlocation/bin/* /usr/local/bin 2>/dev/null
              chkconfig --add mysql

            fi

            install_mysql_status=1

          elif [ $osver -eq 7 ]
          then

            if [ -f /usr/lib/systemd/system/mysql.service ]
            then
              echo 'Warning,The mysql service is already exists!'
            else
cat > /usr/lib/systemd/system/mysql.service << EOF
[Unit]
Description=MySQL Database Server Engine
After=network.target syslog.target

[Service]
Type=simple
User=mysql
Group=mysql
LimitNOFILE=65536
LimitNPROC=65536
LimitMEMLOCK=infinity
PIDFile=$mysqltarlocation/run/mysqld.pid
ExecStart=$mysqltarlocation/bin/mysqld_safe --defaults-file=$mysqltarlocation/etc/my.cnf --datadir=$mysqltarlocation/data --pid-file=$mysqltarlocation/run/mysqld.pid --log-error=$mysqltarlocation/log/mysql.log "$*"
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill \$MAINPID

[Install]
WantedBy=multi-user.target
EOF
	    fi

	    if [ $? -eq 0 ]
	    then
              systemctl enable mysql
	      ln -s $mysqltarlocation/bin/* /usr/local/bin
              install_mysql_status=1
	    fi

	  fi

	$mysqltarlocation/scripts/mysql_install_db --keep-my-cnf --user=mysql --basedir=$mysqltarlocation --datadir=$mysqltarlocation/data
        fi
			
      fi

    fi

  fi

}


logrotate ()
{

  if [ "$install_nginx_status" ]
  then

    if [ "$install_nginx_status" -eq 1 ]
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

  fi



  if [ "$install_apache_status" ]
  then

    if [ "$install_apache_status" -eq 1 ]
    then

cat > /etc/logrotate.d/apache << EOF
$apachetarlocation/logs/*_log {
        notifempty
        weekly
        rotate 15
        dateext
        missingok
        compress
        postrotate
          $apachetarlocation/bin/httpd -k graceful > /dev/null 2>/dev/null || true
        endscript
}
EOF

    fi

  fi



  if [ "$install_php_fpm_status" ]
  then

    if [ "$install_php_fpm_status" -eq 1 ]
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
        /bin/kill -USR2 \`cat $phptarlocation/var/run/php-fpm.pid\` 2>/dev/null
    endscript
}
EOF

    fi

  fi

}


start_service ()
{

  if [ $osver -eq 6 ]
  then

    if [ "$install_nginx_status" ]
    then

      if [ "$install_nginx_status" -eq 1 ]
      then
        /etc/init.d/nginx start
        if [ "$?" -eq 0 ]
        then
          echo "Nginx service started successfully"'!'
        else
          echo "Nginx service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_apache_status" ]
    then

      if [ "$install_apache_status" -eq 1 ]
      then
        /etc/init.d/apache start
        if [ "$?" -eq 0 ]
        then
          echo "Apache service started successfully"'!'
        else
          echo "Apache service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_php_fpm_status" ]
    then

      if [ "$install_php_fpm_status" -eq 1 ]
      then
        /etc/init.d/php-fpm start
        if [ "$?" -eq 0 ]
        then
          echo "Php-fpm service started successfully"'!'
        else
          echo "Php-fpm service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_mysql_status" ]
    then

      if [ "$install_mysql_status" -eq 1 ]
      then
        /etc/init.d/mysql start
        if [ "$?" -eq 0 ]
        then
          echo "Mysql service started successfully"'!'
        else
          echo "Mysql service started faild"'!!'
        fi
      fi

    fi


  elif [ $osver -eq 7 ]
  then

    if [ "$install_nginx_status" ]
    then

      if [ "$install_nginx_status" -eq 1 ]
      then
        systemctl start nginx
        if [ "$?" -eq 0 ]
        then
          echo "Nginx service started successfully"'!'
        else
          echo "Nginx service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_apache_status" ]
    then

      if [ "$install_apache_status" -eq 1 ]
      then
        systemctl start apache
        if [ "$?" -eq 0 ]
        then
          echo "Apache service started successfully"'!'
        else
          echo "Apache service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_php_fpm_status" ]
    then

      if [ "$install_php_fpm_status" -eq 1 ]
      then
        systemctl start php-fpm
        if [ "$?" -eq 0 ]
        then
          echo "Php-fpm service started successfully"'!'
        else
          echo "Php-fpm service started faild"'!!'
        fi
      fi

    fi

    if [ "$install_mysql_status" ]
    then

      if [ "$install_mysql_status" -eq 1 ]
      then
        systemctl start mysql
        if [ "$?" -eq 0 ]
        then
          echo "Mysql service started successfully"'!'
        else
          echo "Mysql service started faild"'!!'
        fi
      fi

    fi

  fi

}


  init_params
  detect_platform
  detect_release_version
  detect_cenred_version
  check_variable 
  crrect_cenred_selinux
  correct_yum_repo
  correct_sys_time
  opt_sysctl
  download
  ins_depen_pac 
  ins_nginx_app
  ins_apache_app
  ins_php_app
  ins_mysql_app
  logrotate
  start_service
