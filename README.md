Linux平台下一键部署Apache/Nginx+PHP+MySQL环境
========

受支持的系统
----
        CentOS6/7
        RedHat6/7

使用方法
----
        1.下载脚本 curl -O https://raw.githubusercontent.com/zjcnew/onekeynp/master/onekeyanpm.sh
        2.修改脚本，配置需要安装的应用相关文件的下载地址，注释掉不需安装的应用。
        3.执行脚本自动安装 bash onekeyanpm.sh

注意事项
----
        1.可安装的环境类型,请选择一种环境安装!
	 Nginx
	 Apache
	 Nginx+PHP+PHP-FPM
	 Apache+PHP
	 Nginx+PHP+PHP-FPM+MySQL
	 Apache+PHP+MySQL
        2.编译环境至少需要2GB的空闲内存空间（包含swap），否则可能会导致PHP编译失败！
        3.目前仅支持使用.tar.gz压缩格式源代码安装包;
        4.如果指定的安装位置存在即将安装的软件或相关的文件，请先手工清除;
        5.同一个软件源代码安装包与配置文件的下载路径必须同时指定;
        6.MySQL仅支持5.6版本,且编译安装比较漫长，请耐心等待；
        7.默认MySQL密码未设置，推荐使用 mysql_secure_installation 命令来设置root账户密码。
