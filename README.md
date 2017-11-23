Linux平台下一键安装Nginx+PHP+MySQL环境Shell脚本
========

受支持的系统:
----
	CentOS6/7
	RedHat6/7	

使用方法:
----
	curl https://raw.githubusercontent.com/zjcnew/onekeynp/master/onekeynpm.sh | bash

注意事项：
----
	1.编译环境至少需要2GB的空闲内存空间（包含swap），否则可能会导致PHP编译失败！
	2.目前仅支持使用.tar.gz压缩格式源代码安装包;
	3.如果指定的安装位置存在即将安装的软件或相关的文件，请先手工清除;
	4.同一个软件源代码安装包与配置文件的下载路径必须同时指定;
	5.MySQL的编译安装比较漫长，请耐心等待；
