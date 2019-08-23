Linux平台一键部署Apache/Nginx+PHP+MySQL环境
======

## 支持系统
CentOS/RedHat 6/7

## 环境类型        

 以下为支持的环境类型，请选择一种环境进行部署
 - Nginx
 - Apache
 - MySQL
 - Nginx + PHP + PHP-FPM
 - Apache + PHP
 - Nginx + PHP + PHP-FPM + MySQL
 - Apache + PHP + MySQL

## 使用方法
 

 1. 下载脚本 curl -O [https://raw.githubusercontent.com/zjcnew/onekeynp/master/onekeyanpm.sh][1]
 2. 应用程序的源码包文件默认从对应的官网下载，您可以自由修改下载地址；安装位置默认 /data/app 目录，您也可修改安装到其他位置；
 3. 执行脚本 bash onekeyanpm.sh，选择环境类型即可自动部署；
 4. 网页代码上传目录（默认情况下）
     ### **Nginx**
- /data/app/nginx/html
     ### **Apache**
- /data/app/apache/htdocs
 5. 文件目录授权
     ### **Nginx**
- chown -R nginx.nginx /data/app/nginx/html
     ### **Apache**
- chown -R daemon.daemon /data/app/apache/htdocs
6. 服务启动/停止/重启用法（示例）
      ###  CentOS/Redhat **6**
 - /etc/init.d/nginx start
 - /etc/init.d/nginx stop
 - /etc/init.d/nginx restart
      ### CentOS/Redhat **7**
 - systemctl start nginx
 - systemctl stop nginx
 - systemctl restart nginx

 
## 目录规划

应用程序默认安装到 /data/app 目录下，如Nginx安装位置  /data/app/nginx，Apache安装位置 /data/app/apache；

 ### Nginx
 - 配置文件  nginx/conf/nginx.conf
 - 站点根目录  nginx/html
 - 日志目录 nginx/logs
 - 可执行文件 nginx/sbin/nginx
 - 进程文件 nginx/run/nginx.pid

### Apache

 - 配置文件：apache/conf/httpd.conf 
 - 站点根目录：apache/htdocs
 - 日志目录：apache/logs
 - 可执行文件目录：apache/bin
 - 模块文件目录：apache/modules

### PHP

 - 配置文件：php/etc/php.ini
 - 可执行文件目录：php/bin
 - 日志目录：php/var/log
 - 临时目录：php/tmp
 - 自定义模块目录：php/lib/php/extensions/no-debug-zts-20131226

### PHP-FPM

 - 配置文件：php/etc/php-fpm.conf
 - 进程文件：php/var/run/php-fpm.pid

### MySQL

 - 配置文件：mysql/etc/my.cnf
 - 数据目录：mysql/data
 - 可执行文件目录：mysql/bin
 - 进程文件：mysql/run/mysqld.pid
 - SOCK文件：mysql/mysql.sock
 - 日志目录：mysql/log
 - 临时目录：mysql/tmp


## 注意事项

 1. 请在优良网络环境中进行部署，以确保软件源代码包与相关配置文件均下载完整；
 2. 编译环境至少需要**2**GB的空闲内存空间（包含swap），否则可能会导致PHP编译失败！
 3. 目前仅支持使用.tar.gz压缩格式源代码安装包；
 4. 如果指定的安装位置存在即将安装的软件或相关的文件，请先手工清除；
 5. 同一个软件源代码安装包与配置文件的下载路径必须同时指定；
 6. 目前PHP仅支持5.6版本；MySQL仅支持5.6版本,且编译安装比较漫长，请耐心等待；
 7. 默认MySQL密码未设置，推荐使用 **mysql_secure_installation** 命令来设置root账户密码。

  [1]: https://raw.githubusercontent.com/zjcnew/onekeynp/master/onekeyanpm.sh
