Linux平台一键部署Apache/Nginx+PHP+MySQL环境
========

支持系统
----
    CentOS/RedHat 6/7
        
环境类型        
----
    1.可安装的环境类型,请选择一种环境安装!
    
        Nginx
        Apache
        Nginx+PHP+PHP-FPM
        Apache+PHP
        Nginx+PHP+PHP-FPM+MySQL
        Apache+PHP+MySQL
        
    2.服务启动/停止/重启方法（示例）
    
        CentOS6：/etc/init.d/nginx start       CentOS7：systemctl start nginx
        CentOS6：/etc/init.d/nginx stop        CentOS7：systemctl stop nginx
        CentOS6：/etc/init.d/nginx restart     CentOS7：systemctl restart nginx

使用方法
----
    1.下载脚本 curl -O https://raw.githubusercontent.com/zjcnew/onekeynp/master/onekeyanpm.sh
    
    2.修改脚本，配置需要安装的应用相关文件的下载地址，注释掉不需安装的应用
    
    3.执行脚本自动安装 bash onekeyanpm.sh

注意事项
----

    1.编译环境至少需要2GB的空闲内存空间（包含swap），否则可能会导致PHP编译失败！
    
    2.目前仅支持使用.tar.gz压缩格式源代码安装包;
    
    3.如果指定的安装位置存在即将安装的软件或相关的文件，请先手工清除;
    
    4.同一个软件源代码安装包与配置文件的下载路径必须同时指定;
    
    5.目前PHP仅支持5.6版本；MySQL仅支持5.6版本,且编译安装比较漫长，请耐心等待；
    
    6.默认MySQL密码未设置，推荐使用 mysql_secure_installation 命令来设置root账户密码。
